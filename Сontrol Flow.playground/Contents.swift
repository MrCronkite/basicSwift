

for item in 1...9 {
    print(item)
}


for tick in stride(from: 0, to: 60, by: 5) {
    print(tick)
}

var i = 2


//while
while i < 1000{
    i = i * 4
    print(i)
}

var a = 2


//repeat while
repeat {
    a = a * 4
    print(a)
}while a < 1000


//if
if a == 2048 {
    print("pivko")
} else {
    print("ris")
}


//switch
let character: Character = "z"

switch character {
case "V" :
    print("V")
case "O" :
    print("O")
case "Z" :
    print("Z")
default :
    print("nil")
}


//tuples
let point = (3, 2)
switch point {
case (let x, 2) :
    print(x)
case (3, let y):
    print(y)
case let (x, y):
    print(x, y)
}




