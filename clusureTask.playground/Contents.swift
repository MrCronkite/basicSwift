let numbers: [Int] = [1, 2, 5, 6, 8, 23, 21, 12, 43, 12, 12, 98, 45]

let string: String = "Hello world"





//MARK: - MAP
func reversArrey(arr: [Any]) -> [Any] {
    var squareNumbers: [Any] = []
    arr.map { squareNumbers.insert($0, at: 0) }
    return squareNumbers
}

let newArrey = reversArrey(arr: numbers)

print(newArrey)

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




//MARK: - Filter, forEach, sorted
var arrey = numbers.filter { $0 > 4 }.sorted { $0 > $1 }
print(arrey)

arrey.sort(by: < )

var equelArrey: [Int] = []

arrey.forEach {
    if equelArrey.firstIndex(of: $0) == nil {
        equelArrey.append($0)
    }
}

print(equelArrey)

let names = ["Vlad", "Dima", "Katia"]

var bingo = names.reduce(0) { $0 + $1.count }
print(bingo)

