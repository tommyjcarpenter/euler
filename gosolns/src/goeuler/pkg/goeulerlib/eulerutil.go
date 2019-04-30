package eulerlib

import (
	"github.com/kavehmz/prime"
)

func Seive(n uint64) []uint64 {
	return prime.Primes(n)
}

func Memoize(f func(int) int) func(int) int {
	// this relies on closure magic
	// https://forum.golangbridge.org/t/memoization-in-go/7285/10
	// e.g.,	Fact := eulerlib.Memoize(eulerlib.Factorial
	cache := make(map[int]int)
	return func(n int) int {
		if cache[n] == 0 {
			cache[n] = f(n)
		}
		return cache[n]
	}
}
