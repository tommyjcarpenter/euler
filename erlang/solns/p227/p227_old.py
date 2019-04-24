from numpy import linalg as LA
import numpy as np
import random

#np.set_printoptions(threshold=np.nan)

dim = 100
one = 1.0/6.0

# My initial thought is that this is a Markov chain problem. 
# My plan at the time of writing is soemthng like:
    # 1) build the transition diagram
    # 2) A = multiply by [1,0,.....]
    # 3) B = multiply by [0,....,1(51st position),0,.......]
    # then for turn t:
    #     multiply A*M^T, gives probability dice 1 is in each state
    #     multiple B*M^T, gives probability dice 2 is in each state
    #     (A*M^T)(B*M^T) is the joint probability that A,B are in the same space at T
    #     sum over all states in this joint to get the probability game over = p(both dice in 1)+...+p(both dice in 2)
    #     transorm this into the probability that the FIRST occurence of a win is on t
    #         ^ CURRENT PROBLEM
    #     multiply this by t to get tp(t)
    #...  somehow know when to stop... havent figured out that part yet. maybe the joint probability stops changing or something

# Imagine a ring of people arranged like a clock with person 1 at 12 o clock
# then the picture looks like:
#            1
#          2   100
#        3       99
#           ...
#      26           76
#           ...
#            51
#We can build a 100x100 transition matrix where going j "across" is like 1 passing left, e.g., 1->100->99->...->2->1
#and i going "down" is like 1 passing right, e.g., 1->2->3->...->100->1
#when building this transition matrix, we have to be careful in the pivot positions [0][0] and [99][99] to "switch to the opposite corner"

transition_mat = np.zeros([dim,dim], dtype=np.float64) # matrix equiv. of the imaginary unit
#print(LA.matrix_power(i, -3)) # should = 1/(-i) = i, but w/ f.p. elements
for i in range(0,dim):
    for j in range(0,dim):
        if i == j:
            if i == 0: #position 1 can pass to 100
                transition_mat[0][dim-1] = one
            if i > 0:
                transition_mat[i-1][j] = one
            if i < dim-1:
                transition_mat[i+1][j] = one
            if j > 0:
                transition_mat[i][j-1] = one
            if j < dim-1:
                transition_mat[i][j+1] = one
            if i == dim-1:
                transition_mat[dim-1][0] = one
            transition_mat[i][j] = 4.0/6.0
A = np.zeros([dim],dtype=np.float64) 
A[1] = 1.0
B = np.zeros([dim],dtype=np.float64) 
B[int(dim/2+1)] = 1.0 #1 is across from 51

def iterate():
    return doiterate(1,0,[])
def doiterate(t, Sum, priors):
    while True:
         if t > 4000:
             return Sum
         else:
             #[p(dice 1 in state 1 after t),....,p(dice 1 in state n after t)]
             C = np.matmul(A, LA.matrix_power(transition_mat,t))
             #[p(dice 2 in state 1 after t),....,p(dice 2 in state n after t)]
             D = np.matmul(B, LA.matrix_power(transition_mat,t))
             #p(game over) = sum([p(both dices in state 1), ..., p(both dices in state 100)])
             #these are mutually exclusive: both dices cant be in two states, so we can add these
             #and  
             #[p(both dices in state 1), ..., p(both dices in state 100)] = 
             #[p(dice 1 state 1)*p(dice 2 state 1),....]
             #Independent so can multiply

             #this is p that the game is over now
             p_ends_now = np.dot(C,D) 

             #calculate p(first occurence of win is on t)
             #see https://stats.stackexchange.com/questions/280537/transformation-of-probability-of-occurrence-to-prob-of-first-occurrence

             #CURRENT PROBLEM IS THAT THIS BLOCK VIOLATES DEPENDENCE ASSUMPTION
             #####PROBLEM BLOCK
             p_t_is_first = p_ends_now
             if t > 1:
                 p_never_ended_before = 1
                 for p in range(0, t-1):
                     p_never_ended_before *= (1.0-priors[p])

                 p_t_is_first = p_ends_now*p_never_ended_before
             #####PROBLEM BLOCK OVER
            
             #compute i*p_i, part of the expected value Sum, e.g., E(t) = 1p_1_is_first + 2p_2_is_first + ...
             tp_ends_at_t = t*p_t_is_first 
             Sum += tp_ends_at_t
             
             #print and update for next iteration
             #WOULD BE RECURSIVE IF NOT FOR http://stackoverflow.com/questions/13591970/does-python-optimize-tail-recursion
             print((t, p_ends_now, p_t_is_first, tp_ends_at_t, np.sum(priors),  Sum))
             t+=1
             priors.append(p_ends_now)
    
print(iterate())

#print(transition_mat)

def monte_run():
    A = 1
    B = dim/2+1
    Runs = 0
    while A != B:
        Runs += 1
        r1 = random.random()
        r2 = random.random()
        if r1 < 1.0/6.0:
            A = A-1 if A > 1 else dim
        elif r1 < 5.0/6.0:
            pass
        else:
            A = A+1 if A < dim else 1

        if r2 < 1.0/6.0:
            B = B-1 if B > 1 else dim
        elif r2 < 5.0/6.0:
            pass
        else:
            B = B+1 if B < dim else 1
    return Runs

#Runs = []
#for r in range(1,100000):
#    Runs.append(monte_run())
#print(np.average(Runs))
#print(np.var(Runs))









