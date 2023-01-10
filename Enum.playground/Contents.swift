

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


