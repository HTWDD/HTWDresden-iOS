//
//  SettingsViewController.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 09.08.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit
import Firebase
import MessageUI
import SafariServices

class SettingsViewController: UITableViewController, HasSideBarItem {
    
    // MARK: - Outlets
    @IBOutlet weak var analyticsSwitch: UISwitch!
    @IBOutlet weak var crashlyticsSwitch: UISwitch!
    @IBOutlet weak var lblCurrentStudyGroups: BadgeLabel!
    @IBOutlet weak var lblCurrentAccount: BadgeLabel!
    
    // MARK: - Properties
    weak var context: AppContext?
    weak var delegate: SettingsCoordinatorRoutingDelegate?
    private lazy var sections: [Section] = {
        return [Section(header: "HTW Dresden", subHeader: "Account- und Studiengruppendaten"), Section(header: "Google", subHeader: "Analytics und Crashlytics"), Section(header: "Wir sind Open Source", subHeader: "Mehr auf Github"), Section(header: "Kontakt", subHeader: "Schreib uns."), Section(header: "Zurücksetzen", subHeader: "Alle Daten löschen")]
    }()
    
    private lazy var footerView: UIView = {
        let h: CGFloat = 100
        
        let love = NSAttributedString(string: Loca.Settings.credits,
                                      attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .medium),
                                                   .foregroundColor: UIColor.htw.grey])
        let version = NSAttributedString(string: String(format: "\n%@ (%@)", Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String, Bundle.main.infoDictionary!["CFBundleVersion"] as! String),
                                         attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .medium),
                                                      .foregroundColor: UIColor.htw.grey])
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        
        let text = NSMutableAttributedString()
        text.append(love)
        text.append(version)
        text.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, text.length))
        
        let loveLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.width, height: h))
        loveLabel.attributedText = text
        loveLabel.numberOfLines = 2
        loveLabel.textAlignment = .center
        loveLabel.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin, .flexibleTopMargin, .flexibleWidth, .flexibleHeight]
        
        return loveLabel
    }()
    
    // MARK: - Section
    private struct Section {
        let header: String
        let subHeader: String
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsSwitch.setOn(UserDefaults.standard.analytics, animated: false)
        crashlyticsSwitch.setOn(UserDefaults.standard.crashlytics, animated: false)
        crashlyticsSwitch.isEnabled = UserDefaults.standard.analytics
        currentStudyGroup()
        currentLoginAccount()
    }
}


// MARK: - Setup
extension SettingsViewController {
    
    private func setup() {
        
        tableView.apply {
            $0.backgroundColor  = UIColor.htw.veryLightGrey
            $0.tableFooterView  = footerView
            $0.separatorColor   = UIColor.htw.lightGrey
        }
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .automatic
        }
        
        title = R.string.localizable.settingsTitle()
        
        analyticsSwitch.addTarget(self, action: #selector(onSwitchChanged(_:)), for: .valueChanged)
        crashlyticsSwitch.addTarget(self, action: #selector(onSwitchChanged(_:)), for: .valueChanged)
        
        if !UserDefaults.standard.analytics {
            crashlyticsSwitch.apply {
                $0.setOn(false, animated: false)
                $0.isEnabled = false
            }
            UserDefaults.standard.crashlytics = false
            Analytics.setAnalyticsCollectionEnabled(false)
        }
        
        lblCurrentStudyGroups.apply {
            $0.backgroundColor  = UIColor.htw.mediumOrange
            $0.textColor        = .white
        }
        
        lblCurrentAccount.apply {
            $0.backgroundColor  = UIColor.htw.lightBlueMaterial
            $0.textColor        = .white
        }
    }
    
    @objc private func onSwitchChanged(_ sender: UISwitch) {
        switch sender {
        case analyticsSwitch:
            crashlyticsSwitch.isEnabled = sender.isOn
            UserDefaults.standard.analytics = sender.isOn
            Analytics.setAnalyticsCollectionEnabled(sender.isOn)
            if !sender.isOn {
                crashlyticsSwitch.setOn(false, animated: true)
            }
        case crashlyticsSwitch:
            UserDefaults.standard.crashlytics = sender.isOn
        default:
            break
        }
    }
    
    private func currentStudyGroup() {
        let studyToken = KeychainService.shared.readStudyToken()
        if let year = studyToken.year, let major = studyToken.major, let group = studyToken.group {
            lblCurrentStudyGroups.isHidden = false
            lblCurrentStudyGroups.text = "\(year) | \(major) | \(group)"
        } else {
            lblCurrentStudyGroups.isHidden = true
        }
    }
    
    private func currentLoginAccount() {
        lblCurrentAccount.apply {
            $0.isHidden = KeychainService.shared.readLoginAccount()?.nilWhenEmpty == nil
            $0.text     = KeychainService.shared.readLoginAccount()
        }
    }
}

// MARK: - Tableview Datasource
extension SettingsViewController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return BlurredSectionHeader(frame: tableView.frame, header: sections[section].header, subHeader: sections[section].subHeader)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tableView.cellForRow(at: indexPath)?.reuseIdentifier {
        case "studyGroupCell":
            delegate?.showSelectStudyGroup { [weak self] in
                guard let self = self else { return }
                self.currentStudyGroup()
            }
        case "loginCell":
            delegate?.showLogin { [weak self] in
                guard let self = self else { return }
                self.currentLoginAccount()
            }
        case "githubCell": delegate?.showGithub()
        case "emailCell": delegate?.showMail()
        case "impressumCell": delegate?.showImpressum()
        case "trashCell": delegate?.resetData()
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Mail
extension SettingsViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

