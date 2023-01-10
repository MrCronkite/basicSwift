

enum Compas {
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
