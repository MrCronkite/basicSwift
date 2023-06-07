# Вопросы на собеседовании IOS


- ### 🔖 Расскажите о приоритетах Quality of Service
     <details> <summary>  Ответ </summary>
     
      QualityofService или QoS — качество обслуживания, которое появилось с приходом iOS 8.
                           QoS помогает выставить приоритет, с которым будет выполняться
                           наша задача DispatchQueue.

      QoS используется с функцией .async(). Приоритеты делятся на четыре группы, каждая из
       которых помогает той или иной работе приложения.

      User Interactive — используется для взаимодействия с пользователем. Это может быть любая
                         работа, которая проходит в главном потоке, например, анимация или 
                         обновление интерфейса.
      User Initiated — используется при инициации работы пользователем. Это может быть такая
                       задача как загрузка данных по API. Работа должна быть завершена, чтобы
                       пользователь мог продолжить пользоваться приложением.
      Utility — используется для задач, которые не отслеживаются пользователем приложения и не
                требует немедленного их завершения. Это может быть работа прогресс бара.
      Background — используется для фоновых работ, которые не отслеживаются пользователем.
             Это может быть сохранение данных в БД или любая другая работа, которая
             может быть выполнена с низким приоритетом.

      Как вы уже понимаете, User Interactive имеет самый высокий приоритет и будет выполняться в 
      первую очередь, Background — самый низкий приоритет.
      При ответе на вопрос стоит также добавить, что есть еще два типа приоритета: Default и Unspecified.
      Default — приоритет размещен между User Initiated и Utility. Такой приоритет чаще используется в коде.

      Unspecified — означает отсутствие приоритета. Приоритет выбирается самостоятельно в зависимости от 
      окружающей среды (текущей загруженности системы).
      
     ```Swift
       let queue = DispathcQueue(label: "Queue")
     
       queue.async(qos: .background) {
           print("Background Code")
       }
       
       queue.async(qos: .userInitiated) {
           print("Background Code")
       }
     ```

- ### 🔖 Какие проблемы многопоточности вы знаете?
     <details> <summary>  Ответ </summary>
     
      Стоит отметить, что чаще всего на собеседовании от вас не ожидают полный список проблем.
      Перечисление нескольких проблем будет достаточно. Заранее подумайте над примером, 
      когда указанная в ответе проблема возникает.
          
      Race condition (Состояние гонки)
      Priority inversion (Инверсия приоритетов)
      Deadlock (Взаимная блокировка)
      Livelock (Активная блокировка)
      Starvation (Голодание)
      Data Race (Гонка за данными)
   <p>Дополнительное чтение: <a href="https://ios-interview.ru/multithreading-problems/">Проблемы многопоточности</a></p>

- ### 🔖 Есть ли разница между GCD и NSOperation?
     <details> <summary>  Ответ </summary>
      
      NSOperation — оболочка GCD. В случае использования NSOperation, неявно используется Grand Central Dispatch.
  
      Преимущество GCD:
          Реализация GCD проста.
  
      Преимущества NSOperation:
          NSOperation обеспечивает поддержку зависимостей. Это преимущество разрешает разработчикам выполнять 
          задачи в конкретном порядке. Операции можно приостанавливать, возобновлять и отменять. Как только 
          вы отправляете задачу с помощью Grand Central Dispatch, вы теряете контроль над жизненным циклом задачи. 
          NSOperation предоставляет разработчику контроль над операцией.
          Вы можете указать максимальное количество операций в очереди, которые могут выполняться одновременно.
   <p>Дополнительное чтение: <a href="https://ios-interview.ru/nsoperation-vs-grand-central-dispatch/">NSOperation или Grand Central Dispatch</a></p>

- ### 🔖 Что такое назначенный инициализатор?
     <details> <summary>  Ответ </summary>
     
      Назначенный инициализатор — это первичный инициализатор класса.
 
      Назначенный инициализатор инициализирует все свойства, представленные этим классом,
      и вызывает соответствующий инициализатор суперкласса, чтобы продолжить процесс 
      инициализации в цепочке суперкласса.
     
     ```Swift
     init(параметры) {
         // ...
     }
     ```

- ### 🔖 Какова временная сложность добавления элемента в начало массива?
     <details> <summary>  Ответ </summary>
     
      Вопрос об оценке сложности алгоритма чаще встречается на собеседованиях в крупных компаниях,
      где сотрудники задают общие вопросы, не относящиеся к конкретному проекту.

      Похожих вопросов на собеседовании может быть много, например:
      Оцените сложность поиска в хэш-таблице?
      Какова сложность сортировки пузырьком?

      Ответим на текущий вопрос — сложность O(n): при операциях удаления или вставки в начало массива
      потребуется сдвинуть каждый элемент.
  <p>Дополнительное чтение: <a href="https://swiftyfinch.medium.com/algorithms-for-children-2f70280a0fc1">Оценка алгоритмов для самых маленьких</a></p>
     
- ### 🔖 Расскажите о механизме Copy-on-write?
     <details> <summary>  Ответ </summary>
     
      На собеседованиях любят тему Copy-on-write, иногда меняется только формулировка вопроса:
      в одних случаях сотрудники компании спросят определение, в других — попросят привести пример.
  
      Copy-on-write — механизм оптимизации в Swift, когда при присвоении переменной значений или
      при передаче коллекции в функцию не происходит копирование этой коллекции.
  <p>Дополнительное чтение: <a href="https://ios-interview.ru/copy-on-write/">Механизм Copy-on-Write</a></p>

