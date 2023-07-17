
import UIKit
import PlaygroundSupport



let mainQueue = DispatchQueue.main

let userInteractiveQueue = DispatchQueue.global(qos: .userInteractive)
let userQueue = DispatchQueue.global(qos: .userInitiated)
let utilityQueue = DispatchQueue.global(qos: .utility)
let backgroundQueue = DispatchQueue.global(qos: .background)

let defаultQueue = DispatchQueue.global()


func task(_ symbol: String) {
    for i in 1...6 {
    print("\(symbol) \(i) prioritet = \(qos_class_self().rawValue)")
    }
}

func taskHIGH(_ symbol: String) {
    print("\(symbol) HIGH prioritet = \(qos_class_self().rawValue)")
}


print("______Sinc__________")

userQueue.sync {
    task("☠️")
}
task("🪰")

sleep(2)


print("___________Asinc________")

userQueue.async {
    task("☠️")
}
task("🪰")

let mySerialQueue = DispatchQueue(label: "best,mySerial", qos: .userInitiated)

mySerialQueue.async {
    task("🎃")
}

mySerialQueue.async {
    task("🤖")
}

sleep (1)

let sirealQueue1 = DispatchQueue(label: "queue1", qos: .background)
let sirealQueue2 = DispatchQueue(label: "queue2", qos: .userInitiated)

if sirealQueue1.label == "queue1" { print(true) }

sirealQueue2.async {
    task("🐡")
}

sirealQueue1.async {
    task("🦍")
}

sleep(1)


print("_________Concurent_Private___")

let highPriorityItem = DispatchWorkItem(qos: .userInitiated, flags: [.enforceQoS]) {
    taskHIGH("🦈")
}

let workerQueue = DispatchQueue(label: "Queue1", qos: .userInitiated, attributes: .concurrent)

workerQueue.async { task("🦚")}
workerQueue.async { task("🦢")}
sirealQueue1.async(execute: highPriorityItem)
sirealQueue2.async(execute: highPriorityItem)

sleep(2)


