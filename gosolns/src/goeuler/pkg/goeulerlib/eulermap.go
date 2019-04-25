package eulerlib

// see https://stackoverflow.com/questions/55839450/how-to-write-a-function-that-accepts-any-map/55839900#55839900
func KeyExists(m map[int]int, k int) bool {
	if _, ok := m[k]; ok {
		return true
	}
	return false
}
