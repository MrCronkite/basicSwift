//
//  1.swift
//  Questions
//
//  Created by admin1 on 28.05.23.
//

import Foundation
/*
QualityofService или QoS — качество обслуживания, которое появилось с приходом iOS 8.
                           QoS помогает выставить приоритет, с которым будет выполняться
                           наша задача DispatchQueue.

QoS используется с функцией .async(). Приоритеты делятся на четыре группы, каждая из
 которых помогает той или иной работе приложения.

User Interactive — используется для взаимодействия с пользователем. Это может быть любая
                   работа, которая проходит в главном потоке, например, анимация или обновление интерфейса.
User Initiated — используется при инициации работы пользователем. Это может быть такая
                 задача как загрузка данных по API. Работа должна быть завершена, чтобы
                 пользователь мог продолжить пользоваться приложением.
Utility — используется для задач, которые не отслеживаются пользователем приложения и не
          требует немедленного их завершения. Это может быть работа прогресс бара.
Background — используется для фоновых работ, которые не отслеживаются пользователем.
             Это может быть сохранение данных в БД или любая другая работа, которая
             может быть выполнена с низким приоритетом.

Как вы уже понимаете, User Interactive имеет самый высокий приоритет и будет выполняться в первую очередь,
Background — самый низкий приоритет.
При ответе на вопрос стоит также добавить, что есть еще два типа приоритета: Default и Unspecified.
Default — приоритет размещен между User Initiated и Utility. Такой приоритет чаще используется в коде.

Unspecified — означает отсутствие приоритета. Приоритет выбирается самостоятельно в зависимости от окружающей среды (текущей загруженности системы).
*/


let queue = DispatchQueue(label: "Queue")

queue.async(qos: .background) {
    print("Background Code")
}

queue.async(qos: .userInitiated) {
    print("User Initiated Code")
}
