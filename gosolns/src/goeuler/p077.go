package main

/*
It is possible to write ten as the sum of primes in exactly five different ways:

7 + 3
5 + 5
5 + 3 + 2
3 + 3 + 2 + 2
2 + 2 + 2 + 2 + 2

What is the first value which can be written as the sum of primes in over five thousand different ways?
*/

import (
	"fmt"
	"goeuler/pkg/goeulerlib"
	"strconv"
	"time"
)

var primes []uint64
var cache map[string]int
var calls int
var cachedcalls int

func FormCacheKey(n int, mustuse []int, forbidden []int) string {
	str := strconv.Itoa(n) + "|"
	for i := range mustuse {
		str += strconv.Itoa(mustuse[i])
	}
	str += "|"
	for i := range forbidden {
		str += strconv.Itoa(forbidden[i])
	}

	return str
}

// returns the number of ways n can be written as a sum of primes
func NumWays(target int, mustuse []int, debug []int, forbidden []int) int {
	calls++
	str := FormCacheKey(target, mustuse, forbidden)

	if eulerlib.KeyExistsStringInt(cache, str) {
		cachedcalls++
		return cache[str]
	} else {
		var returnans int

		newtarget := target
		if len(mustuse) == 1 {
			newtarget = target - mustuse[0]
		}

		if newtarget == 0 {
			returnans = 1
		} else {
			var avail []int
			// we have every int avail to us between 2 and newtarget, as long as its prime and not forbidden
			for i := 2; i <= newtarget; i++ {
				// this could be made more efficient by making a map out of primes
				if !eulerlib.Contains(forbidden, i) && eulerlib.ContainsUint64(primes, uint64(i)) {
					avail = append(avail, i)
				}
			}
			if len(avail) == 0 {
				returnans = 0
			} else {
				// both min and max work here, but min is way faster.
				// Way less calls are made when we use min
				//chosen := eulerlib.Max(avail)
				chosen := eulerlib.Min(avail)

				// ways to make n is ways to make n with p, ways to make n without p
				returnans = NumWays(newtarget, []int{chosen}, append(debug, chosen), forbidden) +
					NumWays(newtarget, []int{}, debug, append(forbidden, chosen))

			}
		}
		cache[str] = returnans
		return returnans
	}
}

func DoNumWays(n int) int {
	cache = make(map[string]int)
	calls = 0
	cachedcalls = 0
	numways := NumWays(n, []int{}, []int{}, []int{})
	fmt.Printf("Calls %d cached calls %d\n", calls, cachedcalls)
	return numways
}

func main() {
	start := time.Now()
	// for the squares, we only need to go up to 7072, since more than that squared > 50M itself
	// for the cubes, 369
	// for the fourths, 85
	primes = eulerlib.Seive(100)
	cache = make(map[string]int)
	x := 10
	for {
		s := DoNumWays(x)
		fmt.Printf("%d=%d\n", x, s)
		if s >= 5000 {
			break
		}
		x++
	}
	fmt.Println("took %s", time.Since(start))
}
