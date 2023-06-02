//
//  14.swift
//  Questions
//
//  Created by admin1 on 2.06.23.
//

import Foundation

/*
Generics или дженерики — универсальные шаблоны, которые разрешают создавать универсальные функции и типы.
 Работают с каждым типом в соответствии с требованиями, которые определяет разработчик.
 
 Главная особенность — пишется один код, который не дублируется для использования с другими типами.
 Вероятнее, каждый читатель уже использовал дженерики, даже если этого и не знал: коллекции в Swift,
 например, Array, Set и Dictionary — универсальные шаблоны.
 Вы ведь можете создать массив с типом String или Int. Говоря о дженериках, в пример приводят функцию, к
 оторая меняет значения двух переменных местами.
 Поддержим традицию и рассмотрим аналогичный пример:
*/

//Функция swapValues, используя сквозные параметры, меняет местами значения переменных a и b.
func swapValues(_ a: inout Int, _ b: inout Int) {
    let tmpA = a
    a = b
    b = tmpA
}


//Давайте запустим код:

var aInt = 5
var bInt = 10

swapValues(&aInt, &bInt)

print("aInt: \(aInt), bInt: \(bInt)") // aInt: 10, bInt: 5

func swapAnyValues(_ a: inout T, _ b: inout T) {
    let tmpA = a
    a = b
    b = tmpA
}
var aDouble = 5.0
var bDouble = 10.0
swapAnyValues(&aDouble, &bDouble)

print("aDouble: \(aDouble), bDouble: \(bDouble)") // aDouble: 10.0, bDouble: 5.0


var aInt = 5
var bInt = 10
swapAnyValues(&aInt, &bInt)

print("aInt: \(aInt), bInt: \(bInt)") // aInt: 10, bInt: 5

//Как видим, функция swapAnyValues теперь используется как с Int, так и с Double или String значениями.
