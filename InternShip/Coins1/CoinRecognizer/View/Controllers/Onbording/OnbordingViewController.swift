

import UIKit

final class OnbordingViewController: UIViewController {
    
    private var pageViewController: UIPageViewController!
    private var currentIndex: Int = 0
    var router: RouterProtocol?
    var assembly: AssemblyBuilder?
    
    let continueButton: UIButton = {
        let view = UIButton()
        view.setTitle("ob_button".localized, for: .normal)
        view.backgroundColor = Asset.Color.orange.color
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        view.layer.cornerRadius = 26
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageViewController()
        setupView()
    }
    
    @objc func nextButtonTapped() {
        currentIndex += 1
        if currentIndex <= 3 {
            if let nextViewController = viewControllerAtIndex(currentIndex) {
                pageViewController.setViewControllers([nextViewController],
                                                      direction: .forward,
                                                      animated: true,
                                                      completion: nil)
            }
        } else {
            currentIndex = 3
        }
    }
}

extension OnbordingViewController {
    private func setupView() {
        view.backgroundColor = Asset.Color.dark.color
        view.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            continueButton.heightAnchor.constraint(equalToConstant: 54),
            continueButton.widthAnchor.constraint(equalToConstant: 311),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        continueButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    private func setupPageViewController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                  navigationOrientation: .horizontal,
                                                  options: nil)
        
        if let firstViewController = viewControllerAtIndex(0) {
            pageViewController.setViewControllers([firstViewController],
                                                  direction: .forward,
                                                  animated: true,
                                                  completion: nil)
        }
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
    }
}

extension OnbordingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndex
    }
    
    func viewControllerAtIndex(_ index: Int) -> UIViewController? {
        if index >= 0 && index < 3 {
            let contentViewController = ContainerViewController(subtitle: R.Strings.Onbording.strings[index], index: index)
            return contentViewController
        } else if index == 3 {
            let payWallVC = assembly?.createPayWallModule(router: router!) as? PayWallViewController
            payWallVC?.showButton = {
                UIView.animate(withDuration: 0.5) {
                    self.continueButton.backgroundColor = .clear
                    self.continueButton.isHidden = true
                }}
            return payWallVC
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = R.Strings.Onbording.strings.firstIndex(of: (viewController.view.subviews.first as? UILabel)?.text ?? "") {
            let previousIndex = (index - 1 + R.Strings.Onbording.strings.count) % R.Strings.Onbording.strings.count
            if previousIndex < 3 {
                return viewControllerAtIndex(previousIndex)
            }
        } else if currentIndex == 3 {
            return viewControllerAtIndex(2)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = R.Strings.Onbording.strings.firstIndex(of: (viewController.view.subviews.first as? UILabel)?.text ?? "") {
            let nextIndex = (index + 1) % R.Strings.Onbording.strings.count
            return viewControllerAtIndex(nextIndex)
        } else if currentIndex == 3 {
            return nil
        }
        return nil
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let viewController = pendingViewControllers.first, let index = R.Strings.Onbording.strings.firstIndex(of: (viewController.view.subviews.first as? UILabel)?.text ?? "") {
            
            currentIndex = index
            if index == 2 {
                UIView.animate(withDuration: 0.5) {
                    self.continueButton.backgroundColor = Asset.Color.orange.color
                    self.continueButton.isHidden = false
                }
            }
        }
    }
}

