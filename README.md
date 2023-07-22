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

  <p>Дополнительное чтение: <a href="https://habr.com/ru/articles/690940/">Understanding Auto Layout</a></p>

- ### 🗞️ Что такое Generics?
     <details> <summary>  Ответ </summary>
          
      Generics или дженерики — универсальные шаблоны, которые разрешают 
      создавать универсальные функции и типы.
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
         
- ### 💡 Что такое многопоточность и какие инструменты вы знаете для работы с многопоточностью?
     <details> <summary> Ответ </summary>
          
       На собеседовании ожидают услышать, следующее: 
          кандидат понимает, зачем необходима многопоточность в iOS приложениях; 
          кандидат владеет опытом работы или знаком с некоторыми инструментами 
          работы с многопоточностью.
       
       Во-первых, расскажите, что приложение работает в main потоке и как только происходит 
       ресурсозатратный процесс, приложение будет работать медленнее, так как каждое действие будет 
       происходить на главном потоке. Здесь приходит на помощь многопоточность: «дорогие» задачи 
       посылаются в параллельную очередь, и тем самым главный поток разгружается. 
          
       Часто, при работе с многопоточностью используется Grand Central Dispatch (GCD) или Operation. 
       На этом этапе важно понимать, чем отличается синхронная очередь от асинхронной и чем эти два 
       инструмента отличаются.
   <p> Об этом написано в статье: <a href="https://ios-interview.ru/nsoperation-vs-grand-central-dispatch/">NSOperation или GCD</a></p>
   <p> Расскажите об инструментах: <a href="https://habr.com/ru/articles/572316/">Thread</a>, 
        <a href="https://habr.com/ru/articles/335756/">Operation</a>,
          <a href="https://mycodetips.com/ios/how-to-use-nslock-in-ios-2519.html">NSLock</a>,
          <a href="https://habr.com/ru/companies/nix/articles/336260/">Мьютексы, Семафоры</a>,
          <a href="https://ersoya.medium.com/dispatch-barrier-in-swift-5613589ce53e">Dispatch Barrier in Swift</a>,
          <a href="https://swiftbook.ru/post/tutorials/async-await-in-swiftui/">Async/Await</a></p>
   
- ### 💡 Назовите методы жизнененного цикла ViewController?
     <details> <summary> Ответ </summary>
    
       Часто, так или иначе, интервьюер затрагивает тему Lifecycle ViewController. В случае если 
       кандидат путает порядок главных методов, в этом нет ничего страшного, но если кандидат 
       путает сами значения методов или вовсе не владеет информацией — дальнейшее прохождение 
       собеседования ставится под вопрос. 
          
       ViewDidLoad — метод вызывается, когда view уже создано. Метод вызывается только один 
          раз за время существования ViewController. 
       ViewWillAppear — метод вызывается каждый раз перед тем, как появится ViewController. 
          Этот метод может быть вызван несколько раз для одного экземпляра ViewController. 
       ViewDidAppear — метод вызывается каждый раз после появления ViewController. 
       ViewWillDisappear — метод вызывается перед удалением ViewController из иерархии представлений. 
       ViewDidDisappear — метод вызывается после удаления ViewController из иерархии представлений.  
   <p> Дополнительное чтение: <a href="https://habr.com/ru/articles/654517/">Жизненный цикл UIViewController</a></p>
     
- ### 💡 Какие состояния (state) встречаются у приложения?
     <details> <summary> Ответ </summary>
       
      Изначально приложение не запущено и работает в состоянии Non-running. После запуска 
      пользователем, приложение переходит в состояние Foreground, в котором становится 
      сначала Inactive — на этом этапе выполняется код программы, но не обрабатываются 
      события интерфейса пользователя (интерфейс не отображается, касания не обрабатываются и т.д.). 
      
      Затем приложение переходит в состояние Active, в котором выполняется код и обрабатываются 
      каждое событие UI. Если пользователь свернет приложение или переключится на другое, 
      то наше приложение сначала перейдет в состояние Inactive и затем в состояние Background. 
      В этом состоянии код выполняется ограниченное время (без дополнительного запроса), 
      события UI не обрабатываются. 
          
      После состояния Background, приложение переходит в состояние Suspended. 
      В этом состоянии код приложения не выполняется, а система, в качестве оптимизации памяти,
      способна самостоятельно завершить ваше приложение.
      
      Non-running — приложение не запущено. 
      Inactive — приложение работает в Foreground, но не получает события. iOS приложение переходит 
                 в состояние Inactive когда поступает событие звонка или SMS-сообщения. 
      Active — приложение работает в Foreground (на переднем плане) и получает события. 
      Background — приложение работает в Background (в фоновом режиме) и выполняет код. 
      Suspended — приложение находится в Background, но код уже не выполняется. 
                  Система может завершить ваше приложение для оптимизации памяти.
  <p> Дополнительное чтение: <a href="https://medium.com/@yo.kononov/%D1%80%D0%B0%D0%B7%D0%B1%D0%BE%D1%80-%D0%B2%D0%BE%D0%BF%D1%80%D0%BE%D1%81%D0%BE%D0%B2-%D0%BD%D0%B0-%D1%81%D0%BE%D0%B1%D0%B5%D1%81%D0%B5%D0%B4%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5-junior-ios-developer-b27604211f5a">Жизненный цикл приложения</a></p>
    
