package main

import "fmt"

func main(){
    fmt.Print("Enter the number of meters: ")
    var input float64
    fmt.Scanf("%f", &input)

    output := input / 0.3048

    fmt.Println("in \"", input, "\" meters there are \"", output, "\" feet's")
}