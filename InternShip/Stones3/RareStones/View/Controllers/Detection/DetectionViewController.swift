

import UIKit
import CoreMotion
import CoreLocation

final class DetectionViewController: UIViewController{
    
    private var percent = 0
    private let motionManager = CMMotionManager()
    private var magneticFieldValue = 0
    private var isDetecting = false
    
    @IBOutlet weak private var lableSubtitle: UILabel!
    @IBOutlet weak private var lableText: UILabel!
    @IBOutlet weak private var polygon: UIImageView!
    @IBOutlet weak private var btnStart: UIButton!
    @IBOutlet weak private var stackView: UIView!
    @IBOutlet weak private var box1: UILabel!
    @IBOutlet weak private var box2: UILabel!
    @IBOutlet weak private var box3: UILabel!
    @IBOutlet weak private var subtitle1: UILabel!
    @IBOutlet weak private var subtitle2: UILabel!
    @IBOutlet weak private var subtitle3: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localiz()
        AnalyticsManager.shared.logEvent(name: Events.open_detection_view)
    }
    
    override func viewWillLayoutSubviews() {
        setupView()
        view.setupLayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        stopDetection()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopDetection()
        motionManager.stopMagnetometerUpdates()
    }
    
    @IBAction func detect(_ sender: Any) {
        AnalyticsManager.shared.logEvent(name: Events.start_detection_button)
        if isDetecting {
            stopDetection()
        } else {
            startDetection()
        }
    }
    
    private func startDetection() {
        if UserDefaults.standard.bool(forKey: R.Strings.KeyUserDefaults.premiumKey) {
            AnalyticsManager.shared.logEvent(name: Events.detect_stone)
            setupDetector()
            isDetecting = true
            btnStart.setTitle("Stop", for: .normal)
        } else {
            let vc = SubDetectorViewController()
            vc.delegate = self
            present(vc, animated: true)
        }
    }
    
    private func stopDetection() {
        motionManager.stopMagnetometerUpdates()
        isDetecting = false
        btnStart.setTitle("detect_btn_start".localized, for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.lableText.text = "\(Int(0))%"
            self.handleReceivedValue(CGFloat(0))
        }
    }
    
    @IBAction func appWillEnterForeground() {
        isDetecting = false
        btnStart.setTitle("detect_btn_start".localized, for: .normal)
        motionManager.stopMagnetometerUpdates()
        self.lableText.text = "\(Int(0))%"
        self.handleReceivedValue(CGFloat(0))
    }
}

extension DetectionViewController {
    private func setupView() {
        btnStart.backgroundColor = R.Colors.roseBtn
        btnStart.layer.cornerRadius = 25
        lableSubtitle.greyColor()
        stackView.backgroundColor = R.Colors.whiteBlue
        stackView.layer.cornerRadius = 15
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.white.cgColor
        
        [box1, box2, box3].forEach { $0?.backgroundColor = R.Colors.roseBtn
            $0?.layer.cornerRadius = 8
        }
        [subtitle1, subtitle2, subtitle3].forEach {
            $0?.greyColor()
        }
        
        navigationController?.navigationBar.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    private func alert() {
        let alert = UIAlertController(title: "alert_no_available".localized, message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "alert_close".localized, style: .default)
        
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
    
    private func interpolateValue(_ value: CGFloat, from: CGFloat, to: CGFloat, minAngle: CGFloat, maxAngle: CGFloat) -> CGFloat {
        let normalizedValue = (value - from) / (to - from)
        let angleRange = maxAngle - minAngle
        return minAngle + normalizedValue * angleRange
    }
    
    private func updateImageRotation(angle: CGFloat) {
        polygon.transform = CGAffineTransform(rotationAngle: angle)
    }
    
    private func handleReceivedValue(_ value: CGFloat) {
        let angle = interpolateValue(value, from: 0, to: 100, minAngle: 0, maxAngle: .pi)
        updateImageRotation(angle: angle)
    }
    
    private func performActionWithDelay(delay: TimeInterval) {
        DispatchQueue.global().asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self else { return }
            if self.percent < 10 {
                if self.isDetecting {
                    AnalyticsManager.shared.logEvent(name: Events.detect_screen)
                    DispatchQueue.main.async {
                        self.makeBlurEffect()
                    }
                }
                print("Received number: \(self.percent)")
            } else {
                print("Number not received within \(delay) seconds")
            }
        }
    }
    
    private func makeBlurEffect() {
        let vc = BlurViewController()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    private func setupDetector() {
        performActionWithDelay(delay: 4)
        if motionManager.isMagnetometerAvailable {
            motionManager.magnetometerUpdateInterval = 0.05
            motionManager.startMagnetometerUpdates(to: OperationQueue.main) { [self] (magnetometerData, error) in
                if let data = magnetometerData {
                    let magneticFieldY = data.magneticField.y
                    self.magneticFieldValue = Int(sqrt(abs(magneticFieldY)) + sqrt(abs(magneticFieldY)))
                    let clampedValue = min(100, max(0, self.magneticFieldValue))
                    
                    self.percent = Int(clampedValue)
                    self.handleReceivedValue(CGFloat(clampedValue))
                    self.lableText.text = "\(Int(clampedValue))%"
                }
            }
        } else {
            alert()
        }
    }
    
    private func localiz() {
        lableSubtitle.text = "detect_sub_text".localized
        lableSubtitle.adjustsFontSizeToFitWidth = true
        subtitle1.text = "detect_first_text".localized
        subtitle2.text = "detect_second_text".localized
        subtitle3.text = "detect_therd_text".localized
        btnStart.setTitle("detect_btn_start".localized, for: .normal)
    }
}

extension DetectionViewController: SubDetectorViewControllerDelegate {
    func showAdd() {
        setupDetector()
        isDetecting = true
        btnStart.setTitle("Stop", for: .normal)
    }
}