- ### 💡 Что такое CALayer и в чем отличие от UIView?
     <details> <summary> Ответ </summary>
     
      UIView может реагировать на события, а CALayer — нет. 
          
      UIView — прямоугольная область на экране, которая определяет пространство с системой координат. 
      Наследуется от UIResponder, который определяет интерфейс для обработки различных событий и 
      доставки событий. 
          
      CALayer напрямую наследует NSObject и не имеет соответствующего интерфейса для обработки событий. 
          
      Внутри каждого UIView есть CALayer, который обеспечивает рисование и отображение содержимого, 
      а размер и стиль UIView предоставляются внутренним слоем.
  <p> Дополнительное чтение: <a href="https://habr.com/ru/articles/309506/">Знакомство с СALayer</a></p>

- ### 💡 Что такое Responder Chain?
     <details> <summary> Ответ </summary>
     
       Если кратко, то Responder Chain — это иерархия объектов, которые могут ответить на полученные события. 
       
       Для обработки взаимодействия пользователя с UI и внешних событий в iOS используется 
       механизм Responder Chain. 
       
       Класс UIApplication, UIViewController и UIView наследуются от класса UIResponder. Класс UIResponder 
       определяет порядок, в котором объекты обрабатывают события (touch-события, события от 
       элементов UI (кнопки и т.д.), изменение текста). 
       
       Кроме того, UIResponder объявляет методы, которые позволяют объектам определять, 
       кто первым будет отвечать и обрабатывать сообщения: 
       
          becomeFirstResponder — получатель сообщения будет первым получать все события, посылаемые системой. 
          resignFirstResponder — получатель отказывается от обработки сообщений первым.
    <p> Дополнительное чтение: <a href="https://habr.com/ru/articles/464463/">Responder Chain</a>, <a href="https://habr.com/ru/companies/psb/articles/597759/">Responder Chain, или как правильно передавать действия пользователя между компонентами </a></p>

- ### 💡 Объясните архитектуру MVC?
     <details> <summary> Ответ </summary>
          
      MVC (Model-View-Controller) - это программная архитектура для разработки приложений для iOS.
      Это одна из фундаментальных концепций разработки приложений для iOS.

      Множество iOS-фреймворков используют MVC.

      Идея MVC заключается в передаче данных из одного места в другое. Это означает,
      что любой объект попадает в одну из этих трех категорий:
    
      Model: Модель представляет данные приложения. Она хранит информацию, например,
       товары в магазине. Модель управляет состоянием приложения.

      View: Вью отвечает за отображение и взаимодействие с пользовательским интерфейсом.
       Например, вью отображает таблицу товаров для пользователя вашего приложения.

      Controller: Контроллер - это то, что склеивает модель и представление.
       Он отвечает за управление логикой, которая происходит между ними.

- ### 💡 Что такое Lazy Variables (ленивые переменные)? Когда их следует использовать?
     <details> <summary> Ответ </summary>

      Начальное значение ленивой переменной вычисляется при первом обращении к ней.
      Ленивые переменные можно использовать для оптимизации кода,
      не выполняя ненужную работу раньше времени.
      Например:
   ```Swift
        lazy var tallest: Person? = {
             return people.max(by: { $0.height < $1.height })
        }()  
   ```
   <p>Чтобы узнать больше о lazy, ознакомьтесь с этой <a href="https://www.codingem.com/swift-lazy-variables/">cтатьей.</a></p>

