
import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true


var view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
var eiffelImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
eiffelImage.backgroundColor = UIColor.yellow
eiffelImage.contentMode = .scaleAspectFit
view.addSubview(eiffelImage)

PlaygroundPage.current.liveView = view

let imageURL = URL(string: "https://cs4.pikabu.ru/post_img/big/2016/06/23/8/1466685629164656972.jpg")!

//: ### Загрузка классическим способом
func fetchImage() {
    let queue = DispatchQueue.global(qos: .utility)
    queue.async{
        if let data = try? Data(contentsOf: imageURL){
            DispatchQueue.main.async {
                eiffelImage.image = UIImage(data: data)
            }
        }
    }
}



