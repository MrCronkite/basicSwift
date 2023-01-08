

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
