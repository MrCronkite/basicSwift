

func getName(){
    print("Vlad")
}

getName()

func getNameParam(name item: String){
    print(item)
}

getNameParam(name: "Vlad")

func getNameParam_(name item: String) -> String{
    return "hello \(item)"
}

print(getNameParam_(name: "vlad"))

func swapNumber(_ a: inout Int, _ b: inout Int){
    let tempNUmber = a
    a = b
    b = tempNUmber
}

var someNumber = 32
var anotherNumber = 78
swapNumber(&someNumber, &anotherNumber)
print(someNumber, anotherNumber)
