
import UIKit


let mainQueue = DispatchQueue.main

let userInteractiveQueue = DispatchQueue.global(qos: .userInteractive)
let userQueue = DispatchQueue.global(qos: .userInitiated)
let utilityQueue = DispatchQueue.global(qos: .utility)
let backgroundQueue = DispatchQueue.global(qos: .background)

let defаultQueue = DispatchQueue.global()


func task(_ symbol: String) { for i in 1...10 {
    print("\(symbol) \(i) prioritet = \(qos_class_self().rawValue)")
    }
}

func taskHIGH(_ symbol: String) {
    print("\(symbol) HIGH prioritet = \(qos_class_self().rawValue)")
}


