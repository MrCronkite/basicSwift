

import UIKit
import MultiSlider

final class FilterViewController: UIViewController {
    
    var presenter: FilterPresenter?
    
    private let slider = MultiSlider()
    private var allCoinsView: AllCoinsViewProtocol?
    private var costIsLowToHight: Bool?
    private var material: String?
    private var isSaveButtonActive = false
    private var isResetButtonActive = false
    private let currentYear = Calendar.current.component(.year, from: Date())
    private var sliderMax: CGFloat!
    private var minYear: String = "1790"
    
    @IBOutlet weak private var containerSlider: UIView!
    @IBOutlet weak private var titleView: UILabel!
    @IBOutlet weak private var closeButton: UIButton!
    @IBOutlet weak private var titleCost: UILabel!
    @IBOutlet weak private var priceLowBtn: UIButton!
    @IBOutlet weak private var priceHightBtn: UIButton!
    @IBOutlet weak private var titleDate: UILabel!
    @IBOutlet weak private var minLable: UILabel!
    @IBOutlet weak private var maxLable: UILabel!
    @IBOutlet weak private var titleMaterial: UILabel!
    @IBOutlet weak private var collectionMaterial: UICollectionView!
    @IBOutlet weak private var ressetBtn: UIButton!
    @IBOutlet weak private var saveBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        setupView()
        localize()
    }
    
    override func viewWillLayoutSubviews() {
        slider.frame = CGRect(x: containerSlider.bounds.minX,
                              y: containerSlider.bounds.minY,
                              width: containerSlider.bounds.width,
                              height: containerSlider.bounds.height)
        
        slider.tintColor = Asset.Color.orange.color
        slider.outerTrackColor = Asset.Color.natiivGray.color
    }
    
    @IBAction func closeFilter(_ sender: Any) {
        presenter?.closeView()
    }
    
    @IBAction func resset(_ sender: Any) {
        if isResetButtonActive {
            (sender as! UIButton).addTapEffect()
            presenter?.filterSettings = nil
            material = nil
            costIsLowToHight = nil
            collectionMaterial.reloadData()
            slider.value = [1, sliderMax]
            minLable.text = minYear
            maxLable.text = "\(currentYear)"
            setupButton()
            inactivResetBtn()
        }
    }
    
    @IBAction func save(_ sender: Any) {
        (sender as! UIButton).addTapEffect()
        if isSaveButtonActive && isResetButtonActive {
            let data: [String] = [minLable.text!, maxLable.text!]
            presenter?.saveFilterSettings(settings: Filter(costIsLowToHight: costIsLowToHight,
                                                           data: data,
                                                           material: material))
            Activity.showAlert(title: "home_done".localized)
            saveBtn.backgroundColor =  Asset.Color.orange.color
            saveBtn.tintColor = .white
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.presenter?.closeView()
            }
        } else {
            presenter?.filterSettings = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.presenter?.closeView()
            }
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        priceHightBtn.backgroundColor = .white
        priceLowBtn.backgroundColor = .white
        priceLowBtn.tintColor = Asset.Color.orange.color
        priceHightBtn.tintColor = Asset.Color.orange.color
        sender.addTapEffect()
        sender.tintColor = .white
        sender.backgroundColor = Asset.Color.orange.color
        
        switch sender.titleLabel?.text {
        case "filt_low_to".localized:
            if costIsLowToHight == true {
                setupButton()
                costIsLowToHight = nil
            } else {
                costIsLowToHight = true
                activSaveBtn()
            }
        case "high_to_low".localized:
            if costIsLowToHight == false {
                setupButton()
                costIsLowToHight = nil
            } else {
                costIsLowToHight = false
                activSaveBtn()
            }
        default:
            return
        }
    }
    
    @objc private func sliderChanged(_ slider: MultiSlider) {
        switch slider.draggedThumbIndex {
        case 0: minLable.text = String(Int(slider.value.first! + 1789))
        case 1: maxLable.text = String(Int(slider.value.last! + 1790))
        default: break
        }
        
        if minLable.text == minYear && maxLable.text == "\(currentYear)" {
            if material == nil && costIsLowToHight == nil {
                inactivResetBtn()
            }
        } else {
            activSaveBtn()
        }
    }
}

private extension FilterViewController {
    func setupView() {
        view.backgroundColor = Asset.Color.lightGray.color
        view.layer.cornerRadius = 10
        closeButton.setImage(Asset.Assets.closeMiniGray.image, for: .normal)
        
        ressetBtn.layer.cornerRadius = 25
        ressetBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        saveBtn.layer.cornerRadius = 25
        saveBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        priceLowBtn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        priceHightBtn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: collectionMaterial.frame.width / 2 - 20, height: 24)
        layout.minimumLineSpacing = 15
        layout.scrollDirection = .vertical
        
