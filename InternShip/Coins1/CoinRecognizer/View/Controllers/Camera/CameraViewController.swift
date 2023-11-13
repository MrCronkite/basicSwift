

import UIKit
import AVFoundation
import GoogleMobileAds

final class CameraViewController: UIViewController {
    
    var presenter: CameraPresenter?
    
    @IBOutlet weak private var heightBannerConstraint: NSLayoutConstraint!
    @IBOutlet weak private var titleStep: UILabel!
    @IBOutlet weak private var subtitleStep: UILabel!
    @IBOutlet weak private var crossView: UIImageView!
    @IBOutlet weak private var focusView: UIView!
    @IBOutlet weak private var closeViewBtn: UIButton!
    @IBOutlet weak private var flashlightBtn: UIButton!
    @IBOutlet weak private var headerView: UIView!
    @IBOutlet weak private var closeBtnObverse: UIButton!
    @IBOutlet weak private var closeBtnReverse: UIButton!
    @IBOutlet weak private var photoCoinsPreviews: UIView!
    @IBOutlet weak private var reversePhoto: UIImageView!
    @IBOutlet weak private var obversePhoto: UIImageView!
    @IBOutlet weak private var titleObverse: UILabel!
    @IBOutlet weak private var titleReverse: UILabel!
    @IBOutlet weak private var footerBar: UIView!
    @IBOutlet weak private var galeryBtn: UIButton!
    @IBOutlet weak private var flashBtn: UIButton!
    @IBOutlet weak private var adContainer: UIView!
    @IBOutlet weak private var cameraBtn: UIButton!
    @IBOutlet weak private var cameraLayerView: UIView!
    @IBOutlet weak var containerAccesCamera: UIView!
    @IBOutlet weak var buttonSetings: UIButton!
    @IBOutlet weak var subtitleAcces: UILabel!
    @IBOutlet weak var titleAcces: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.setupCamera()
        setupView()
        localize()
        presenter?.requestCameraAccess()
        presenter?.loadBanner()
    }
    
    override func viewDidLayoutSubviews() {
        footerBar.roundTopCorners(radius: 40)
        presenter?.videoPreviewLayer.frame = cameraLayerView.frame
        presenter?.startCaptureSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (presenter?.isAccesCamera)! {
            cameraLayerView.setupVisualEffect(focusView: focusView)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        for subview in cameraLayerView.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
    }
    
    @IBAction private func setFlash(_ sender: Any) {
        presenter?.isFlash()
    }
    
    @IBAction private func makeCameraPhoto(_ sender: Any) {
        if (presenter?.isAccesCamera)! {
            presenter?.takePhoto()
            cameraBtn.isEnabled = false
        } else {
            presenter?.openSettings()
        }
    }
    
    @IBAction private func showPhotoLibrary(_ sender: Any) {
        presenter?.openPhotoLibrary()
    }
    
    @IBAction private func clearReverse(_ sender: Any) {
        presenter?.clearReversePhoto()
    }
    
    @IBAction private func clearObverse(_ sender: Any) {
        presenter?.clearObversePhoto()
    }
    
    @IBAction private func closeCameraView(_ sender: Any) {
        presenter?.goToRoot()
    }
    
    @IBAction private func turnOnTheFlashlight(_ sender: Any) {
        presenter?.turnOfLight()
    }
    
    @IBAction private func openSettings(_ sender: Any) {
        presenter?.openSettings()
    }
}

private extension CameraViewController {
    func setupView() {
        tabBarController?.tabBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        galeryBtn.setImage(Asset.Assets.gallery.image, for: .normal)
        galeryBtn.setTitle("", for: .normal)
        flashBtn.setImage(Asset.Assets.turnOff.image, for: .normal)
        flashBtn.setTitle("", for: .normal)
        cameraBtn.setImage(Asset.Assets.button.image, for: .normal)
        cameraBtn.setTitle("", for: .normal)
        reversePhoto.addDashedBorder(isDash: true, radius: 34, lineDash: 4, color: .white)
        obversePhoto.addDashedBorder(isDash: true, radius: 34, lineDash: 4, color: .white)
        obversePhoto.contentMode = .scaleAspectFill
        reversePhoto.contentMode = .scaleAspectFill
        
        closeBtnObverse.setTitle("", for: .normal)
        closeBtnReverse.setTitle("", for: .normal)
        closeBtnObverse.setImage(Asset.Assets.closeMini.image, for: .normal)
        closeBtnObverse.isHidden = true
        closeBtnReverse.setImage(Asset.Assets.closeMini.image, for: .normal)
        closeBtnReverse.isHidden = true
        
        flashlightBtn.setImage(Asset.Assets.inport.image, for: .normal)
        flashlightBtn.setTitle("", for: .normal)
        closeViewBtn.setImage(Asset.Assets.close.image, for: .normal)
        closeViewBtn.setTitle("", for: .normal)
        
        focusView.layer.cornerRadius = 107
        focusView.layer.borderWidth = 4
        focusView.layer.borderColor = UIColor.white.cgColor
        
        crossView.image = Asset.Assets.cross.image
        crossView.contentMode = .scaleAspectFill
        titleStep.text = R.Strings.Camera.step1.first
        subtitleStep.text = R.Strings.Camera.step1.last
        cameraBtn.isEnabled = false
    }
    
