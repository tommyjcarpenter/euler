package main

import (
	"fmt"
	"goeuler/pkg/goeulerlib"
	"strconv"
	"time"
)

// I consider my solution some hybrid of a branch and bound soln and memoization.
// It recurses through the state space, using memoization to not repeat solutions. However there are still 15! possible solutions (pick one of 15 from first row, one of 14 from second...).
// So we need a way to "prune" the search space.
// My solution was to drop the current tree before spawning any recursive calls from it, whenever the current solution, plus the max attainable from there (even with illegal solutions) is < the max attainaed soln so far.

var maxever = -1
var totalcalls = 0
var finalrowhit = 0

const levels = 15
const cols = 15

var a = [levels][cols]int{
	{7, 53, 183, 439, 863, 497, 383, 563, 79, 973, 287, 63, 343, 169, 583},
	{627, 343, 773, 959, 943, 767, 473, 103, 699, 303, 957, 703, 583, 639, 913},
	{447, 283, 463, 29, 23, 487, 463, 993, 119, 883, 327, 493, 423, 159, 743},
	{217, 623, 3, 399, 853, 407, 103, 983, 89, 463, 290, 516, 212, 462, 350},
	{960, 376, 682, 962, 300, 780, 486, 502, 912, 800, 250, 346, 172, 812, 350},
	{870, 456, 192, 162, 593, 473, 915, 45, 989, 873, 823, 965, 425, 329, 803},
	{973, 965, 905, 919, 133, 673, 665, 235, 509, 613, 673, 815, 165, 992, 326},
	{322, 148, 972, 962, 286, 255, 941, 541, 265, 323, 925, 281, 601, 95, 973},
	{445, 721, 11, 525, 473, 65, 511, 164, 138, 672, 18, 428, 154, 448, 848},
	{414, 456, 310, 312, 798, 104, 566, 520, 302, 248, 694, 976, 430, 392, 198},
	{184, 829, 373, 181, 631, 101, 969, 613, 840, 740, 778, 458, 284, 760, 390},
	{821, 461, 843, 513, 17, 901, 711, 993, 293, 157, 274, 94, 192, 156, 574},
	{34, 124, 4, 878, 450, 476, 712, 914, 838, 669, 875, 299, 823, 329, 699},
	{815, 559, 813, 459, 522, 788, 168, 586, 966, 232, 308, 833, 251, 631, 107},
	{813, 883, 451, 509, 615, 77, 281, 613, 459, 205, 380, 274, 302, 35, 805}}

func Value(level int, col int) int {
	return a[level][col]
}

func MaximumBelow(level int) int {
	sum := 0
	for i := level + 1; i < levels; i++ {
		sum += eulerlib.Max(a[i][:])
	}
	return sum
}

func GetTotalValue(chosen []int) int {
	sum := 0
	for i := 0; i < len(chosen); i++ {
		sum += Value(i, chosen[i])
	}
	return sum
}

func IsLegal(level int, chosen []int) bool {
	var accountedfor []int
	for i := 0; i <= level; i++ {
		if eulerlib.Contains(accountedfor, chosen[i]) {
			return false
		} else {
			accountedfor = append(accountedfor, chosen[i])
		}
	}
	return true
}

func FormKey(level int, col int, chosenabove []int) string {
	str := strconv.Itoa(level) + "|" + strconv.Itoa(col) + "|"
	for i := 0; i < len(chosenabove); i++ {
		str += strconv.Itoa(chosenabove[i])
	}
	return str

}

func recurse(level int, col int, chosenabove []int, cache map[string]int) int {
	thisentry := FormKey(level, col, chosenabove)
	if _, ok := cache[thisentry]; ok {
		return 0
	} else {
		cache[thisentry] = 1
	}

	mymatrix := append(chosenabove, col)
	totalcalls += 1

	// check out of bounds and return if so
	if level >= levels || col >= cols {
		//fmt.Printf("aborting, out of bounds %d %d\n", level, col)
		return 0
	}

	// this is absolutely critical, since we cannot visit all 15! solutions.
	// here we upper bound (by even assuming illegal solutions) how good we can do based on where we are, and see if it's less than the max ever found.
	// if this whole tree is dead: less than the best ever achieved, abondon and don't make any more recursive calls
	perceived_max_val := GetTotalValue(mymatrix) + MaximumBelow(level)
	if perceived_max_val < maxever {
		//fmt.Printf("aborting, can never achieve greatness %v, perceived max value %d\n", mymatrix, perceived_max_val)
		return 0
	}

	// if we are on the final level, compute our value
	if level == levels-1 {
		finalrowhit++
		completedvalue := GetTotalValue(mymatrix)
		// check if it's the new best ever
		if completedvalue > maxever {
			fmt.Printf("new max ever found %d with %v\n", completedvalue, mymatrix)
			maxever = completedvalue
		}
	}

	// choose this one, try with each below
	for i := 0; i < cols; i++ {
		if IsLegal(level+1, append(mymatrix, i)) {
			recurse(level+1, i, mymatrix, cache)
		}
	}
	// don't choose this one, try right
	for i := col + 1; i < cols; i++ {
		if IsLegal(level, append(chosenabove, i)) {
			recurse(level, i, chosenabove, cache)
		}
	}

	return 0
}

func main() {
	start := time.Now()
	var chosenabove []int
	cache := make(map[string]int)
	recurse(0, 0, chosenabove, cache)
	fmt.Printf("total calls entered: %d, final rows hit: %d, answer: %d\n", totalcalls, finalrowhit, maxever)
	fmt.Println("took %s", time.Since(start))
}
