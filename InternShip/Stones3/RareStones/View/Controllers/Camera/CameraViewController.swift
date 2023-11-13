

import UIKit
import AVFoundation
import Lottie
import NVActivityIndicatorView

final class CameraViewController: UIViewController {
    
    var isAccessCamera = false
    var isFlash = false
    
    var cameraImg = UIImage()
    var currentPercentage = 0
    var currentIndex = 0
    let networkClass = NetworkClassificationImpl()
    var data: StonePhoto? = nil
    let photoTipsVC = PhotoTipsViewController()
    let capturePhotoOutput = AVCapturePhotoOutput()
    let captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var alertController: UIAlertController?
    
    let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return view
    }()
    
    @IBOutlet weak var keepLabel: UILabel!
    @IBOutlet weak var containerText: UIView!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var titleCamera: UILabel!
    @IBOutlet weak var tipsLable: UILabel!
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var indetifactionTxt: UILabel!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var animateView: UIView!
    @IBOutlet weak var flashBtn: UIImageView!
    @IBOutlet weak var mainBtn: UIButton!
    @IBOutlet weak var imageBtn: UIImageView!
    @IBOutlet weak var flashView: UIView!
    @IBOutlet weak var imgView: UIView!
    @IBOutlet weak var openSettingsBtn: UIButton!
    @IBOutlet weak var separator: UIImageView!
    @IBOutlet weak var boxShadowView: UIView!
    @IBOutlet weak var lookingText: UILabel!
    @IBOutlet weak var percentText: UILabel!
    @IBOutlet weak var presentPhotoView: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localize()
        setupCamera()
        setupView()
        setupAnimation()
        requestCameraAccess()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        AnalyticsManager.shared.logEvent(name: Events.open_camera_view)
    }
    
    override func viewDidLayoutSubviews() {
        cameraView.setupLayer()
        videoPreviewLayer?.frame = cameraView.frame
        overlayView.frame = presentPhotoView.frame
        presentPhotoView.addSubview(overlayView)
        
        if !captureSession.isRunning {
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.startRunning()
            }
        }
    }
    
    deinit {
        AnalyticsManager.shared.logEvent(name: Events.close_camera_view)
    }
    
    @IBAction func camShot(_ sender: Any) {
        if isAccessCamera {
            mainBtn.isEnabled = false
            DispatchQueue.main.async {
                let settings = AVCapturePhotoSettings()
                if self.isFlash {
                    settings.flashMode = .on
                } else { settings.flashMode = .off }
                self.captureSession.addOutput(self.capturePhotoOutput)
                self.capturePhotoOutput.capturePhoto(with: settings, delegate: self)
            }
        } else {
            LoadingIndicator.allowCamera(view: self)
        }
    }
    
    @IBAction func openSettings(_ sender: Any) {
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSettings)
        }
    }
    
    @IBAction func closeView(_ sender: Any) {
        if captureSession.isRunning {
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.stopRunning()
            }
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func showTips(_ sender: Any) {
        AnalyticsManager.shared.logEvent(name: Events.open_photo_tips)
        let vc = PhotoTipsViewController()
        present(vc, animated: true)
    }
    
    @IBAction func toggleGaller(_ sender: UITapGestureRecognizer) {
        AnalyticsManager.shared.logEvent(name: Events.open_photo_galery)
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func appWillEnterForeground() {
        flashBtn.image = UIImage(named: "cam3")
    }
    
    @IBAction func toggleFlash(_ sender: UITapGestureRecognizer) {
        if isAccessCamera {
            if let captureDevice = AVCaptureDevice.default(for: .video) {
                do {
                    try captureDevice.lockForConfiguration()
                    if captureDevice.hasTorch {
                        if captureDevice.isTorchActive {
                            captureDevice.torchMode = .off
                            flashBtn.image = UIImage(named: "cam3")
                            isFlash = false
                        } else {
                            try captureDevice.setTorchModeOn(level: 1.0)
                            flashBtn.image = UIImage(named: "camOff")
                            isFlash = true
                        }
                    }
                    captureDevice.unlockForConfiguration()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension CameraViewController {
    private func setupView() {
        tabBarController?.tabBar.isHidden = true
        [imgView, flashView].forEach {
            $0?.layer.cornerRadius = 25
            $0?.backgroundColor = R.Colors.purple
        }
        
        let tapFlash = UITapGestureRecognizer(target: self, action: #selector(toggleFlash(_:)))
        flashView.addGestureRecognizer(tapFlash)
        flashView.isUserInteractionEnabled = true
        
        let tapImg = UITapGestureRecognizer(target: self, action: #selector(toggleGaller(_:)))
        imgView.addGestureRecognizer(tapImg)
        imgView.isUserInteractionEnabled = true
        
        let tipsTap = UITapGestureRecognizer(target: self, action: #selector(showTips))
        tipsLable.isUserInteractionEnabled = true
        tipsLable.addGestureRecognizer(tipsTap)
        
        boxShadowView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        boxShadowView.layer.cornerRadius = 13
        boxShadowView.isHidden = false
        lookingText.isHidden = true
        percentText.isHidden = true
        lookingText.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        lookingText.layer.cornerRadius = 13
        lookingText.clipsToBounds = true
        overlayView.isHidden = true
        shadowView.isHidden = true
        animateView.isHidden = true
        indetifactionTxt.isHidden = true
        mainBtn.isEnabled = false
    }
    
    private func setupCamera() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = .resizeAspectFill
            videoPreviewLayer?.zPosition = -1
            
            isAccessCamera = true
            openSettingsBtn.isHidden = true
            containerText.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.mainBtn.isEnabled = true
            }
        } catch {
            boxShadowView.isHidden = true
            separator.isHidden = true
            openSettingsBtn.isHidden = false
        }
    }
    
    private func requestCameraAccess() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            guard let self = self else { return }
            if granted {
                AnalyticsManager.shared.logEvent(name: Events.camera_view_allow)
                DispatchQueue.main.async {
                    self.cameraView.layer.addSublayer(self.videoPreviewLayer!)
                    self.separator.isHidden = false
                    self.boxShadowView.isHidden = false
                }
            } else {
                AnalyticsManager.shared.logEvent(name: Events.camera_view_disallow)
                DispatchQueue.main.async {
                    self.boxShadowView.isHidden = true
                    self.separator.isHidden = true
                    self.openSettingsBtn.isHidden = false
                    self.containerText.isHidden = false
                    self.isAccessCamera = false
                    self.mainBtn.isEnabled = true
                }
            }
        }
    }
    
    private func updateLabel() {
        lookingText.text = R.Strings.Camera.loadingText[currentIndex]
        currentIndex = (currentIndex + 1) % R.Strings.Camera.loadingText.count
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.updateLabel()
        }
    }
    
    private func setupAnimation() {
        let animationView = LottieAnimationView(name: "diamond")
        animationView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        animateView.center = animationView.center
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        animateView.backgroundColor = .clear
        animationView.backgroundColor = .clear
        animateView.addSubview(animationView)
        animationView.play()
    }
    
    private func updatePercent() {
        percentText.isHidden = false
        percentText.text = "\(currentPercentage)%"
        if currentPercentage < 100 {
            currentPercentage += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.07) {
                self.updatePercent()
            }
        } else {
            currentPercentage = 0
            presentPhotoView.image = UIImage()
            lookingText.isHidden = true
            percentText.isHidden = true
            separator.isHidden = false
            boxShadowView.isHidden = false
            animateView.isHidden = true
            overlayView.isHidden = true
            shadowView.isHidden = true
            indetifactionTxt.isHidden = true
            showViewAdd()
        }
    }
    
    private func sendPhoto(image: UIImage) {
        let resizedImage = image.cropToCenter()
        guard let imageData = resizedImage?.jpegData(compressionQuality: 0.1) else { return }
        networkClass.sendImageData(image: imageData) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.data = data
                }
            case .failure(_): break
            }
        }
    }
    
    private func showViewAdd() {
        if UserDefaults.standard.bool(forKey: R.Strings.KeyUserDefaults.premiumKey) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.showViewMatchesStone()
            }
        } else {
            let vcSub = SubscribeCameraViewController()
            vcSub.image = cameraImg
            vcSub.delegate = self
            present(vcSub, animated: true)
        }
    }
    
    private func showViewMatchesStone() {
        let vc = NotFoundViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.image = cameraImg
        if data != nil {
            let vc = MatchViewController()
            vc.matchStones = data
            navigationController?.pushViewController(vc, animated: true)
        } else {
            mainBtn.isEnabled = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func localize() {
        mainBtn.setTitle("", for: .normal)
        buttonClose.setTitle("", for: .normal)
        indetifactionTxt.text = "cam_identification".localized
        titleCamera.text = "cam_settings_title".localized
        subtitle.text = "cam_settings_subtitle".localized
        subtitle.adjustsFontSizeToFitWidth = true
        openSettingsBtn.setTitle("cam_settings_button".localized, for: .normal)
        keepLabel.text = "cam_keep_text".localized
        keepLabel.adjustsFontSizeToFitWidth = true
        tipsLable.text = "cam_photo_tips".localized
        tipsLable.adjustsFontSizeToFitWidth = true
    }
}

extension CameraViewController: SubscribeCameraViewControllerDelegate {
    func showMatchesStone() {
        DispatchQueue.main.async {
            self.showViewMatchesStone()
        }
    }
    
    func closeCamera() {
        navigationController?.popToRootViewController(animated: false)
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(), let capturedImage = UIImage(data: imageData) {
            presentPhotoView.image = capturedImage
            presentPhotoView.contentMode = .scaleAspectFill
            boxShadowView.isHidden = true
            separator.isHidden = true
            lookingText.isHidden = false
            overlayView.isHidden = false
            shadowView.isHidden = false
            animateView.isHidden = false
            indetifactionTxt.isHidden = false
            updateLabel()
            updatePercent()
            cameraImg = capturedImage
            sendPhoto(image: self.cameraImg)
            flashBtn.image = UIImage(named: "cam3")
            AnalyticsManager.shared.logEvent(name: Events.photo_taken_on_camera)
        }
        captureSession.removeOutput(output)
    }
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            cameraImg = selectedImage
            presentPhotoView.image = selectedImage
            presentPhotoView.contentMode = .scaleAspectFill
            boxShadowView.isHidden = true
            separator.isHidden = true
            lookingText.isHidden = false
            shadowView.isHidden = false
            overlayView.isHidden = false
            animateView.isHidden = false
            openSettingsBtn.isHidden = true
            containerText.isHidden = true
            indetifactionTxt.isHidden = false
            updateLabel()
            updatePercent()
            sendPhoto(image: self.cameraImg)
            AnalyticsManager.shared.logEvent(name: Events.photo_taken_galery)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
