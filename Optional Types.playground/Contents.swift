


let somNumber: String? = "111"
let convertNumber = Int(somNumber!)

print(convertNumber ?? "ошибка")


if let convertNumber = Int(somNumber!){
    print(convertNumber)
} else {
    print("ошибка")
}

var number = somNumber?.count
print(number as Any)


