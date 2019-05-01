package main

/*
It is possible to write five as a sum in exactly six different ways:

4 + 1
3 + 2
3 + 1 + 1
2 + 2 + 1
2 + 1 + 1 + 1
1 + 1 + 1 + 1 + 1

How many different ways can one hundred be written as a sum of at least two positive integers?
*/

import (
	"fmt"
	"goeuler/pkg/goeulerlib"
	"strconv"
	"time"
)

var cache map[string]int
var cachedcalls int
var calls int

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

func NumWays(target int, mustuse []int, forbidden []int) int {
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

		if newtarget == 0 { // 0 is done, 1 the only way is to add a 1
			returnans = 1
		} else {
			var avail []int
			// here we have every int between 1 and newtarget avail to us if not forbidden
			for i := 1; i <= newtarget; i++ {
				if !eulerlib.Contains(forbidden, i) {
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
				returnans = NumWays(newtarget, []int{chosen}, forbidden) +
					NumWays(newtarget, []int{}, append(forbidden, chosen))
			}
		}
		cache[str] = returnans
		return returnans
	}
}

func main() {
	start := time.Now()
	cache = make(map[string]int)
	numways := NumWays(100, []int{}, []int{}) - 1
	fmt.Printf("Calls %d cached calls %d\n", calls, cachedcalls)
	fmt.Println(numways)
	fmt.Println("took %s", time.Since(start))
}
