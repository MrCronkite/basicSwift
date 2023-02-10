
import UIKit
import PlaygroundSupport


@available(iOS 15, *)
 public class EightImages: UIView {
    public var ivs = [UIImageView] ()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        ivs.append(UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100)))
        ivs.append(UIImageView(frame: CGRect(x: 0, y: 100, width: 100, height: 100)))
             ivs.append(UIImageView(frame: CGRect(x: 100, y: 0, width: 100, height: 100)))
             ivs.append(UIImageView(frame: CGRect(x: 100, y: 100, width: 100, height: 100)))
             
             ivs.append(UIImageView(frame: CGRect(x: 0, y: 300, width: 100, height: 100)))
             ivs.append(UIImageView(frame: CGRect(x: 100, y: 300, width: 100, height: 100)))
             ivs.append(UIImageView(frame: CGRect(x: 0, y: 400, width: 100, height: 100)))
             ivs.append(UIImageView(frame: CGRect(x: 100, y: 400, width: 100, height: 100)))
        for i in 0...7 {
            ivs[i].contentMode = .scaleAspectFit
            self.addSubview(ivs[i])
        }
    }
    
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

PlaygroundPage.current.needsIndefiniteExecution = true

var view = EightImages(frame: CGRect(x: 0, y: 0, width: 200, height: 500))
view.backgroundColor = UIColor.red

let imageURLs = ["http://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg", "http://adriatic-lines.com/wp-content/uploads/2015/04/canal-of-Venice.jpg", "http://bestkora.com/IosDeveloper/wp-content/uploads/2016/12/Screen-Shot-2017-01-17-at-9.33.52-PM.png", "http://www.picture-newsletter.com/arctic/arctic-12.jpg" ]
var images = [UIImage] ()

PlaygroundPage.current.liveView = view


func asyncLoadImage(imageURL: URL, runQueue: DispatchQueue, completionQueue: DispatchQueue, completion: @escaping (UIImage?, Error?) -> ()) {
    runQueue.async {
        do {
            let data = try Data(contentsOf: imageURL)
            completionQueue.async { completion(UIImage(data: data), nil)}
        } catch let error {
            completionQueue.async { completion(nil, error)}
        }
    }
}



func asyncGroup(){
    let aGroup = DispatchGroup()
    
    for i in 0...3 {
        aGroup.enter()
        asyncLoadImage(imageURL: URL(string: imageURLs[i])!,
                       runQueue: DispatchQueue.global(),
                       completionQueue: DispatchQueue.main) { result, error in
            guard let image1 = result else {return}
            images.append(image1)
            aGroup.leave()
        }
    }
    
    aGroup.notify(queue: DispatchQueue.main) {
        for i in 0...3 {
            view.ivs[i].image = images[i]
        }
    }
}

asyncGroup()