- ### 💡 Какие преимущества у Realm?
     <details> <summary> Ответ </summary>
          
      - База данных с открытым исходным кодом.
      - Просто внедряется.
      - Хранение объектов без копирования.
      - Скорость.
   <p> Дополнительное чтение: <a href="https://habr.com/ru/articles/272393/">Создание приложения ToDo с помощью Realm и Swift</a></p>

- ### 💡 Объясните архитектуру MVVM?
     <details> <summary> Ответ </summary>
          
      Архитектура MVVM (Model-View-ViewModel) - это популярный паттерн проектирования,
      который широко используется в разработке пользовательских интерфейсов на платформе
      iOS с использованием языка Swift.
      MVVM помогает разделить логику представления от данных и бизнес-логики,
      что облегчает поддержку, тестирование и переиспользование кода.
      В MVVM архитектуре есть три основных компонента: Model, View и ViewModel.

      Связь между компонентами MVVM:

      View связан с ViewModel с помощью биндингов (bindings) или обратных вызовов (callbacks).
      View обновляет свое состояние на основе данных, предоставляемых ViewModel.

      ViewModel взаимодействует с Model для получения данных и обновления данных в
      зависимости от действий пользователя.
  <p> Дополнительное чтение: <a href="https://habr.com/ru/companies/mobileup/articles/313538/">Различия между MVVM и остальными MV*-паттернами</a></p>

- ### 💡 Объясните архитектуру VIPER*?
     <details> <summary> Ответ </summary>
          
      MVC (Model-View-Controller) - это программная архитектура для разработки приложений для iOS.
      Это одна из фундаментальных концепций разработки приложений для iOS.

      Множество iOS-фреймворков используют MVC.

- ### 💡 В чем заключается концепция Чистой Архитектуры?
     <details> <summary> Ответ </summary>
          
      Clean Architecture (Чистая архитектура) - это подход к организации кода и архитектуры приложения,
      который был предложен Робертом Мартином (также известным как "Дядя Боб").
      Цель Чистой архитектуры заключается в создании гибкого, независимого от фреймворков и
      тестируемого кода, который можно легко поддерживать и развивать с течением времени.

      Основная идея Чистой архитектуры состоит в том, чтобы разделить код на слои, где каждый слой
      имеет четко определенные обязанности и зависит только от слоев, находящихся ниже.
      Принципы Чистой архитектуры ориентированы на разделение бизнес-логики от внешних зависимостей,
      таких как фреймворки, базы данных или пользовательский интерфейс.

      Основные компоненты Чистой архитектуры:

      Entities (Сущности): Это основные структуры данных, представляющие бизнес-модель вашего приложения.
       Сущности не зависят от других компонентов и определяют основные правила и логику вашего приложения.

      Use Cases (Использование): Этот слой содержит бизнес-логику и представляет собой сценарии
       использования или операции, которые приложение может выполнять. Он определяет,
       какие операции могут быть выполнены над сущностями и как они должны быть выполнены.

      Interface Adapters (Адаптеры интерфейса): Этот слой связывает внешние зависимости
       (например, фреймворки, базы данных) с внутренними слоями приложения.
       Он переводит данные из формата, понятного внешним зависимостям, во внутренний формат,
       который может быть использован слоями сущностей и использования.

      Frameworks & Drivers (Фреймворки и драйверы): Этот слой содержит внешние зависимости,
       такие как пользовательский интерфейс, базы данных, сетевые службы и т. д.
       Он предоставляет конкретные реализации интерфейсов, определенных в адаптерах интерфейса.
  
      Главная идея Чистой архитектуры заключается в том, что более высокоуровневые слои зависят только от
      низкоуровневых слоев и не знают о конкретных деталях реализации. Это позволяет легко заменять или
      изменять нижние слои без влияния на высокоуровневые слои и улучшает тестируемость и гибкость кода.

      В Swift реализацию Чистой архитектуры можно осуществить с помощью различных паттернов проектирования,
      таких как MVC, MVP, MVVM и VIPER. Выбор конкретного паттерна зависит от требований вашего проекта и
      вашего предпочтения.

      Чистая архитектура является концепцией, которая помогает разработчикам создавать гибкий и модульный код,
      устойчивый к изменениям и легко тестируемый. Она позволяет легко разделять ответственность между
      различными компонентами приложения и сделать ваш код более поддерживаемым и масштабируемым.

