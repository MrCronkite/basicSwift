

import UIKit
import Lottie
import GoogleMobileAds
import AppTrackingTransparency
import FBAudienceNetwork
import KeychainSwift
import Reachability

final class StartViewController: UIViewController {
    
    private let registredUser = RegistredUserImpl()
    private var currentImageIndex = 0
    private var timer: Timer?
    private var secondsElapsed = 0
    private let keychain = KeychainSwift()
    
    @IBOutlet weak var lableText: UILabel!
    @IBOutlet weak var imageBG: UIImageView!
    @IBOutlet weak var imageAnimated: UIImageView!
    @IBOutlet weak var viewAnimated: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupAnimation()
        startImageAnimation()
        checkToken()
        
        AnalyticsManager.shared.logEvent(name: Events.view_start_loading)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        requestDataPermission()
    }
    
    @IBAction func changeImage() {
        currentImageIndex = (currentImageIndex + 1) % R.Strings.Onbording.images.count
        let imageName = R.Strings.Onbording.images[currentImageIndex]
        
        UIView.transition(with: imageAnimated,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
            self.imageAnimated.image = UIImage(named: imageName)
        }, completion: nil)
        
        secondsElapsed += 1
        
        if secondsElapsed >= 6 {
            timer?.invalidate()
            
            let isPremium = UserDefaults.standard.bool(forKey: R.Strings.KeyUserDefaults.premiumKey)
            if isPremium {
                let tabBarController = TabBarController()
                tabBarController.modalPresentationStyle = .fullScreen
                UIApplication.shared.windows.first?.rootViewController = tabBarController
                present(tabBarController, animated: true)
            } else {
                loadAppOpen()
            }
        }
    }
}

extension StartViewController {
    private func setupView() {
        imageBG.contentMode = .scaleAspectFill
        lableText.text = "Gem Identifire"
    }
    
    private func startImageAnimation() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self,
                                     selector: #selector(changeImage),
                                     userInfo: nil, repeats: true)
    }
    
    private func setupAnimation() {
        let animationView = LottieAnimationView(name: "startAnim")
        animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        viewAnimated.center = animationView.center
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        viewAnimated.addSubview(animationView)
        animationView.play()
    }
    
    private func checkToken() {
        if UserDefaults.standard.string(forKey: R.Strings.KeyUserDefaults.tokenKey) == nil {
            if let login = keychain.get("login") {
                if LoadingIndicator.checkInthernet() {
                self.loginUser(username: login)
                } else {
                    self.alertNoEthernet()
                    LoadingIndicator.startCheckingInternet { result in
                        if result {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                self.loginUser(username: login)
                            }
                        }
                    }
                }
            } else {
                LoadingIndicator.startCheckingInternet { result in
                    if result {
                        DispatchQueue.main.async {
                            self.authentificationUser()
                        }
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                            self.checkToken()
                        }
                    }
                }
            }
        }
    }
    
    private func loadAppOpen() {
        if !GoogleAd.shared.showAppOpen() {
            self.goToOnbording()
        }
        
        GoogleAd.shared.adViewedAction = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.goToOnbording()
            }
        }
    }
    
    private func goToOnbording() {
        let vc = OnbordingViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    private func alertNoEthernet() {
        let alert = UIAlertController(title: "alert_no_internet".localized, message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "alert_cancel".localized, style: .default) { _ in
            alert.dismiss(animated: false)
            self.goToOnbording()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func authentificationUser() {
        let credentials = generateUniqueUsernameAndPassword()
        keychain.set(credentials.username, forKey: "login")
        keychain.set(credentials.password, forKey: "password")
        registredUser.registerUser(username: credentials.username,
                                   password: credentials.password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                UserDefaults.standard.set(token.token, forKey: R.Strings.KeyUserDefaults.tokenKey)
            case .failure(_):
                self.checkToken()
            }
        }
    }
    
    private func loginUser(username: String) {
        guard let password = keychain.get("password") else { return }
        registredUser.loginUser(username: username, password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                UserDefaults.standard.set(token.token, forKey: R.Strings.KeyUserDefaults.tokenKey)
            case .failure(_):
                self.authentificationUser()
            }
        }
    }
    
    private func generateRandomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
    
    private func generateUniqueUsernameAndPassword() -> (username: String, password: String) {
        let username = "user_" + generateRandomString(length: 8)
        let password = generateRandomString(length: (10...20).randomElement()!)
        return (username, password)
    }
    
    private func requestDataPermission() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                switch status {
                case .authorized:
                    FBAdSettings.setAdvertiserTrackingEnabled(true)
                    print("Authorized")
                case .denied:
                    FBAdSettings.setAdvertiserTrackingEnabled(false)
                    print("Denied")
                case .notDetermined:
                    
                    print("Not Determined")
                case .restricted:
                    print("Restricted")
                @unknown default:
                    print("Unknown")
                }
            })
        } else {
            //you got permission to track, iOS 14 is not yet installed
        }
    }
}

