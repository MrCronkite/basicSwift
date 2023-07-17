import UIKit
import PlaygroundSupport


PlaygroundPage.current.needsIndefiniteExecution = true


class vievController: UIViewController {
    
    
    let button = UIButton()
    
    
    override func loadView() {
        super.loadView()
        
        print("loadView")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        button.frame(forAlignmentRect: CGRect(x: 10, y: 10, width: 100, height: 100))
        button.setTitle("Click", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        view.addSubview(button)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("viewWillLayoutSubviews")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("viewDidLayoutSubviews")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear")
    }
    
}


PlaygroundPage.current.liveView = vievController()

