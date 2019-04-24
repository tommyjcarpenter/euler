package eulermath

import (
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
