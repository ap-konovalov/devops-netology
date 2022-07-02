package main

import "fmt"

func main(){
    var result []int
    for i := 1; i <= 100; i++ {
        if IsDivisibleByThree(i) {
            result = append(result, i)
        }
    }
    fmt.Println(result)
}

func IsDivisibleByThree(number int) bool {
    return number % 3 == 0
}