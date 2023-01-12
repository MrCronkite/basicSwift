  

struct SomeStruct {
    var number: Int = 10
}

class SomeClass {
    var number: Int = 10
}

var objStruct = SomeStruct()

var objClass = SomeClass()

var obj_2 = objClass

var obj_1 = objStruct

objClass.number = 30
objStruct.number = 30



print(objStruct.number)
print(obj_1.number)
print(objClass.number)
print(obj_2.number)


class Person {
    var name: String
    var age: Int
    
    init(name: String, age: Int){
        self.name = name
        self.age = age
    }
}

let person = Person(name: "vlad", age: 12)


class Counter {
  static var count = 0
    
    func inrement(){
        Counter.count += 1
    }
}


var exCounter = Counter()

exCounter.inrement()

print(Counter.count)

struct CounterTwo {
    var count = 0
    mutating func increment(){
        count += 1
    }
}

var exCounterTwo = CounterTwo()
exCounterTwo.increment()
print(exCounterTwo.count)
