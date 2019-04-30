#Too much text processing to do in Erlang, sorry Erlang, going python here. 

#In the card game poker, a hand consists of five cards and are ranked, from lowest to highest, in the following way:

#High Card: Highest value card.
#One Pair: Two cards of the same value.
#Two Pairs: Two different pairs.
#Three of a Kind: Three cards of the same value.
#Straight: All cards are consecutive values.
#Flush: All cards of the same suit.
#Full House: Three of a kind and a pair.
#Four of a Kind: Four cards of the same value.
#Straight Flush: All cards are consecutive values of same suit.
#Royal Flush: Ten, Jack, Queen, King, Ace, in same suit.
#The cards are valued in the order:
#2, 3, 4, 5, 6, 7, 8, 9, 10, Jack, Queen, King, Ace.
#
#If two players have the same ranked hands then the rank made up of the highest value wins; for example, a pair of eights beats a pair of fives (see example 1 below). But if two ranks tie, for example, both players have a pair of queens, then highest cards in each hand are compared (see example 4 below); if the highest cards tie then the next highest cards are compared, and so on.
#
#Consider the following five hands dealt to two players:
#
#Hand	 	Player 1	 	Player 2	 	Winner
#1	 	5H 5C 6S 7S KD
#Pair of Fives
# 	2C 3S 8S 8D TD
#Pair of Eights
# 	Player 2
#2	 	5D 8C 9S JS AC
#Highest card Ace
# 	2C 5C 7D 8S QH
#Highest card Queen
# 	Player 1
#3	 	2D 9C AS AH AC
#Three Aces
# 	3D 6D 7D TD QD
#Flush with Diamonds
# 	Player 2
#4	 	4D 6S 9H QH QC
#Pair of Queens
#Highest card Nine
# 	3D 6D 7H QD QS
#Pair of Queens
#Highest card Seven
# 	Player 1
#5	 	2H 2D 4C 4D 4S
#Full House
#With Three Fours
# 	3C 3D 3S 9S 9D
#Full House
#with Three Threes
# 	Player 1
#The file, poker.txt, contains one-thousand random hands dealt to two players. Each line of the file contains ten cards (separated by a single space): the first five are Player 1's cards and the last five are Player 2's cards. You can assume that all hands are valid (no invalid characters or repeated cards), each player's hand is in no specific order, and in each hand there is a clear winner.
#
#How many hands does Player 1 win?

def hand_str_to_hands(hand_str):
    cs = hand_str.split(" ")
    p1_hand = cs[0:5]
    p2_hand = cs[5:10]
    return p1_hand, p2_hand

def hand_to_suit_nums(hand):
    l = [list(x) for x in hand]
    nums = fix_nums([l[x][0] for x in range(0,5)])
    suits = [l[x][1] for x in range(0,5)]
    return nums, suits

def fix_nums(nums):
    #forum clarification indicates that ace is only high...
    return sorted([int(x.replace("T", "10").replace("J", "11").replace("Q", "12").replace("K", "13").replace("A", "14")) for x in nums])

def freq_dist(nums):
    d = {}
    for num in nums:
        if num in d:
            d[num] = d[num] + 1
        else:
            d[num] = 1
    return d

def count_abstraction(hand, key_length, value_list):
    nums, _ = hand_to_suit_nums(hand)
    df = freq_dist(nums)
    if len(df.keys()) == key_length: 
        return sorted(df.values(), reverse=True) == value_list 
    return False

####
#Poker methods
####
def high_card(hand):
    """Hand is a hc"""
    return count_abstraction(hand, 5, [1,1,1,1,1]) #note, can still be a strait, check that first

def one_pair(hand):
    """Hand is a 1p"""
    return count_abstraction(hand, 4, [2,1,1,1])

def two_pair(hand):
    """Hand is a 2p"""
    return count_abstraction(hand, 3, [2,2,1])

def toak(hand):
    """Hand is a 3OAK"""
    return count_abstraction(hand, 3, [3,1,1])

def strait(hand):
    """Hand is a strait"""
    nums, _ = hand_to_suit_nums(hand)
    return nums[1] == nums[0] + 1 and nums[2] == nums[1] + 1 and nums[3] == nums[2] + 1 and nums[4] == nums[3] + 1

def flush(hand):
    """hand is a flush"""
    _, suits = hand_to_suit_nums(hand)
    return suits == ["C"]*5 or suits == ["D"]*5 or suits == ["H"]*5 or suits == ["S"]*5  

def full_house(hand):
    """Hand is a full house"""
    return count_abstraction(hand, 2, [3,2])

def foak(hand):
    """Hand is a 4OAK"""
    return count_abstraction(hand, 2, [4,1])

def strait_flush(hand): 
    """Hand is a strait flush"""
    return strait(hand) and flush(hand)

def rf(hand):
    """Hand is a royal flush"""
    nums, _ = hand_to_suit_nums(hand)
    return flush(hand) and nums == [10,11,12,13,14]

###
#Comparisons
###
def score(hand):
    """1 -> high card, 10 -> rf"""
    if rf(hand):
        return 10
    if strait_flush(hand):
        return 9
    if foak(hand):
        return 8
    if full_house(hand):
        return 7
    if flush(hand):
        return 6
    if strait(hand):
        return 5
    if toak(hand):
        return 4
    if two_pair(hand):
        return 3
    if one_pair(hand):
        return 2
    if high_card(hand):
        return 1

def compare(hand1, hand2):
    """Returns 1 if hand1 > hand2, or 0 otherwise. I.e., a tie returns 0"""
    h1s = score(hand1)
    h2s = score(hand2)
    if h1s > h2s:
        return True
    if h2s > h1s:
        return False
    if h1s == h2s:
        nums1, suits1 = hand_to_suit_nums(hand1)
        nums2, suits2 = hand_to_suit_nums(hand2)

        fd1 = freq_dist(nums1)
        fd2 = freq_dist(nums2)

        keys_1_by_value = list(sorted(fd1, key=fd1.get, reverse=True))
        keys_2_by_value = list(sorted(fd2, key=fd2.get, reverse=True))

        if h1s == 1: #TODO! Does not move onto next highest card!!
            if max(nums1) > max(nums2):
                return True
            if max(nums2) > max(nums1):
                return False
            else:
                print("next card same score comparison not yet implemented for score={0}".format(h1s))
    
        if h1s == 2:
            return keys_1_by_value[0] > keys_2_by_value[0]
        else:
            print("same score comparison not yet implemented for score={0}".format(h1s))
            return None

###
#Run
###

scores = []
with open("p054_poker.txt") as f:
    lines = f.readlines()
    for l in lines:
        hand1, hand2 = hand_str_to_hands(l.strip())
        scores.append(compare(hand1, hand2))
print(len([x for x in scores if x is True]))
