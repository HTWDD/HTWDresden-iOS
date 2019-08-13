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
    @IBOutlet weak var lblStudyGroup: UILabel!
    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var lblGithub: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblImpressum: UILabel!
    @IBOutlet weak var lblDelete: UILabel!
    
    // MARK: - Properties
    weak var delegate: SettingsCoordinatorRoutingDelegate?
    private lazy var sections: [Section] = {
        return [Section(header: R.string.localizable.settingsItemsAccountTitle(), subHeader: R.string.localizable.settingsItemsAccountSubtitle()),
                Section(header: R.string.localizable.settingsItemsGoogleTitle(), subHeader: R.string.localizable.settingsItemsGoogleSubtitle()),
                Section(header: R.string.localizable.settingsSectionsWeAreOpenSource(), subHeader: R.string.localizable.settingsSectionsWeAreOpenSourceSubtitle()),
                Section(header: R.string.localizable.settingsSectionsContact(), subHeader: R.string.localizable.settingsSectionsContactSubtitle()),
                Section(header: R.string.localizable.settingsSectionsDeleteAll(), subHeader: R.string.localizable.settingsSectionsDeleteAllSubtitle())]
    }()
    
    private lazy var footerView: UIView = {
        return UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.width, height: 100)).also {
            $0.text             = R.string.localizable.settingsCredits(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String, Bundle.main.infoDictionary!["CFBundleVersion"] as! String)
            $0.textColor        = UIColor.htw.grey
            $0.font             = UIFont.from(style: .small)
            $0.numberOfLines    = 2
            $0.textAlignment    = .center
            $0.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin, .flexibleTopMargin, .flexibleWidth, .flexibleHeight]
        }
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
        
        lblStudyGroup.text  = R.string.localizable.settingsItemsSetScheduleTitle()
        lblLogin.text       = R.string.localizable.settingsItemsSetGradesTitle()
        lblGithub.text      = R.string.localizable.settingsItemsGithub()
        lblEmail.text       = R.string.localizable.settingsItemsMailTitle()
        lblImpressum.text   = R.string.localizable.settingsItemsLegalTitle()
        lblDelete.text      = R.string.localizable.settingsItemsDeleteAll()
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

