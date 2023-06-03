# Вопросы на собеседовании IOS



- 🔖 Расскажите о приоритетах Quality of Service  <a href="https://github.com/MrCronkite/basicSwift/blob/main/Questions/Questions/1.swift">Ответ</a>
- 🔖 Какие проблемы многопоточности вы знаете?  <a href="https://github.com/MrCronkite/basicSwift/blob/main/Questions/Questions/2.swift">Ответ</a>
- 🔖 Есть ли разница между GCD и NSOperation?  <a href="https://github.com/MrCronkite/basicSwift/blob/main/Questions/Questions/3.swift">Ответ</a>
- 🔖 Что такое назначенный инициализатор?  <a href="https://github.com/MrCronkite/basicSwift/blob/main/Questions/Questions/4.swift">Ответ</a>
- 🔖 Какова временная сложность добавления элемента в начало массива? <a href="https://github.com/MrCronkite/basicSwift/blob/main/Questions/Questions/5.swift">Ответ</a>
- 🔖 Расскажите о механизме Copy-on-write <a href="https://github.com/MrCronkite/basicSwift/blob/main/Questions/Questions/6.swift">Ответ</a>
- 🔖 Может ли протокол быть унаследован от другого протокола? <a href="https://github.com/MrCronkite/basicSwift/blob/main/Questions/Questions/7.swift">Ответ</a>
- 🔖 Что такое stored property (хранимое свойство) или computed property (вычисляемое свойство) <a href="https://github.com/MrCronkite/basicSwift/blob/main/Questions/Questions/8.swift">Ответ</a>
- 🔖 Расскажите о диспетчеризации методов <a href="https://github.com/MrCronkite/basicSwift/blob/main/Questions/Questions/9.swift">Ответ</a>
- 🔖 Расскажите о методе hitTest <a href="https://github.com/MrCronkite/basicSwift/blob/main/Questions/Questions/10.swift">Ответ</a>
- 🔖 Как работает UIGestureRecognizer? <a href="https://github.com/MrCronkite/basicSwift/blob/main/Questions/Questions/11.swift">Ответ</a>
- 🔖 Что такое typealias в Swift? <a href="https://github.com/MrCronkite/basicSwift/blob/main/Questions/Questions/12.swift">Ответ</a>
- 🔖 Что такое Autolayout <a href="https://github.com/MrCronkite/basicSwift/blob/main/Questions/Questions/13.swift">Ответ</a>
- 🔖 Что такое Generics? <a href="https://github.com/MrCronkite/basicSwift/blob/main/Questions/Questions/14.swift">Ответ</a>


- 🗞️ Что такое полиморфизм? <details> <summary>  Ответ </summary>
      
      По личному опыту при ответе на такой вопрос собеседования 
      сотрудники компании чаще просят перечислить главные принципы ООП, 
      но иногда спрашивают сами определения. 
      
      Полиморфизм — это способность объекта использовать методы производного класса, 
      который не существует на момент создания базового
  
- 🗞️ Чем Point (pt) отличается от Pixel (px)? <details> <summary>  Ответ </summary>
     
      Pixel — точка на экране, а Point — плотность точки на экране. 
      Дополнительное чтение: 
  <a href="https://www.objc.io/issues/3-views/moving-pixels-onto-the-screen/">Getting Pixels onto the Screen</a>
 
- 🗞️ Чем стек отличатеся от кучи? <details> <summary>  Ответ </summary>
     
      Экземпляры ссылочного типа, такие как функции или классы, хранятся в управляемой 
      динамической памяти — куче (heap), в то время как экземпляры типа значения, такие 
      как структура или массив расположены в области памяти, которая называется стеком (stack). 
      
      В случае если экземпляр типа значения является частью экземпляра ссылочного типа, 
      то значение сохраняется в куче вместе с экземпляром ссылочного типа. 
      
      Пример: структура сама по себе хранится в стеке, но если эта структура расположена в классе, 
      то поскольку класс хранится в куче, то и структура сохраняется в куче.

      Дополнительное чтение: 
  <a href="https://ios-interview.ru/value-and-reference-type/">Value Type и Reference Type или чем стек отличается от кучи?</a>
      
- 🗞️ Чем отличается frame от bounds? <details> <summary>  Ответ </summary>
     
      Frame — задается относительно собственного superview, 
      Bounds — относительно собственной координатной системы.
      
  ```Swift
    let view = UIView() 
    view.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
      
    print(view.frame) // (0.0, 0.0, 50.0, 50.0) 
    print(view.bounds) // (0.0, 0.0, 50.0, 50.0)
  ```
  <a href="https://programmingwithswift.com/difference-between-frame-and-bounds-in-swift/#:~:text=TLDR%3A%20Bounds%20refers%20to%20the,the%20views%20parent%20coordinate%20system.">Difference between Frame and Bounds in Swift</a>
 

