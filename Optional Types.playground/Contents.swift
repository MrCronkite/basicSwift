


let somNumber = "111"
let convertNumber = Int(somNumber)

print(convertNumber ?? "ошибка")


if let convertNumber = Int(somNumber){
    print(convertNumber)
} else {
    print("ошибка")
}

guard let convertNumber1 = Int(somNumber) else {print("ошибка")}
