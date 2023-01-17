


protocol SomeProtocol {
    func printHello()
}


struct SomeStructura: SomeProtocol {
    func printHello() {
        print("hello world")
    }
}

protocol FullyNammed {
    var fullName: String { get }
}

class Name: FullyNammed {
    var firstName: String
    var surname: String
    init(firstName: String, surname: String){
        self.firstName = firstName
        self.surname = surname
    }
    
    var fullName: String {
        return "\(firstName) \(surname)"
    }
}


var name = Name(firstName: "Vlad", surname: "Dillet")

print(name.fullName)
