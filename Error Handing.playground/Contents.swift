

enum VendingMachineError: Error {
    case invalidSelection
    case insufficientFound(coinsNeed: Int)
    case outOfStock
}

throw VendingMachineError.insufficientFound(coinsNeed: 4)


struct Item {
    var price: Int
    var count: Int
}

class VendingMachine {
    var inventory = [
        "Candy Bar": Item(price: 12, count: 7),
        "Chips": Item(price: 10, count: 4),
        "Pretzels": Item(price: 7, count: 11)
    ]
     
    var coinsDeposited = 0
    
    func vend(itemName name: String) throws {
        
        guard inventory[name] != nil else {
            throw VendingMachineError.invalidSelection
        }
        
    }
}
