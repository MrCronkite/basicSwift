

import UIKit
import AVFoundation
import GoogleMobileAds
import Moya

protocol CameraViewProtocol: AnyObject {
    func clearObversePhoto()
    func clearReversePhoto()
    func collectSidesCoin(image: UIImage)
    func isFlash(_ isValueFlash: Bool)
    func setupBanner(ad: GADBannerView)
    
    func accessCamera()
    func failure()
}

protocol CameraPresenter: AnyObject {
    var images: [UIImage] { get set }
    var withFlash: Bool { get set }
    var captureSession: AVCaptureSession { get }
    var videoPreviewLayer: AVCaptureVideoPreviewLayer { get set }
    var isRecogntion: Bool { get set }
    var category: Int { get set }
    var reference: Int { get set }
    var isAccesCamera: Bool { get set }
    
    init(view: CameraViewProtocol, router: RouterProtocol, session: AVCaptureSession, googleAd: GoogleAdMobService, storage: UserSettings)
    
    func goToRoot()
    func takePhoto()
    func openPhotoLibrary()
    func clearObversePhoto()
    func clearReversePhoto()
    func processAndCollectImages(_ image: UIImage)
    func isFlash()
    func turnOfLight()
    func requestCameraAccess()
    func startCaptureSession()
    func setupCamera()
    func loadBanner()
    func openSettings()
}

final class CameraPresenterImpl: NSObject, CameraPresenter {
    weak var view: CameraViewProtocol?
    var router: RouterProtocol?
    var images: [UIImage] = []
    var withFlash: Bool = false
    var captureSession: AVCaptureSession
    var googleAd: GoogleAdMobService?
    let capturePhotoOutput = AVCapturePhotoOutput()
    var videoPreviewLayer = AVCaptureVideoPreviewLayer()
    var isRecogntion: Bool = true
    var storage: UserSettings?
    var category: Int = 0
    var reference: Int = 0
    var isAccesCamera: Bool = false
    
    required init(view: CameraViewProtocol,
                  router: RouterProtocol,
                  session: AVCaptureSession,
                  googleAd: GoogleAdMobService,
                  storage: UserSettings) {
        self.view = view
        self.router = router
        self.captureSession = session
        self.googleAd = googleAd
        self.storage = storage
    }
    
    func takePhoto() {
        let settings = AVCapturePhotoSettings()
        if withFlash {
            settings.flashMode = .on
        } else {
            settings.flashMode = .off
        }
        self.capturePhotoOutput.capturePhoto(with: settings,
                                             delegate: self)
    }
    
    func loadBanner() {
        if !(storage?.premium(forKey: .keyPremium) ?? false) {
            guard let googleAd = googleAd else { return }
            view?.setupBanner(ad: googleAd.loadBaner())
        }
    }
    
    func setupCamera() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer.videoGravity = .resizeAspectFill
            videoPreviewLayer.zPosition = -1
            captureSession.addOutput(self.capturePhotoOutput)
        } catch {
        }
    }
    
    func isFlash() {
        self.withFlash.toggle()
        view?.isFlash(withFlash)
    }
    
    func processAndCollectImages(_ image: UIImage) {
        guard let croppedImage = image.cropToCenter() else { return }
        images.append(croppedImage)
        view?.collectSidesCoin(image: croppedImage)
        
        if self.images.count == 2 {
            if self.isRecogntion {
                if Activity.checkInthernet(view: view as! CameraViewController) {
                    router?.goToRecognition(images: self.images, category: self.category)
                    clearObversePhoto()
                    clearReversePhoto()
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.router?.popToRoot()
                    }
                }
            } else {
                self.router?.goToRetake(images: self.images,
                                        category: self.category,
                                        reference: self.reference)
                clearObversePhoto()
                clearReversePhoto()
            }
        }
    }
    
    func startCaptureSession() {
        if !captureSession.isRunning {
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                self.captureSession.startRunning()
            }
        }
    }
    
    func openPhotoLibrary() {
        DispatchQueue.main.async {
            self.router?.openPhotoLibrary()
            AnaliticsService.shared.logEvent(name: Events.open_photo_galery)
        }
    }
    
    func clearObversePhoto() {
        images.removeLast()
        view?.clearObversePhoto()
    }
    
    func clearReversePhoto() {
        images.removeLast()
        view?.clearReversePhoto()
    }
    
    func requestCameraAccess() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            guard let self = self else { return }
            if granted {
                DispatchQueue.main.async {
                    self.view?.accessCamera()
                    self.isAccesCamera = true
                    AnaliticsService.shared.logEvent(name: Events.camera_view_allow)
                }
            } else {
                DispatchQueue.main.async {
                    self.view?.failure()
                    AnaliticsService.shared.logEvent(name: Events.camera_view_disallow)
                }
            }
        }
    }
    
    func openSettings() {
        Activity.showSettingsApp { result in
            if result == "settings" {
                if let bundleIdentifier = Bundle.main.bundleIdentifier, let appSettings = URL(string: UIApplication.openSettingsURLString + bundleIdentifier) {
                    if UIApplication.shared.canOpenURL(appSettings) {
                        UIApplication.shared.open(appSettings)
                    }
                }
            }
        }
    }
    
    func turnOfLight() {
        let vc = PhotoTipsViewController()
        vc.modalPresentationStyle = .fullScreen
        (view as! CameraViewController).present(vc, animated: true)
    }
    
    func goToRoot() {
        router?.popToView(isAnimate: true)
        AnaliticsService.shared.logEvent(name: Events.close_camera_view)
    }
}

extension CameraPresenterImpl: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(),
           let capturedImage = UIImage(data: imageData) {
            self.processAndCollectImages(capturedImage)
            AnaliticsService.shared.logEvent(name: Events.photo_taken_on_camera)
        }
    }
}