- ### 🔖 Может ли протокол быть унаследован от другого протокола?
     <details> <summary>  Ответ </summary>

     ```Swift
        protocol SomeProtocol {
             // определение протокола SomeProtocol
        }

        protocol AnotherProtocol {
             // определение протокола AnotherProtocol
        }

        protocol InheritingProtocol: SomeProtocol, AnotherProtocol {
             // определение протокола InheritingProtocol
        }
     ```
     
      Протокол может наследовать один или более других протоколов. Также, как и класс,
      протокол добавляет требования поверх тех требований протоколов, которые наследует.

      В нашем примере протокол InheritingProtocol должен удовлетворять всем требованиям
      протоколов SomeProtocol и AnotherProtocol.
   <p>Дополнительное чтение: <a href="https://habr.com/ru/companies/acronis/articles/420239/">Таинство протоколов</a></p>
     
- ### 🔖 Что такое stored property (хранимое свойство) или computed property (вычисляемое свойство)?
     <details> <summary>  Ответ </summary>
     
      Свойства предназначены для хранения состояния объекта. Свойства бывают двух типов:

      Хранимые свойства (stored properties) - переменные или константы,
      определенные на уровне класса или структуры
 
      Вычисляемые свойства (computed properties) - конструкции, динамически вычисляющие значения.
      Могут применяться в классе, перечислении или структуре
   <p>Дополнительное чтение: <a href="https://swiftbook.ru/content/languageguide/properties/">Свойства</a></p>
     
- ### 🔖 Расскажите о диспетчеризации методов?
     <details> <summary>  Ответ </summary>
     
      Итак, диспетчеризация метода — это то, как программа будет определять, какие инструменты использовать 
      при вызове функции.
      Диспетчеризация широко используется, знание этого механизма поможет выйти из запутанных ситуаций.
 
      Swift поддерживает три типа диспетчеризации:
      Direct Dispatch (Статическая диспетчеризация) — самый быстрый тип диспетчеризации. Адрес вызываемой 
      функции определяется во время компиляции, поэтому затраты на такие вызовы минимальны. 
      Для использования статической диспетчеризации вы можете пометить методы ключевым словом private
      или классы ключевым словом final.
 
      Table Dispatch (Динамическая диспетчеризация) — распространенный тип. Адрес вызываемой функции определяется
      во время выполнения. У каждого подкласса есть собственная таблица с указателем на функцию для каждого метода.
      По мере того как подклассы добавляют к классу новые методы, эти методы добавляются в конец этой таблицы.
      Затем к таблице обращаются во время выполнения, чтобы определить метод для выполнения. Это и есть 
      динамическая диспетчеризация.
      В Swift данный подтип делится на два подтипа:
      Virtual Table — используется при наследовании классов, что приносит дополнительные затраты.
      Witness Table — используется для реализации протоколов, наследование отсутствует.
 
      Message Dispatch (Отправка сообщений) — самый долгий (по времени выполнения) тип диспетчеризации.
      Обеспечивает работу таких механизмов, как KVC/KVO или Core Data. Главная особенность этого
      типа —  у разработчиков появляется возможность изменять поведение отправки во время выполнения
      с помощью механизма swizzling.
     
- ### 🔖 Расскажите о методе hitTest?
     <details> <summary>  Ответ </summary>
     
      Когда пользователь нажимает на какую-либо view вашего приложения, системе необходимо определить
      на что именно нажал пользователь. После касания система запускает рекурсивный процесс поиска view,
      которой и принадлежит касание пользователя (поиск происходит относительно координат касания пользователя).
     
      Этим поиском и занимается hitTest. hitTest — это рекурсивный поиск среди иерархии views, к которой
      прикоснулся пользователь. iOS пытается определить какая UIView является самой низко расположенной
      вьюшкой под пальцем пользователя. Она и будет получать события касания.
     
    <p>Дополнительное чтение: <a href="https://medium.com/yandex-maps-mobile/%D0%B4%D0%B5%D1%80%D0%B6%D0%B8%D0%BC-%D1%83%D0%B4%D0%B0%D1%80-%D1%81-hittest-542653d51a8c">Держим удар с hitTest</a>,
     <a href="https://habr.com/ru/post/584100/">Обработка жестов в iOS</a></p>


- ### 🔖 Как работает UIGestureRecognizer?
     <details> <summary>  Ответ </summary>
     
      В тот момент, когда пользователь коснулся экрана, создается уникальный объект UITouch,
      который ассоциируется с этим касанием. Важно заметить, что под касанием экрана
      подразумевается цепочка событий: пользователь коснулся экрана пальцем, палец
      движется по экрану, палец оторвался от экрана. Далее, с помощью функции hitTest
      находится самая глубокая в иерархии UIView, координаты которой содержат в себе касание.
      Найденная UIView становится firstResponder и начинает получать уведомления о UITouch:
          touchesBegan — начало касания;
          touchesMoved — изменение параметров касания;
          touchesEnded — конец касания;
          touchesCancelled — отмена касания.

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

- ### 🗞️ Чем отличается NSSet от NSArray?
     <details> <summary> Ответ </summary>

        Ответ на вопрос прост: в отличие от NSArray, NSSet хранит только уникальные объекты. 
        Также, NSSet — хранение неупорядоченной коллекции, NSArray — упорядоченной коллекции. 
        
        Если на собеседовании необходимы дополнительные знания по рассматриваемому вопросу, 
        сравните разницу скорости между ними. 
   <p>Материал на эту тему доступен для чтения здесь: <a href="https://www.cocoawithlove.com/2008/08/nsarray-or-nsset-nsdictionary-or.html">NSArray or NSSet, NSDictionary or NSMapTable.</a> </p>

        Если говорить еще о сравнении между этими типами, то в NSArray объект получают по индексу, 
           а в NSSet — путем сравнения объектов.
   <p> Дополнительное чтение: <a href="https://medium.com/@lawrencegreater/nsarray-vs-nsset-5605337c46bf">NSArray и NSSet</a></p>
