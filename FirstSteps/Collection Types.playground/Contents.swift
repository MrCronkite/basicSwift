//ARRAY

var arrayInt: [Int] = [4, 6, 7, 6, 9]

arrayInt.append(3)
arrayInt.insert(15, at: 4)

arrayInt.remove(at: 2)

print("\(arrayInt), количество элементов в масиве \(arrayInt.count)")

print(arrayInt[0],  arrayInt[1...4])


for i in arrayInt {
    print(i)
}

for (index, value) in arrayInt.enumerated() {
    print("\(index): \(value)")
}




//SET
print("SET_________")

var setInt: Set<Int> = [1, 3, 5, 6, 8, 9, 2]

setInt.insert(100)
setInt.remove(6)

print(setInt)
print(setInt.contains(10))

for number in setInt.sorted() {
    print(number)
}


//DICTIONARY
print("DICTIONARY________")

var emptyDict = [Int: String]()

emptyDict[1] = "Молоко"
emptyDict[2] = "Пивко"
emptyDict[3] = "Хлебушек"

emptyDict.removeValue(forKey: 3)

print(emptyDict.count)
print(emptyDict[2] ?? "empty")

for key in emptyDict.keys{
    print("\(key)")
}




