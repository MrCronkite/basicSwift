

import UIKit
import StoreKit

final class SliderCardCoinViewController: UIViewController {
    
    var presenter: SliderPresenter?
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.setupSlides()
        setupView()
        rateApp()
        
        DispatchQueue.main.async {
            self.setupSlider()
        }
    }
    
    @IBAction func goToBack(_ sender: Any) {
        presenter?.popToView()
    }
}

private extension SliderCardCoinViewController {
    func setupView() {
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        closeButton.setTitle("", for: .normal)
        closeButton.setImage(Asset.Assets.back.image, for: .normal)
    }
    
    func setupSlider() {
        guard let slides = presenter?.slides else { return }
        let width: CGFloat = UIScreen.main.bounds.width
        let topSafeArea = view.safeAreaInsets.bottom
        scrollView.contentSize = CGSize(width: width * CGFloat(slides.count), height: scrollView.frame.size.height - topSafeArea)
        let tabHeight = tabBarController?.tabBar.bounds.height
        for (index, slide) in slides.enumerated() {
            addChild(slide)
            slide.view.frame = CGRect(x: CGFloat(index) * width,
                                      y: 0,
                                      width: width,
                                      height: scrollView.bounds.size.height - ((tabHeight ?? 40) / 2.5))
            scrollView.addSubview(slide.view)
            slide.didMove(toParent: self)
        }
       
        pageControl.numberOfPages = presenter?.coins.count ?? 0
        pageControl.currentPage = 0
        
        if presenter?.coins.count == 1 {
            pageControl.isHidden = true
        }
    }
    
    func rateApp() {
        if !(presenter?.images?.isEmpty ?? true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                guard let scene = self.view.window?.windowScene else {
                    return
                }
                
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }
}

extension SliderCardCoinViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = pageIndex
    }
}

extension SliderCardCoinViewController: SliderCoinView {

}

