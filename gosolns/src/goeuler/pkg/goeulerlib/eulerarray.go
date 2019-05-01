package eulerlib

// Contains tells whether a contains x.
func Contains(a []int, x int) bool {
	for _, n := range a {
		if x == n {
			return true
		}
	}
	return false
}

func ContainsUint64(a []uint64, x uint64) bool {
	for _, n := range a {
		if x == n {
			return true
		}
	}
	return false
}

func Max(v []int) int {
	m := -1
	for i := 0; i < len(v); i++ {
		if v[i] > m {
			m = v[i]
		}
	}
	return m
}

func Min(v []int) (m int) {
	if len(v) > 0 {
		m = v[0]
	}
	for i := 1; i < len(v); i++ {
		if v[i] < m {
			m = v[i]
		}
	}
	return
}

func Sum(l []int) int {
	sum := 0
	for i := range l {
		sum += l[i]
	}
	return sum
}
