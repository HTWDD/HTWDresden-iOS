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
    @IBOutlet weak var crashlyticsSwitch: UISwitch!
    @IBOutlet weak var lblCurrentStudyGroups: BadgeLabel!
    @IBOutlet weak var lblCurrentAccount: BadgeLabel!
    @IBOutlet weak var lblStudyGroup: UILabel!
    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var lblCrashlytics: UILabel!
    @IBOutlet weak var lblGithub: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblImpressum: UILabel!
    @IBOutlet weak var lblDelete: UILabel!
    @IBOutlet weak var lblPrivacy: UILabel!
    
    // MARK: - Cells
    @IBOutlet weak var studyGroupCell: UITableViewCell!
    @IBOutlet weak var loginCell: UITableViewCell!
    @IBOutlet weak var crashlyticsCell: UITableViewCell!
    @IBOutlet weak var githubCell: UITableViewCell!
    @IBOutlet weak var emailCell: UITableViewCell!
    @IBOutlet weak var imprintCell: UITableViewCell!
    @IBOutlet weak var trashCell: UITableViewCell!
    @IBOutlet weak var privacyCell: UITableViewCell!
    
    // MARK: - Header Cells
    @IBOutlet weak var lblAccountHeader: UILabel!
    @IBOutlet weak var lblAccountSubheader: UILabel!
    @IBOutlet weak var lblGoogleHeader: UILabel!
    @IBOutlet weak var lblGoogleSubheader: UILabel!
    @IBOutlet weak var lblGithubHeader: UILabel!
    @IBOutlet weak var lblGithubSubheader: UILabel!
    @IBOutlet weak var lblContactHeader: UILabel!
    @IBOutlet weak var lblContactSubheader: UILabel!
    @IBOutlet weak var lblResetHeader: UILabel!
    @IBOutlet weak var lblResetSubheader: UILabel!
    
    
    // MARK: - Properties
    weak var delegate: SettingsCoordinatorRoutingDelegate?
    
    private lazy var footerView: UIView = {
        return UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.width, height: 100)).also {
            $0.text             = R.string.localizable.settingsCredits(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String, Bundle.main.infoDictionary!["CFBundleVersion"] as! String)
            $0.textColor        = UIColor.htw.Label.secondary
            $0.font             = UIFont.htw.Labels.secondary
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
        crashlyticsSwitch.setOn(UserDefaults.standard.crashlytics, animated: false)
        currentStudyGroup()
        currentLoginAccount()
    }
}


// MARK: - Setup
extension SettingsViewController {
    
    private func setup() {

        studyGroupCell.backgroundColor  = UIColor.htw.cellBackground
        loginCell.backgroundColor       = UIColor.htw.cellBackground
        crashlyticsCell.backgroundColor = UIColor.htw.cellBackground
        githubCell.backgroundColor      = UIColor.htw.cellBackground
        emailCell.backgroundColor       = UIColor.htw.cellBackground
        imprintCell.backgroundColor     = UIColor.htw.cellBackground
        trashCell.backgroundColor       = UIColor.htw.cellBackground
        privacyCell.backgroundColor     = UIColor.htw.cellBackground
        
        tableView.apply {
            $0.backgroundColor  = UIColor.htw.veryLightGrey
            $0.tableFooterView  = footerView
        }
        
        title = R.string.localizable.settingsTitle()
        
        crashlyticsSwitch.addTarget(self, action: #selector(onSwitchChanged(_:)), for: .valueChanged)
        
        lblCurrentStudyGroups.apply {
            $0.backgroundColor  = UIColor.htw.Material.orange
            $0.textColor        = .white
        }
        lblCurrentAccount.apply {
            $0.backgroundColor  = UIColor.htw.Material.blue
            $0.textColor        = .white
        }
        lblStudyGroup.apply {
            $0.text         = R.string.localizable.settingsItemsSetScheduleTitle()
            $0.textColor    = UIColor.htw.Label.primary
        }
        lblLogin.apply {
            $0.text         = R.string.localizable.settingsItemsSetGradesTitle()
            $0.textColor    = UIColor.htw.Label.primary
        }
        lblCrashlytics.textColor    = UIColor.htw.Label.primary
        lblGithub.apply {
            $0.text         = R.string.localizable.settingsItemsGithub()
            $0.textColor    = UIColor.htw.Label.primary
        }
        lblEmail.apply {
            $0.text         = R.string.localizable.settingsItemsMailTitle()
            $0.textColor    = UIColor.htw.Label.primary
        }
        lblImpressum.apply {
            $0.text         = R.string.localizable.settingsItemsLegalTitle()
            $0.textColor    = UIColor.htw.Label.primary
        }
        lblDelete.apply {
            $0.text         = R.string.localizable.settingsItemsDeleteAll()
            $0.textColor    = UIColor.htw.Label.primary
        }
        
        // Header Cells
        // Account
        lblAccountHeader.apply {
            $0.text         = R.string.localizable.settingsItemsAccountTitle()
            $0.textColor    = UIColor.htw.Label.primary
        }
        lblAccountSubheader.apply {
            $0.text         = R.string.localizable.settingsItemsAccountSubtitle()
            $0.textColor    = UIColor.htw.Label.secondary
        }
        // Google
        lblGoogleHeader.apply {
            $0.text         = R.string.localizable.settingsItemsGoogleTitle()
            $0.textColor    = UIColor.htw.Label.primary
        }
        lblGoogleSubheader.apply {
            $0.text         = R.string.localizable.settingsItemsGoogleSubtitle()
            $0.textColor    = UIColor.htw.Label.secondary
        }
        // Github
        lblGithubHeader.apply {
            $0.text         = R.string.localizable.settingsSectionsWeAreOpenSource()
            $0.textColor    = UIColor.htw.Label.primary
        }
        lblGithubSubheader.apply {
            $0.text         = R.string.localizable.settingsSectionsWeAreOpenSourceSubtitle()
            $0.textColor    = UIColor.htw.Label.secondary
        }
        // Contact
        lblContactHeader.apply {
            $0.text         = R.string.localizable.settingsSectionsContact()
            $0.textColor    = UIColor.htw.Label.primary
        }
        lblContactSubheader.apply {
            $0.text         = R.string.localizable.settingsSectionsContactSubtitle()
            $0.textColor    = UIColor.htw.Label.secondary
        }
        lblPrivacy.apply {
            $0.text         = R.string.localizable.settingsSetctionContactPrivacy()
            $0.textColor    = UIColor.htw.Label.primary
        }
        // Reset
        lblResetHeader.apply {
            $0.text         = R.string.localizable.settingsSectionsDeleteAll()
            $0.textColor    = UIColor.htw.Label.primary
        }
        lblResetSubheader.apply {
            $0.text         = R.string.localizable.settingsSectionsDeleteAllSubtitle()
            $0.textColor    = UIColor.htw.Label.secondary
        }
    }
    
    @objc private func onSwitchChanged(_ sender: UISwitch) {
        switch sender {
        case crashlyticsSwitch:
            UserDefaults.standard.crashlytics = sender.isOn
        default:
            break
        }
    }
    
    private func currentStudyGroup() {
        let studyToken = KeychainService.shared.readStudyToken()
        if let year = studyToken.year, let major = studyToken.major, let group = studyToken.group, let graduation = studyToken.graduation {
            lblCurrentStudyGroups.isHidden = false
            lblCurrentStudyGroups.text = "\(year) | \(major) | \(group) | \(graduation)"
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
        case "privacyCell": delegate?.showPrivacy()
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
