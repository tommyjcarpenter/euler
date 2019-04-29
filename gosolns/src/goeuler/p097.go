package main

/*
The first known prime found to exceed one million digits was discovered in 1999, and is a Mersenne prime of the form 26972593−1; it contains exactly 2,098,960 digits. Subsequently other Mersenne primes, of the form 2p−1, have been found which contain more digits.

However, in 2004 there was found a massive non-Mersenne prime which contains 2,357,207 digits: 28433×27830457+1.

Find the last ten digits of this prime number.
*/

import (
	"fmt"
	"math/big"
	//"goeuler/pkg/goeulerlib"
	"time"
)

func Compute() {
	// Initialize limit as 10^99, the smallest integer with 100 digits.
	p := new(big.Int).Exp(big.NewInt(2), big.NewInt(7830457), nil)
	m := new(big.Int).Mul(big.NewInt(28433), p)
	a := new(big.Int).Add(m, big.NewInt(1))
	ans := new(big.Int).Mod(a, big.NewInt(10000000000))
	fmt.Println(ans)
}

func main() {
	start := time.Now()
	Compute()
	fmt.Println("took %s", time.Since(start))
}
