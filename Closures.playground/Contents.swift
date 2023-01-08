

//обычная функция
func getName(){
    print("Vlad")
}

getName()


//функция с параметрами
func getNameParam(name item: String){
    print(item)
}

getNameParam(name: "Vlad")


// функция возвращающаяя значение
func getNameParam_(name item: String) -> String{
    return "hello \(item)"
}

print(getNameParam_(name: "vlad"))


//сквозные параметры
func swapNumber(_ a: inout Int, _ b: inout Int){
    let tempNUmber = a
    a = b
    b = tempNUmber
}

var someNumber = 32
var anotherNumber = 78
swapNumber(&someNumber, &anotherNumber)
print(someNumber, anotherNumber)


//функциональный тип

func addNumber(_ a: Int, _ b: Int) -> Int {
    return a + b
}

var mathcFunc: (Int, Int) -> Int = addNumber

print(mathcFunc(2, 5))


//как параметр 
