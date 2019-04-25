package main

import (
	"fmt"
	"goeuler/pkg/goeulerlib"
	"os"
	"time"
)

func main() {
	start := time.Now()
	n := 10000
	for i := 0; i < n; i++ {
		total := 0
		for j := 0; j < n; j++ {
			if eulerlib.IsPermutation(i*i*i, j*j*j) {
				fmt.Printf("hit, i=%d, j=%d, i^3=%d, j^3=%d\n", i, j, i*i*i, j*j*j)
				total++
				if total == 5 {
					fmt.Println(i * i * i)
					elapsed := time.Since(start)
					fmt.Println("took %s", elapsed)
					os.Exit(0)
				}
			}

		}
	}
}