    func localize() {
        buttonSetings.setTitle("button_settings".localized, for: .normal)
        titleAcces.text = "title_acces".localized
        subtitleAcces.text = "subtitle_acces".localized
        titleObverse.text = "obverse".localized
        titleObverse.lineBreakMode = .byClipping
        titleObverse.adjustsFontSizeToFitWidth = true
        titleReverse.text = "reverse".localized
        titleReverse.lineBreakMode = .byClipping
        titleReverse.adjustsFontSizeToFitWidth = true
    }
}


extension CameraViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            presenter?.processAndCollectImages(selectedImage)
            AnaliticsService.shared.logEvent(name: Events.photo_taken_galery)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension CameraViewController: UINavigationControllerDelegate {
}

extension CameraViewController: CameraViewProtocol {
    func setupBanner(ad: GADBannerView) {
        heightBannerConstraint.constant = 50
        ad.rootViewController = self
        adContainer.addBannerViewToView(ad)
    }
    
    func accessCamera() {
        if let videoPreviewLayer = presenter?.videoPreviewLayer {
            cameraBtn.isEnabled = true
            cameraLayerView.isHidden = false
            cameraLayerView.layer.addSublayer(videoPreviewLayer)
        }
    }
    
    func isFlash(_ isValueFlash: Bool) {
        if isValueFlash {
            flashBtn.setImage(Asset.Assets.turnOn.image, for: .normal)
        } else {
            flashBtn.setImage(Asset.Assets.turnOff.image, for: .normal)
        }
    }
    
    func collectSidesCoin(image: UIImage) {
        cameraBtn.isEnabled = true
        if obversePhoto.image == nil {
            titleStep.text = R.Strings.Camera.step2.first
            subtitleStep.text = R.Strings.Camera.step2.last
            obversePhoto.image = image
            obversePhoto.addDashedBorder(isDash: false, radius: 35, lineDash: 4, color: .white)
            titleObverse.isHidden = true
            closeBtnObverse.isHidden = false
        } else if reversePhoto.image == nil {
            titleStep.text = ""
            subtitleStep.text = ""
            reversePhoto.image = image
            reversePhoto.addDashedBorder(isDash: false, radius: 35, lineDash: 4, color: .white)
            titleReverse.isHidden = true
            closeBtnReverse.isHidden = false
            cameraBtn.isEnabled = false
        }
    }
    
    func clearObversePhoto() {
        cameraBtn.isEnabled = true
        titleStep.text = R.Strings.Camera.step1.first
        subtitleStep.text = R.Strings.Camera.step1.last
        closeBtnObverse.isHidden = true
        obversePhoto.image = nil
        titleObverse.isHidden = false
        obversePhoto.layer.sublayers?.last?.removeFromSuperlayer()
    }
    
    func clearReversePhoto() {
        if obversePhoto.image != nil {
            titleStep.text = R.Strings.Camera.step2.first
            subtitleStep.text = R.Strings.Camera.step2.last
        }
        cameraBtn.isEnabled = true
        closeBtnReverse.isHidden = true
        reversePhoto.image = nil
        titleReverse.isHidden = false
        reversePhoto.layer.sublayers?.last?.removeFromSuperlayer()
    }
    
    func failure() {
        containerAccesCamera.isHidden = false
        cameraBtn.isEnabled = true
        cameraLayerView.isHidden = false
        focusView.isHidden = true
        titleStep.isHidden = true
        subtitleStep.isHidden = true
        flashBtn.isEnabled = false
    }
}




