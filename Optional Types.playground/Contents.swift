import UIKit

//: ## Home work 4

/*

### Задание 1
  1.1 Пользователь открывает вклад (deposit) в банке на 5 лет на сумму 500 тыс. рублей. Процентная ставка годовых (rate) составляет 11%. Необходимо просчитать сумму дохода (profit) по окончании срока действия (period) вклада.  Для решения данной задачи используйет цикл for-in. Примечание: сумма вклада увеличивается с каждым годом и процент нужно считать уже от увелеченной суммы.
  1.2 Выведите результат на консоль в таком виде: "Сумма вклада через <... > лет увеличится на <...> и составит <...>"

### Задание 2
  2.1 Создайте целочисленные переменные `base` и `power` с любым значениями на ваше усмотрение.
  2.2 При помощи цикла `for in` возведите переменную `base` в степень `power` и присвойте результат переменной `result`
  2.3 Выведите результат на консоль в следующем виде: «<…> в <…> степени равно <…>»
   
### Задание 3
  3.1 Создайте целочисленный массив данных с любым набором чисел.
  3.2 Выведите на консоль все четные числа из массива
  3.3 Используя оператор Continue выведите на консоль все нечетные числа из массива. Оператор continue предназначен для перехода к очередной итерации, игнорируя следующий за ним код. Т.е. вам нужно выполнить проверку на четность числа, и если оно оказалось четным перейти к следующей итерации.

### Задание 4
 4.1 Создайте цикл (интревал можно задать от 1 до 10) в котором будет случайным образом вычисляться число в пределах от 1 до 10. Если число будет равно 5, выведите на коносль сообщение с номером итерации, например (Что бы выпало число 5 понадобилось 3 итерации) и остановите цикл. Для остановки цикла используйте оператор breack. Оператор break предназначен для досрочного завершения работы цикла. При этом весь последующий код в теле цикла игнорируется.
 
### Задание 5
   5.1 На 10 метровый столб лезет черепашка. За день она забирается на два метра, за ночь съезжает на 1. Определите при помощи цикла, через сколько дней она заберетсья на столб. Подумайте над тем, какой цикл использовать в этой ситуации.

 ###Задание 6
  >Очень сложное заданиe, не обязательно, только для желающих
  Заполнить массив из 100 элементов простыми числами. Натуральное число, большее единицы, называется простым, если оно делится только на себя и на единицу. Данная задача выполняется по методу решета Эратосфена
  */




//задание 1

var deposit:Float = 500000
var profit:Float = 0

for _ in 1...5 {
    deposit+=deposit*0.11
    print(deposit)
}

profit = deposit-500000

print("Сумма вклада через 5 лет увеличится на \(profit) и составит \(deposit)")


//задание 2

var base = 3
var power  = 20
var result = 1

for _ in 1...power  {
    result *= base
}

print("\(base) в \(power) степени равно \(result)")



//задание 3
var arrey = [1,2,3,7,2,3,5,23,4,34,8,94]

for i in arrey {
    if i%2==0{
        continue
    }
    print (i)
}

//задание 4

var numberRandom = 0
var count = 0
for _ in 1...10{
   numberRandom = Int.random(in:1...10)
   count += 1
    if numberRandom == 5 {
        print("Что бы выпало число 5 понадобилось \(count) итерации")
        break
    }
}


//задание 5


var distance = 0
var numberOfDays = 0
var isDay = true

while distance != 10 {
    if isDay {
        distance += 2
        numberOfDays += 1
        isDay = false
    } else {
        distance -= 1
        isDay = true
    }
}

print(numberOfDays)

//задание 6

var primeNumbers = [Int]() // 2, 3
var primeNumber = 2 // 2
var currentNumber = primeNumber // 5

while primeNumbers.count < 100 {
    for pn in 2...currentNumber { // pn = 3
        if currentNumber % primeNumber == 0 {
            break
        }
        primeNumber = pn
    }
    
    if primeNumber == currentNumber {
        primeNumbers.append(currentNumber)
    }
    
    currentNumber += 1
}


print(primeNumbers)
print("Количество элементов массива:", primeNumbers.count)


// Способ 2

// Don`t enter values more than 5000
let neededNumberForArray = 100

var finalArray = [Int]() // 2, 3
var auxiliarySet: Set<Int> = [] //

var currentValue = 2 // 5

while finalArray.count < neededNumberForArray {
    if !auxiliarySet.contains(currentValue) {
        finalArray.append(currentValue)
        for multiplier in 1...(neededNumberForArray * 10 / currentValue) {
            auxiliarySet.insert(currentValue * multiplier) // 2, 4, 6, 8... 3, 6, 9, 12... 5, 10, 15
        }
    }
    currentValue += 1
}


print("Колличество элементов массива = \(finalArray.count).\n", finalArray)


