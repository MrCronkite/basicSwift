

enum Compas: CaseIterable {
    case north
    case south
    case east
    case west
}

var derectToHead = Compas.west

derectToHead = .north

switch derectToHead {
case .east:
    print("east")
case .north:
    print("north")
case .south:
    print("south")
case .west:
    print("west")
}

print(Compas.allCases.count)

enum Planet: Int, CaseIterable {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
}

for planet in Planet.allCases {
    print(planet.rawValue)
}

indirect enum Arithmetic{
    case number(Int)
    case anotherCase(Arithmetic, Arithmetic)
}

var number_1 = Arithmetic.number(12)
var number_2 = Arithmetic.number(6)
var multi = Arithmetic.anotherCase(number_1, number_2)


enum NewPlanet: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
    
    static subscript (n: Int) -> NewPlanet {
        return NewPlanet(rawValue: n)!
    }
}


var newPlanet = NewPlanet[6]
print(newPlanet)
