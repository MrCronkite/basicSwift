

var arrayInt: [Int] = [4, 6, 7, 6, 9]

arrayInt.append(3)
arrayInt.insert(15, at: 4)

arrayInt.remove(at: 2)

print("\(arrayInt), количество элементов в масиве \(arrayInt.count)")

print(arrayInt[0],  arrayInt[1...4])


for i in arrayInt {
    print(i)
}


