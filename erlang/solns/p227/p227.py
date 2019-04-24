from numpy import linalg as LA
import numpy as np

players = 100
dim = int(players / 2) + 1
one = 1.0/6.0

#OKAY take 2
#take 1 tried to model two markov chains, one for dice 1 and one for dice 2. However, I ran into issues with independence.
#this new attempt will try one markov chain, where the distance between the two dice is modelled. 
#There are 51 states representing the gap, with absorption at 0
def get_transition_matrix():
    """
    form 
       p11 p12 ... p1dim
       p21 p21 ... p2dim
       ...
       pdim1 pdim2 ... pdimdim
    """
    m = np.zeros([dim,dim], dtype = np.float64)
    
    for i in range(0, dim):
        #scenarios where neither move
        #2,2, 2,3, 2,4, 2,5,
        #3,2, 3,3, 3,4, 3,5,
        #4,2, 4,3, 4,4, 4,5,
        #5,2, 5,3, 5,4, 5,5
        
        #constant for all cases
        m[i][i] = 16.0/36.0#WILL BE UPDATED
        #both dice move left, 
        #both move right
        m[i][i] += 2.0/36.0

        
        if i == 0:
            m[i][i] = 1.0

        elif i == 1:
            ##Scenarios where 1 moves 1 stays (S):
            #{2,3,4,5},1, {2,3,4,5},6
            #1,{2,3,4,5}, 6,{2,3,4,5}
            #in the i = 1 case, both dice moving can lead to a swap in position
            #one stays, gap gets bigger. either dice can stay and the other can move
            m[i][i+1] = 8.0/36.0
            #same but gap gets smaller
            m[i][i-1] = 8.0/36.0 #GAME END

            #scenarios where both move
            #1,1, 1,6, 6,1, 6,6
            #both move in opposite directions away from each other, gap gets bigger by 2
            m[i][i+2] = 1.0/36.0
            #both move in opposite directions, but pass each other, leaving gap the same
            m[i][i] += 1.0/36.0

        elif 2 <= i <= dim-3: #min gap will be 0, max gap will be 50
            #Scenarios where 1 moves 1 stays (S):
            #{2,3,4,5},1, {2,3,4,5},6
            #1,{2,3,4,5}, 6,{2,3,4,5}
            #one stays, gap gets bigger. either dice can stay and the other can move
            m[i][i+1] = 8.0/36.0
            #same but gap gets smaller
            m[i][i-1] = 8.0/36.0

            #scenarios where both move
            #1,1, 1,6, 6,1, 6,6
            #both move in opposite directions away from each other, gap gets bigger by 2
            m[i][i+2] = 1.0/36.0
            #both move in opposite directions, gap gets smaller by 2
            m[i][i-2] = 1.0/36.0

        elif i == dim-2:
            #in this case a move in opposite directions keeps the gap the same
            #Scenarios where 1 moves 1 stays (S):
            #{2,3,4,5},1, {2,3,4,5},6
            #1,{2,3,4,5}, 6,{2,3,4,5}
            #one stays, gap gets bigger. either dice can stay and the other can move
            m[i][i+1] = 8.0/36.0
            #same but gap gets smaller
            m[i][i-1] = 8.0/36.0
            #both move in opposite directions, gap gets smaller by 2
            m[i][i-2] = 1.0/36.0
            #both move in opposite directions away from each other, gap stays same
            m[i][i] += 1.0/36.0

        elif i == dim - 1: 
            #furthest possible distance is dim (or dim -1 in 0 indexing). a dice move in either direction closes gap
            
            #Scenarios where 1 moves 1 stays (S):
            #{2,3,4,5},1, {2,3,4,5},6
            #1,{2,3,4,5}, 6,{2,3,4,5}
            m[i][i-1] = 16.0/36.0

            #scenarios where both move
            #1,1, 1,6, 6,1, 6,6
            #both move in opposite directions, gap gets bigger by 2 in both cases
            m[i][i-2] = 2.0/36.0
    for i in m:
        assert(np.sum(i) == 1)

    return m
            
P = get_transition_matrix()

#code for this part came from Markov Chain python package readme
#https://github.com/gvanderheide/discreteMarkovChain
hittingset=[0]

one = np.ones(dim, dtype=np.float64)
one[hittingset] = 0

i=0
k1 = np.zeros(dim, dtype=np.float64)
k2 = P.dot(k1)+one
while(LA.norm(k1-k2)>1e-10):
    k1=k2
    k2 = P.dot(k1)+one
    k2[hittingset] = 0
    i+=1
print(k2)
print(i)

#this produces 
#3780.61862172
#rounded to 10 SD is 
#3780.618622 

#The below stops changing at 3779.1186217952954, some kind of precision/roundoff errors happening
#http://ac.els-cdn.com/S0024379508000244/1-s2.0-S0024379508000244-main.pdf?_tid=811501d6-3fbe-11e7-903f-00000aacb360&acdnat=1495547490_e1b2aa2dfd8e80596759c6c77c75ed63
#s = 0
#s_old = 0
#i = 49
#j = 0
#for t in range(0,100000):
#    s_old = s
#    print(t)
#    P_t = LA.matrix_power(P, t)
#    s += P_t[j][j] - P_t[i][j]
#    print((s, s_old, s-s_old))
##
#







