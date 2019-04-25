package eulerlib

import (
	"math"
	"reflect"
	"strconv"
)

// how is this not in the math lib????
func Factorial(n int) (result int) {
	if n > 0 {
		result = n * Factorial(n-1)
		return result
	}
	return 1
}

// is x a permutation of y
func IsPermutation(x int, y int) bool {
	str1 := strconv.Itoa(x)
	str2 := strconv.Itoa(y)
	if len(str1) != len(str2) {
		return false
	}
	m1 := make(map[byte]int)
	m2 := make(map[byte]int)
	for i := 0; i < len(str1); i++ {
		b1 := str1[i]
		if _, ok := m1[b1]; ok {
			m1[b1]++
		} else {
			m1[b1] = 1
		}

		b2 := str2[i]
		if _, ok := m2[b2]; ok {
			m2[b2]++
		} else {
			m2[b2] = 1
		}
	}
	return reflect.DeepEqual(m1, m2)
}

// https://www.quora.com/How-do-I-find-the-number-of-digits-in-a-product-of-two-numbers
// I thought I needed this for problem 99 but this doesn't help problem 99 because it requires to know a and b. But maybe it will be useful later.
func DigitsInProduct(a int, b int) int {
	// Floor (Log (A) + Log(B)) + 1
	return int(math.Floor(math.Log10(float64(a))+math.Log10(float64(b)))) + 1
}
