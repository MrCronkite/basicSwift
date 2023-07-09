let numbers: [Int] = [1, 2, 5, 6, 8]

let string: String = "Hello world"


//MARK: map
func reversArrey(arr: [Any]) -> [Any] {
    var squareNumbers: [Any] = []
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

let reversString = reversArrey(arr: Array(arrayLiteral: string))
print(summNummbers())

//MARK: filter 
var arrey = numbers.filter { $0 > 4 }.sorted { $0 > $1 }
print(arrey)

arrey.sort { $0 < $1 }
print(arrey)

