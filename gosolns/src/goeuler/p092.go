package main

/*
A number chain is created by continuously adding the square of the digits in a number to form a new number until it has been seen before.

For example,

44 → 32 → 13 → 10 → 1 → 1
85 → 89 → 145 → 42 → 20 → 4 → 16 → 37 → 58 → 89

Therefore any chain that arrives at 1 or 89 will become stuck in an endless loop. What is most amazing is that EVERY starting number will eventually arrive at 1 or 89.

How many starting numbers below ten million will arrive at 89?
*/

import (
	"fmt"
	"strconv"
	"time"
)

func main() {
	start := time.Now()

	eightynine := 0

	for i := 1; i < 10000000; i++ {
		if i%100000 == 0 {
			fmt.Println(i)
		}
		m := make(map[int]int) // map that stores what ints we've hit so far
		total := i

		for {
			m[total] = 1

			digits := strconv.Itoa(total)
			total = 0
			for j := 0; j < len(digits); j++ {
				d, _ := strconv.Atoi(string(digits[j]))
				total += d * d
			}

			if total == 89 {
				eightynine++
				break
			}
			if total == 1 {
				break
			}

		}

	}
	fmt.Println(eightynine)
	elapsed := time.Since(start)
	fmt.Println("took %s", elapsed)
}
