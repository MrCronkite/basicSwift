import UIKit
import PlaygroundSupport


PlaygroundPage.current.needsIndefiniteExecution = true


class vievController: UIViewController {
    
    
    override func loadView() {
        super.loadView()
        print("loadView")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
    }
    
}


PlaygroundPage.current.liveView = vievController() as any PlaygroundLiveViewable

