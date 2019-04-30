package main

/*
The smallest number expressible as the sum of a prime square, prime cube, and prime fourth power is 28. In fact, there are exactly four numbers below fifty that can be expressed in such a way:

28 = 22 + 23 + 24
33 = 32 + 23 + 24
49 = 52 + 23 + 24
47 = 22 + 33 + 24

How many numbers below fifty million can be expressed as the sum of a prime square, prime cube, and prime fourth power?
*/

import (
	"fmt"
	"goeuler/pkg/goeulerlib"
	"time"
)

func main() {
	start := time.Now()
	// for the squares, we only need to go up to 7072, since more than that squared > 50M itself
	// for the cubes, 369
	// for the fourths, 85
	primes := eulerlib.Seive(7072)

	var squares []uint64
	var cubes []uint64
	var fourths []uint64
	for i := range primes {
		squares = append(squares, primes[i]*primes[i])
		if primes[i] < 369 {
			cubes = append(cubes, primes[i]*primes[i]*primes[i])
		}
		if primes[i] < 85 {
			fourths = append(fourths, primes[i]*primes[i]*primes[i]*primes[i])
		}

	}
	// squares = 908, cubes = 73, fourths = 23
	// max number of combos (way upper bound) = 1,524,532, easy peazy
	// have to use a map because we can have duplicates
	m := make(map[uint64]int)
	for i := range squares {
		for j := range cubes {
			for k := range fourths {
				sum := squares[i] + cubes[j] + fourths[k]
				if sum < 50000000 {
					m[sum] = 1

				}
			}
		}
	}
	fmt.Printf("total %d\n", len(m))
	fmt.Println("took %s", time.Since(start))
}
