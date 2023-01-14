

enum VendingMachineError: Error {
    case invalidSelection
    case insufficientFound(coinsNeed: Int)
    case outOfStock
}
