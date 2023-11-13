

import UIKit
import Moya

protocol RecognitionViewProtocol: AnyObject {
    func startAnimation()
    func updateTimer()
}

protocol RecognitionPresenter: AnyObject {
    var images: [UIImage] { get set }
    var resultCoins: [ResultsCoins]? { get set }
    var category: Int { get set }
    
    init(view: RecognitionViewProtocol, router: RouterProtocol, classificationProvider: MoyaProvider<ClassificationAPIService>, storage: UserSettings)
    
    func startAnimation()
    func startTimer()
    func stopTimer()
    func goRecognition()
}

final class RecognitionPresenterImpl: RecognitionPresenter {
    weak var view: RecognitionViewProtocol?
    var router: RouterProtocol?
    var images: [UIImage] = []
    var timer: Timer?
    var classificationProvider: MoyaProvider<ClassificationAPIService>?
    var resultCoins: [ResultsCoins]? = nil
    var category: Int = 0
    var storage: UserSettings?
    
    init(view: RecognitionViewProtocol, router: RouterProtocol, classificationProvider: MoyaProvider<ClassificationAPIService>, storage: UserSettings) {
        self.view = view
        self.router = router
        self.classificationProvider = classificationProvider
        self.storage = storage
    }
    
    @objc func updateView() {
        view?.updateTimer()
    }
    
    func goRecognition() {
        classificationProvider?.request(.uploadImages(image: self.images.first!), completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(response):
                do {
                    let coins = try response.map(Coin.self)
                    self.resultCoins = coins.results
                } catch {
                    print( String(data: response.data, encoding: .utf8) ?? "")
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        })
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.9, target: self, selector: #selector(updateView), userInfo: nil, repeats: true)
        goRecognition()
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        router?.popToView(isAnimate: false)
        if self.resultCoins == nil {
            router?.goToNoMatch(images: self.images)
        } else {
            goToresult()
        }
    }
    
    func goToresult() {
        print(storage)
        if storage?.premium(forKey: .keyPremium) ?? false {
            router?.goToCardCoin(tab: .camera,
                                 coins: self.resultCoins ?? [],
                                 images: self.images,
                                 category: self.category)
        } else {
            router?.goToMatch(images: self.images,
                              coin: self.resultCoins ?? [],
                              category: self.category)
        }
    }
    
    func startAnimation() {
        view?.startAnimation()
    }
}