- ### 💡 Что такое git-flow?
     <details> <summary> Ответ </summary>
          
      Git-flow - это набор принципов и методология работы с Git, предложенных Винсентом Дриессеном.
      Он предоставляет структуру и набор правил для эффективной организации и управления разработкой
      программного обеспечения с использованием Git.

      Основные концепции и правила Git-flow включают в себя:

      Ветвление (Branching)
      Рабочий процесс (Workflow)
      Команды Git-flow
  
   <p> Дополнительное чтение: <a href="https://habr.com/ru/companies/flant/articles/491320/">Пожалуйста, перестаньте рекомендовать Git Flow</a></p>

- ### 💡 Что такое Erorr Handling?
     <details> <summary> Ответ </summary>
          
      Error Handling (Обработка ошибок) - это механизм, предоставляемый языками программирования,
      для управления и обработки возникающих ошибок и исключительных ситуаций в программном коде.
      Это позволяет программистам предусмотреть и обработать ошибки, которые могут возникнуть
      в процессе выполнения программы, и принять соответствующие меры для восстановления или
      продолжения выполнения программы.

   <p> Дополнительное чтение: <a href="https://habr.com/ru/companies/productivity_inside/articles/320940/">Введение в обработку ошибок в Swift 3</a></p>

- ### 💡 Что такое Замыкания?
     <details> <summary> Ответ </summary>
              
      Замыкания (Closures) - это самостоятельные блоки кода в Swift, которые могут
      быть переданы и использованы как значения внутри кода. Они могут быть рассмотрены как
      анонимные функции или лямбда-выражения в других языках программирования.
      Замыкания позволяют хранить и передавать код как объекты, что делает их мощным
      инструментом для функционального программирования в Swift.

- ### 💡 как работает Render Loop?
     <details> <summary> Ответ </summary>
              
      Render Loop (цикл отрисовки) в iOS - это процесс, при котором система перерисовывает
      содержимое экрана (виды и элементы интерфейса), чтобы обновить пользовательский
      интерфейс и отобразить анимации, изменения или другие визуальные эффекты.
      Render Loop обеспечивает постоянное обновление экрана с частотой кадров
      (обычно 60 кадров в секунду) для создания плавной и реактивной
      пользовательской интерфейсной отзывчивости.

      Render Loop играет ключевую роль в отображении пользовательского интерфейса,
      анимации и других визуальных эффектов в iOS приложениях.
      Он работает следующим образом:

      1 Чтение событий: Прежде чем начать отрисовку, система сначала проверяет
      наличие новых событий, таких как нажатие кнопок или сенсорные жесты.
      Если есть новые события, они помещаются в очередь обработки событий.

      2 Выполнение кода: Следующий шаг - выполнение кода для обработки событий и
      обновления состояния интерфейса на основе пользовательских действий.

      3 Отрисовка экрана: После обработки событий и обновления состояния начинается
      этап отрисовки. Система перерисовывает содержимое экрана, применяя все изменения,
      произошедшие в предыдущих шагах.

      4 Ожидание вертикальной синхронизации (VSync): Чтобы избежать артефактов
      визуального отображения и мерцания, Render Loop синхронизируется с вертикальной
      синхронизацией (VSync) монитора. Это означает, что обновление экрана происходит
      в момент, когда монитор завершает один цикл обновления. В результате, новое
      изображение появляется на экране сразу после завершения предыдущего кадра.

      5 Повторение цикла: После завершения одного цикла Render Loop начинается новый,
      и процесс повторяется снова. Это происходит непрерывно, обеспечивая плавную и
      непрерывную отрисовку интерфейса.
  
  <p> Дополнительное чтение: <a href="https://habr.com/ru/articles/647177/">Оптимизация рендера в iOS: frame buffer, Render Server, FPS, CPU vs GPU</a></p>

- ### 💡 Что такое DI в IOS?
     <details> <summary> Ответ </summary>

      DI (Dependency Injection) - это паттерн проектирования программного обеспечения,
      используемый для управления зависимостями между классами и модулями в приложении.
      В iOS разработке DI позволяет создавать более гибкие, расширяемые и тестируемые
      приложения, уменьшая связанность (coupling) между компонентами.

      Когда классы имеют зависимости от других классов или сервисов, это создает
      "жесткую" связь между ними, что может привести к проблемам, таким как
      сложность внесения изменений или трудность в тестировании.
      Паттерн DI решает эту проблему, перемещая ответственность за создание
      зависимостей из классов, которые их используют, во внешний объект или фабрику.
  
  <p> Дополнительное чтение: <a href="https://habr.com/ru/companies/tinkoff/articles/546360/">DI в iOS: Complete guide</a></p>

- ### 💡 Как работает ARC?
     <details> <summary> Ответ </summary>