        collectionMaterial.backgroundColor = .clear
        collectionMaterial.collectionViewLayout = layout
        collectionMaterial.dataSource = self
        collectionMaterial.delegate = self
        collectionMaterial.register(MaterialViewCell.self, forCellWithReuseIdentifier: "\(MaterialViewCell.self)")
        
        minLable.text = minYear
        maxLable.text = "\(currentYear)"
        sliderMax = CGFloat(currentYear - 1790)
        slider.thumbTintColor = Asset.Color.orange.color
        slider.trackWidth = 4
        slider.showsThumbImageShadow = false
        slider.minimumValue = 1
        slider.maximumValue = sliderMax
        containerSlider.addSubview(slider)
        slider.isVertical = false
        slider.value = [1, sliderMax]
        slider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
        
        if let settings = presenter?.filterSettings {
            activResetBtn()
            minLable.text = settings.data.first ?? "0"
            maxLable.text = settings.data.last ?? "0"
            let minValue = CGFloat(Float(settings.data.first!)! - 1789)
            let maxValue = CGFloat(Float(settings.data.last!)! - 1790)
            slider.value = [minValue, maxValue]
            
            if let cost = settings.costIsLowToHight {
                switch cost {
                case true:
                    priceLowBtn.tintColor = .white
                    priceLowBtn.backgroundColor = Asset.Color.orange.color
                case false:
                    priceHightBtn.tintColor = .white
                    priceHightBtn.backgroundColor = Asset.Color.orange.color
                }
            }
            
            if let material = settings.material {
                let index = R.Strings.Home.material.firstIndex(of: material)
                let firstIndexPath = IndexPath(item: index!, section: 0)
                collectionMaterial.selectItem(at: firstIndexPath, animated: false, scrollPosition: .top)
                collectionView(collectionMaterial, didSelectItemAt: firstIndexPath)
            }
        }
    }
    
    func localize() {
        titleView.text = "home_filter".localized
        titleCost.text = "home_cost".localized
        titleDate.text = "filt_data".localized
        titleMaterial.text = "filt_mater".localized
        priceLowBtn.setTitle("filt_low_to".localized, for: .normal)
        priceHightBtn.setTitle("high_to_low".localized, for: .normal)
        closeButton.setTitle("", for: .normal)
        ressetBtn.setTitle("resset_all".localized, for: .normal)
        saveBtn.setTitle("save_btn".localized, for: .normal)
    }
    
    func setupButton() {
        ressetBtn.tintColor = Asset.Color.orange.color
        ressetBtn.backgroundColor = Asset.Color.nativ.color
        saveBtn.backgroundColor = Asset.Color.orange.color
        saveBtn.tintColor = .white
        priceLowBtn.layer.cornerRadius = 16
        priceLowBtn.layer.borderWidth = 1
        priceLowBtn.layer.borderColor = Asset.Color.orange.color.cgColor
        priceLowBtn.tintColor = Asset.Color.orange.color
        priceLowBtn.backgroundColor = .white
        priceHightBtn.layer.cornerRadius = 16
        priceHightBtn.layer.borderWidth = 1
        priceHightBtn.layer.borderColor = Asset.Color.orange.color.cgColor
        priceHightBtn.tintColor = Asset.Color.orange.color
        priceHightBtn.backgroundColor = .white
        isSaveButtonActive = true
        isResetButtonActive = false
    }
    
    func activSaveBtn() {
        saveBtn.tintColor = .white
        saveBtn.backgroundColor = Asset.Color.orange.color
        activResetBtn()
    }
    
    func activResetBtn() {
        ressetBtn.tintColor = .white
        ressetBtn.backgroundColor = Asset.Color.orange.color
        isResetButtonActive = true
    }
    
    func inactivResetBtn() {
        isResetButtonActive = false
        ressetBtn.tintColor = Asset.Color.orange.color
        ressetBtn.backgroundColor = Asset.Color.nativ.color
    }
}

extension FilterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        R.Strings.Home.material.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MaterialViewCell.self)", for: indexPath) as? MaterialViewCell else { return UICollectionViewCell() }
        cell.titleNameMaterial.text = R.Strings.Home.material[indexPath.row]
        return cell
    }
}

extension FilterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        material = R.Strings.Home.material[indexPath.row]
        activSaveBtn()
    }
}

extension FilterViewController: FilterViewProtocol {
}

