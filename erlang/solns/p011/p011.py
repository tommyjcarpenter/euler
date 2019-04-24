#!/usr/local/bin/python3
matrix = []

#note, probably a more dynamic programing way to do this, but for 20x20, dont overengineer

lines = open("grid.txt", "r").readlines()
for l in lines:
    matrix.append([int(X) for X in l.strip().split(" ")])

maxm = -1
for i in range (3, 17):
    for j in range (3, 17):
        up = matrix[i][j]*matrix[i-1][j]*matrix[i-2][j]*matrix[i-3][j]
        down = matrix[i][j]*matrix[i-1][j]*matrix[i-2][j]*matrix[i-3][j]
        left = matrix[i][j]*matrix[i][j-1]*matrix[i][j-2]*matrix[i][j-3]
        right = matrix[i][j]*matrix[i][j+1]*matrix[i][j+2]*matrix[i][j+3]
        dupleft = matrix[i][j]*matrix[i-1][j-1]*matrix[i-2][j-2]*matrix[i-3][j-3]
        ddownleft = matrix[i][j]*matrix[i+1][j-1]*matrix[i+2][j-2]*matrix[i+3][j-3]
        dupright = matrix[i][j]*matrix[i-1][j+1]*matrix[i-2][j+2]*matrix[i-3][j+3]
        ddownright =  matrix[i][j]*matrix[i+1][j+1]*matrix[i+2][j+2]*matrix[i+3][j+3]
        a = [up, down, left, right, dupleft, ddownleft, dupright, ddownright]
        m = max(a)
        if m > maxm:
            maxm = m

print(maxm)




