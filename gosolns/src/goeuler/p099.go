/*
Comparing two numbers written in index form like 211 and 37 is not difficult, as any calculator would confirm that 211 = 2048 < 37 = 2187.

However, confirming that 632382518061 > 519432525806 would be much more difficult, as both numbers contain over three million digits.

Using base_exp.txt (right click and 'Save Link/Target As...'), a 22K text file containing one thousand lines with a base/exponent pair on each line, determine which line number has the greatest numerical value.

NOTE: The first two lines in the file represent the numbers in the example given above.
*/

package main

import (
	"fmt"
	"goeuler/pkg/goeulerlib"
	"math"
	"strconv"
	"strings"
	"time"
)

func main() {

	start := time.Now()

	lines, _ := eulerlib.ReadLines("p099_base_exp.txt")
	max := float64(-1.0)
	max_line := -1
	line := 1
	for i := range lines {
		l := strings.Split(lines[i], ",")
		base, _ := strconv.Atoi(l[0])
		exp, _ := strconv.Atoi(l[1])

		// transform a^b -> b log a, which is much smaller to compute
		// We essentially need to scale every item down to something we can calculate while preserving the sort order
		e := float64(exp) * math.Log10(float64(base))
		if e > max {
			fmt.Printf("new max found on %d\n", line)
			max = e
			max_line = line
		}
		line++
	}
	fmt.Println(max_line)

	fmt.Println("took %s", time.Since(start))

}
