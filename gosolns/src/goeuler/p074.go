package main

/*
The number 145 is well known for the property that the sum of the factorial of its digits is equal to 145:

1! + 4! + 5! = 1 + 24 + 120 = 145

Perhaps less well known is 169, in that it produces the longest chain of numbers that link back to 169; it turns out that there are only three such loops that exist:

169 → 363601 → 1454 → 169
871 → 45361 → 871
872 → 45362 → 872

It is not difficult to prove that EVERY starting number will eventually get stuck in a loop. For example,

69 → 363600 → 1454 → 169 → 363601 (→ 1454)
78 → 45360 → 871 → 45361 (→ 871)
540 → 145 (→ 145)

Starting with 69 produces a chain of five non-repeating terms, but the longest non-repeating chain with a starting number below one million is sixty terms.

How many chains, with a starting number below one million, contain exactly sixty non-repeating terms?
*/

import (
	"fmt"
	"strconv"
	"time"
)

func DigitFac(n int) int {
	switch n {
	case 0:
		return 1
	case 1:
		return 1
	case 2:
		return 2
	case 3:
		return 6
	case 4:
		return 24
	case 5:
		return 120
	case 6:
		return 720
	case 7:
		return 5040
	case 8:
		return 40320
	case 9:
		return 362880
	}
	return -1
}
func main() {
	start := time.Now()

	sixtytotal := 0

	for i := 1; i < 1000000; i++ {

		k := 0
		m := make(map[int]int) // map that stores what ints we've hit so far
		total := i

		for {
			k++
			m[total] = k

			digits := strconv.Itoa(total)
			total = 0
			for j := 0; j < len(digits); j++ {
				d, _ := strconv.Atoi(string(digits[j]))
				total += DigitFac(d)
			}

			// see if this total is already in the map for i
			_, ok := m[total]
			if ok { // we've looped
				if len(m) == 60 {
					sixtytotal++
				}
				break
			}
		}

	}
	fmt.Println(sixtytotal)
	elapsed := time.Since(start)
	fmt.Println("took %s", elapsed)
}
