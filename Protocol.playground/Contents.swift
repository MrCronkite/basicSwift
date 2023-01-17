


protocol SomeProtocol {
    func printHello()
}


struct SomeStructura: SomeProtocol {
    func printHello() {
        print("hello world")
    }
    
}
