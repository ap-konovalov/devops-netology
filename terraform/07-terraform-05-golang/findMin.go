package main

import "fmt"

func main(){
    x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17}

    fmt.Println(FindMin(x))
}

func FindMin(numbers []int) int {
    var min int = numbers[0]
    for _, number := range numbers{
        if min > number{
            min = number
        }
    }
    return min
}