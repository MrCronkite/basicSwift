

struct PointX {
    var x = 0
}

struct PointY {
    var y = 0
}

class Line {
    var originX = PointX()
    var originY = PointY()
    init() {}
    init(x originX: PointX, y originY: PointY){
        self.originX = originX
        self.originY = originY
    }
}

let exLine = Line(x: PointX(x: 12), y: PointY(y: 4))

print(exLine.originY.y)


class Vehicle {
    var numberOfWheels = 0
    var description: String {
        return "numberOfWheels \(numberOfWheels)"
    }
}

class Bicicle: Vehicle {
    override init() {
        super.init()
        numberOfWheels = 2
        
    }
}

var vehicle = Vehicle()
var bicicle = Bicicle()

print(vehicle.description)
print(bicicle.description)

class SomeClass {
    var number: Int
    
    required init (num number: Int){
        self.number = number
    }
}

var someClass = SomeClass(num: 10)

print(someClass.number)
