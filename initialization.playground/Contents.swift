

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

