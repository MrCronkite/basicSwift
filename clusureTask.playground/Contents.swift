let numbers: [Int] = [1, 2, 5, 6, 8]

func reversArrey(arr: [Int]) -> [Int] {
    var squareNumbers: [Int] = []
    arr.map { squareNumbers.insert($0, at: 0) }
    return squareNumbers
}

let newArrey = reversArrey(arr: numbers)

func sumNumbers(arrey: [Int]) -> Int {
    var number = 0
    arrey.map { if $0 % 2 == 0 { number += $0 } }
    return number
}

sumNumbers(arrey: numbers)

func summNummbers() -> Int {
    var number = 0
    (1...999).map { if $0 % 3 == 0 && $0 % 5 == 0 { number += $0 } }
    return number
}

print(summNummbers())
