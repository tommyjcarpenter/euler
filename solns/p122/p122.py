class Node():
    def __init__(self, Tup):
        self.num1 = Tup[0]
        self.num2 = Tup[1]
        self.left_children = []
        self.right_children = []
        self.expanded = False

def expand_node(N):
    new_l_pairs = sorted([(A, B) for A in range(1, N.num1) for B in range(1, N.num1) if A >= B and A+B == N.num1])
    N.left_children = [Node(p) for p in new_l_pairs]
    new_r_pairs = sorted([(A, B) for A in range(1, N.num2) for B in range(1, N.num2) if A >= B and A+B == N.num2]) 
    N.right_children = [Node(p) for p in new_r_pairs]
    N.expanded == True

def process_node(N, cache = {}):
    if (N.num1,N.num2) in cache:
        return cache[(N.num1, N.num2)]
    
    expand_node(N)

    free_set = [1] 

    if N.num1 == 1: #left always >= right
        minimum_l = 0
        minimum_r = 0
        min_LF = []
        RF = []
    else:
        minimum_l = 10000000000000000
        LFs = []
        for i, L in enumerate(N.left_children):
            val, FS = process_node(L)
            if val < minimum_l:
                minimum_l = val
                LFs = [FS]
            if val == minimum_l:
                LFs.append(FS) #if there are multiple ways to get to the minimum, one might be
                #more beneficial when it comes to num2, so we need to try all
        
        #no more left children 
        minimum_r = 10000000000000000
        for LF_to_try in LFs: #now try all the minumums from other path
            free_set = [N.num1] + LF_to_try
            if N.num2 in free_set:
                minimum_r = 0
                min_LF = LF_to_try
                RF = []
                break
            else:
                for i, R in enumerate(N.right_children):
                    val, FS = process_node(R)    
                    if val < minimum_r:
                        minimum_r = val
                        min_LF = LF_to_try
                        RF = FS
        #add num2 to FS
    free_set = [N.num1] + min_LF + RF + [N.num2]
    free_set = list(set(free_set))
    fin = 1 + minimum_l + minimum_r
    cache[(N.num1, N.num2)] = fin, free_set
    return fin, free_set

def do(P):
    S = 0
    for i in range(1,P):
        R, _ = process_node(Node((i, 1)))
        A=R-1
        S= S+A
    print(S)

do(201)

