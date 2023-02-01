import UIKit
import PlaygroundSupport


PlaygroundPage.current.needsIndefiniteExecution = true


class vievController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hello world")
    }
    
}


PlaygroundPage.current.liveView = vievController() as any PlaygroundLiveViewable

