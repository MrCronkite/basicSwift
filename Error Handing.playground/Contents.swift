

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
    
    var item = Item(price: 10, count: 10)
    
    func vend(itemName name: String) throws {
        
        guard inventory[name] != nil else {
            throw VendingMachineError.invalidSelection
        }
        
        guard item.count > 0 else {
            throw VendingMachineError.outOfStock
        }
               
        guard item.price <= coinsDeposited else {
            throw VendingMachineError.insufficientFound(coinsNeed: item.price - coinsDeposited)
        }
               
        coinsDeposited -= item.price
               
        var newItem = item
        newItem.count -= 1
        inventory[name] = newItem
               
        print("Dispensing \(name)")
    }
}

