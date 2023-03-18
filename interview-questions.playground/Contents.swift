// Swift
import UIKit
import PlaygroundSupport

class Singleton {

    private static var uniqueInstance: Singleton?

    private init() {}

    static func shared() -> Singleton {
        if uniqueInstance == nil {
            uniqueInstance = Singleton()
        }
        return uniqueInstance!
    }

}



//MARK: - Decorator
typealias Decoration<T> = (T) -> Void


//MARK: - Observing





