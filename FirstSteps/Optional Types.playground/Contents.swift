let someNumber = "123"

let convertNumber_1 = Int(someNumber)


//coalescing operator
print(convertNumber_1 ?? "error")

if let convertNumber = Int(someNumber){
    print(convertNumber)
}

func numberUnwrapping(){
    guard let convertNumber_3 = Int(someNumber) else { print("error guard"); return}
    
    print(convertNumber_3)
}

numberUnwrapping()

if case let convertNumber_4? = Int(someNumber){
    print(convertNumber_4)
}





