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
- 
- ### 🔖 Что такое typealias в Swift?
     <details> <summary>  Ответ </summary>
      
       typealias является псевдонимом для существующего типа данных. 
       Рассмотрим пример:

    ```Swift
      typealias Dollar = Double

      let totalCosts: Dollar = 12.2
    ```

- ### 🗞️ Что такое Autolayout? 
     <details> <summary>  Ответ </summary>

      Autolayout помогает создавать динамические пользовательские интерфейсы, масштабируемые
      и адаптированные к каждому размеру и ориентации устройств. Autolayout вычисляет размер
      и положение view в иерархии view на основе ограничений (constraints).

  <p>Дополнительное чтение: <a href="https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/AutolayoutPG/index.html">Understanding Auto Layout</a></p>

- ### 🗞️ Что такое Generics?
     <details> <summary>  Ответ </summary>
          
      Generics или дженерики — универсальные шаблоны, которые разрешают создавать универсальные функции и типы.
      Работают с каждым типом в соответствии с требованиями, которые определяет разработчик.
 
      Главная особенность — пишется один код, который не дублируется для использования с другими типами.
      Вероятнее, каждый читатель уже использовал дженерики, даже если этого и не знал: коллекции в Swift,
      например, Array, Set и Dictionary — универсальные шаблоны.
      Вы ведь можете создать массив с типом String или Int. Говоря о дженериках, в пример приводят функцию, к
      оторая меняет значения двух переменных местами.
      Поддержим традицию и рассмотрим аналогичный пример:
   ```Swift
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
  ```

- ### 🗞️ Что такое полиморфизм? 
     <details> <summary>  Ответ </summary>
      
      По личному опыту при ответе на такой вопрос собеседования 
      сотрудники компании чаще просят перечислить главные принципы ООП, 
      но иногда спрашивают сами определения. 
      
      Полиморфизм — это способность объекта использовать методы производного класса, 
      который не существует на момент создания базового
  
- ### 🗞️ Чем Point (pt) отличается от Pixel (px)? 
     <details> <summary>  Ответ </summary>
       
      Pixel — точка на экране, а Point — плотность точки на экране. 
   <p>Дополнительное чтение: <a href="https://www.objc.io/issues/3-views/moving-pixels-onto-the-screen/">Getting Pixels onto the Screen</a></p>
 
- ### 🗞️ Чем стек отличатеся от кучи? 
     <details> <summary>  Ответ </summary>
     
      Экземпляры ссылочного типа, такие как функции или классы, хранятся в управляемой 
      динамической памяти — куче (heap), в то время как экземпляры типа значения, такие 
      как структура или массив расположены в области памяти, которая называется стеком (stack). 
      
      В случае если экземпляр типа значения является частью экземпляра ссылочного типа, 
      то значение сохраняется в куче вместе с экземпляром ссылочного типа. 
      
      Пример: структура сама по себе хранится в стеке, но если эта структура расположена в классе, 
      то поскольку класс хранится в куче, то и структура сохраняется в куче.

  <p>Дополнительное чтение: <a href="https://ios-interview.ru/value-and-reference-type/">Value Type и Reference Type или чем стек отличается от кучи?</a></p>
      
- ### 🗞️ Чем отличается frame от bounds? 
     <details> <summary>  Ответ </summary>
     
      Frame — задается относительно собственного superview, 
      Bounds — относительно собственной координатной системы.
      
  ```Swift
    let view = UIView() 
    view.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
      
    print(view.frame) // (0.0, 0.0, 50.0, 50.0) 
    print(view.bounds) // (0.0, 0.0, 50.0, 50.0)
  ```
   <p>Дополнительное чтение: <a href="https://programmingwithswift.com/difference-between-frame-and-bounds-in-swift/#:~:text=TLDR%3A%20Bounds%20refers%20to%20the,the%20views%20parent%20coordinate%20system.">Difference between Frame and Bounds in Swift</a></p>

- ### 🗞️ Что означают принципы проектирования KISS/DRY/YAGNI? 
     <details> <summary>  Ответ </summary>
           
      KISS — не усложняй. Принцип KISS утверждает, что большинство систем работают лучше без усложнений. 
      Поэтому в области проектирования, простота относится, в том числе к главной цели разработчика и
      выражается в составлении программ без лишних сложностей. 
      
      DRY — не повторяй себя. Принцип DRY формулируется как: «Каждая часть знания должна иметь единственное, 
      непротиворечивое и авторитетное представление в рамках системы».
      
      YAGNI — вам это не понадобится. YAGNI — процесс и принцип проектирования ПО, к главной цели которого относится: 
      - Отказ от избыточной функциональности; 
      - Отказ добавления функциональности, в которой нет надобности.

- ### 🗞️ Что такое SOLID? 
     <details> <summary> Ответ </summary>
     
      SOLID состоит из пяти принципов проектирования (по одному на каждую букву), которые направлены на то, 
      чтобы сделать код понятным, гибким и удобным для сопровождения. 
      
      S (The Single Responsibly Principle) – принцип единственной ответственности. У каждого класса только 
            одна обязанность. 
      O (The Open Closed Principle) – принцип открытости или закрытости. Класс открыт для расширения, 
            но закрыт для модификации. 
      L (The Liskov Substitution Principle) – принцип подстановки Барбары Лисков. Дочерний класс не 
            нарушает определения типов родительского класса. 
      I (The interface Segregation Principle) – принцип разделения интерфейса. Разделяя интерфейс, 
            разработчик решает проблему с одним толстым интерфейсом. 
      D (The dependency Inversion Principle) – принцип инверсии зависимостей. Слои высокого уровня 
            в приложении, такие как контроллер представления, не должны напрямую зависеть от вещей низкого 
      уровня, таких как сетевой компонент. Вместо этого, он зависит от абстракции этого компонента.
  <p> Дополнительное чтение: <a href="https://betterprogramming.pub/an-ios-engineers-perspective-on-solid-principles-bf46ddc25d47">An iOS Engineer’s Perspective on SOLID Principles</a> </p>
 
 - ### 🗞️ В чем разница между уровнем доступа Fileprivate и Private?
      <details> <summary> Ответ </summary>
      
       На текущий момент существует пять уровней доступа: Open, Public, Internal, Fileprivate и Private. 
       Путаница возникает с первыми и последними двумя доступами. Рассмотрим последние два уровня: 
      
       Fileprivate — на этом уровне расположен доступ к элементам данных и функциям текущего файла. 
            Используется для скрытия реализации, требуемой только в текущем исходном файле. 
       Private — самый низкий уровень доступа. Ограничивает использование сущности, которая 
            включается декларацией или расширением в текущем файле. При этом доступ в подклассах 
       или в других файлах отсутствует. 
       Private — разрешить доступ к членам данных и функциям в рамках их объявления или расширения 
            в текущем файле.  
       Fileprivate — разрешить доступ к членам данных и функциям в одном и том же исходном файле 
            или в подклассе, или расширении.
     <p> Дополнительное чтение: <a href="https://ios-interview.ru/access-control/">Уровни доступа в Swift</a> </p>
