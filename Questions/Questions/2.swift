//
//  2.swift
//  Questions
//
//  Created by admin1 on 28.05.23.
//

import Foundation

/*
 Стоит отметить, что чаще всего на собеседовании от вас не ожидают полный список проблем.
 Перечисление нескольких проблем будет достаточно. Заранее подумайте над примером, когда указанная в ответе проблема возникает.
 Race condition (Состояние гонки)*/
 
 //Priority inversion (Инверсия приоритетов)
 
 //Deadlock (Взаимная блокировка)
 let queue = DispatchQueue(label: "my-queue")
 queue.sync {
   print("print this")

   queue.sync {
     print("deadlocked")
   }
 }

/*
 Livelock (Активная блокировка)
 
 Starvation (Голодание)
 
 Data Race (Гонка за данными)
 */
