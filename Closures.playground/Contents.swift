
var names = ["Kolia", "Roma", "Ignat", "Ruslan"]

func backward(_ s1: String, _ s2: String) -> Bool{
    return s1 > s2
}

let reversName = names.sorted(by: { (s1: String, s2: String) -> Bool in return s1 > s2})

let reversName_1 = names.sorted(by: {(s1, s2) -> Bool in s1 > s2 })

let reversName_2 = names.sorted { s2, s1 in s1 > s2 }

let reversName_3 = names.sorted(by: { $0 > $1 })

let reversName_4 = names.sorted(by: > )

print(reversName_4)

print(reversName_3)

print(reversName_2)

print(reversName_1)

print(reversName)

let number = [45, 23, 23, 34]

let string = number.map { number -> Int in
    var number = number
    number += 10
    return number
}

print(string)

func serve(cast closure: () -> String){
    print(closure())
}

serve(cast: { names.remove(at: 0)})

func server(costumer closure: @autoclosure () -> String ){
    print(closure())
}

server(costumer: names.remove(at: 2))

var complitionHandlers: [() -> Void] = []

func escap(closure: @escaping () -> Void){
    complitionHandlers.append(closure)
    print(complitionHandlers)
}

func complit() -> Void {
    print("hello")
}


