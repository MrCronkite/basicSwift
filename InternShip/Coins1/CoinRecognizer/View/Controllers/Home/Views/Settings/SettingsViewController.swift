

import UIKit
import MessageUI

final class SettingsViewController: UIViewController {
    
    var presenter: SettingsPresenter?
    
    @IBOutlet weak private var tableViewSecurity: UITableView!
    @IBOutlet weak private var tableViewFeedback: UITableView!
    @IBOutlet weak private var tableViewSupport: UITableView!
    @IBOutlet weak private var navBar: NavbarView!
    @IBOutlet weak private var lableSupport: UILabel!
    @IBOutlet weak private var lableFeedback: UILabel!
    @IBOutlet weak private var lableSecurity: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        localize()
    }
}

private extension SettingsViewController {
  func setupView() {
      tabBarController?.tabBar.isHidden = true
      view.backgroundColor = .white
      navBar.delegate = self
      
      tableViewSupport.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
      tableViewSupport.isScrollEnabled = false
      tableViewSupport.dataSource = self
      tableViewSupport.delegate = self
      tableViewSupport.backgroundColor = .clear
      tableViewSupport.rowHeight = UITableView.noIntrinsicMetric
      tableViewSupport.register(SettingViewCell.self, forCellReuseIdentifier: "\(SettingViewCell.self)")
      
      tableViewFeedback.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
      tableViewFeedback.isScrollEnabled = false
      tableViewFeedback.dataSource = self
      tableViewFeedback.delegate = self
      tableViewFeedback.backgroundColor = .clear
      tableViewFeedback.rowHeight = UITableView.noIntrinsicMetric
      tableViewFeedback.register(SettingViewCell.self, forCellReuseIdentifier: "\(SettingViewCell.self)")
      
      tableViewSecurity.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
      tableViewSecurity.isScrollEnabled = false
      tableViewSecurity.dataSource = self
      tableViewSecurity.delegate = self
      tableViewSecurity.backgroundColor = .clear
      tableViewSecurity.rowHeight = UITableView.noIntrinsicMetric
      tableViewSecurity.register(SettingViewCell.self, forCellReuseIdentifier: "\(SettingViewCell.self)")
    }
    
    func localize() {
        navBar.setupStyleNavBar(title: "settings_alert".localized, style: .back)
        lableSupport.text = "stg_support".localized
        lableFeedback.text = "stg_feedback".localized
        lableSecurity.text = "stg_security".localized
    }
}

extension SettingsViewController: NavBarViewDelegate {
    func goBack() {
        presenter?.popToRoot()
    }
}

extension SettingsViewController: SettingsViewProtocol {
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case tableViewSupport:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(SettingViewCell.self)", for: indexPath) as? SettingViewCell else { return UITableViewCell() }
            cell.lableCell.text = R.Strings.Settings.support[indexPath.row]
            cell.iconCell.image = R.Images.Settings.support[indexPath.row]
            cell.selectionStyle = .none
            return cell
        case tableViewFeedback:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(SettingViewCell.self)", for: indexPath) as? SettingViewCell else { return UITableViewCell() }
            cell.lableCell.text = R.Strings.Settings.feedback[indexPath.row]
            cell.iconCell.image = R.Images.Settings.feedback[indexPath.row]
            cell.selectionStyle = .none
            return cell
        case tableViewSecurity:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(SettingViewCell.self)", for: indexPath) as? SettingViewCell else { return UITableViewCell() }
            cell.lableCell.text = R.Strings.Settings.security[indexPath.row]
            cell.iconCell.image = R.Images.Settings.security[indexPath.row]
            cell.selectionStyle = .none
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case tableViewSupport:
            if let cell = tableView.cellForRow(at: indexPath) as? SettingViewCell {
                cell.tapEffectReverse()
                indexPath.row == 0 ? self.presenter?.contactUs() : self.presenter?.restore()
            }
        case tableViewFeedback:
            if let cell = tableView.cellForRow(at: indexPath) as? SettingViewCell {
                cell.tapEffectReverse()
                indexPath.row == 0 ? self.presenter?.rateApp() : self.presenter?.shareTheApp()
            }
        case tableViewSecurity:
            if let cell = tableView.cellForRow(at: indexPath) as? SettingViewCell {
                cell.tapEffectReverse()
                indexPath.row == 0 ? self.presenter?.privacyPolicy() : self.presenter?.termOfUse()
            }
        default:
            break
        }
    }
}
