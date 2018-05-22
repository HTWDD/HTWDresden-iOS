//
//  SettingsMainVC.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 04.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import MessageUI

protocol SettingsMainVCDelegate: class {
    func deleteAllData()
    func triggerScheduleOnboarding(completion: @escaping (ScheduleService.Auth) -> Void)
    func triggerGradeOnboarding(completion: @escaping (GradeService.Auth) -> Void)
    func showLectureManager(auth: ScheduleService.Auth?)
    
	func showLicense(name: String)
	func showGitHub()
    func composeMail()
}

class SettingsMainVC: TableViewController {
	
    var scheduleAuth: ScheduleService.Auth? {
        didSet {
            self.configure()
        }
    }
    
    var gradesAuth: GradeService.Auth? {
        didSet {
            self.configure()
        }
    }
	
	private var settings: [(String?, [SettingsItem])] {
		return [
			(nil, [
				SettingsItem(title: Loca.Settings.items.setSchedule.title,
							 subtitle: self.scheduleAuth.map { auth in Loca.Settings.items.setSchedule.subtitle(auth.year, auth.major, auth.group) },
                             thumbnail: #imageLiteral(resourceName: "StudyGroup"),
							 action: self.showScheduleOnboarding()),
				SettingsItem(title: Loca.Settings.items.setGrades.title,
							 subtitle: self.gradesAuth.map { auth in Loca.Settings.items.setGrades.subtitle(auth.username) },
                             thumbnail: #imageLiteral(resourceName: "Credentials"),
							 action: self.showGradeOnboarding())
			]),
            /*
            (Loca.Schedule.title, [
                SettingsItem(title: Loca.Schedule.Settings.Hide.title,
                             thumbnail: #imageLiteral(resourceName: "ScheduleManager"),
                             action: self.showLectureManager())
            ]),*/
            (Loca.Settings.sections.weAreOpenSource, [
				SettingsItem(title: Loca.Settings.items.github,
                             thumbnail: #imageLiteral(resourceName: "GitHub"),
                             action: self.showGitHub())
			]),
            (Loca.Settings.sections.contact, [
                SettingsItem(title: Loca.Settings.items.mail.title,
                             thumbnail: #imageLiteral(resourceName: "Mail"),
                             action: self.composeMail()),
                SettingsItem(title: Loca.Settings.items.legal.title,
                             thumbnail: #imageLiteral(resourceName: "Impressum"),
                             action: self.showLicense(name: "HTW-Impressum.html"))
            ]),
            (Loca.Settings.sections.openSource, [
                SettingsItem(title: "RxSwift",
                             thumbnail: nil,
                             action: self.showLicense(name: "RxSwift-license.html")),
                SettingsItem(title: "Marshal",
                             thumbnail: nil,
                             action: self.showLicense(name: "Marshal-license.html")),
                SettingsItem(title: "KeychainAccess",
                             thumbnail: nil,
                             action: self.showLicense(name: "KeychainAccess-license.html"))
            ]),
			(Loca.Settings.sections.deleteAll, [
				SettingsItem(title: Loca.Settings.items.deleteAll,
                             thumbnail: #imageLiteral(resourceName: "Trash"),
							 action: self.showConfirmationAlert(title: Loca.attention,
																message: Loca.Settings.items.deleteAllConfirmationText,
																actionTitle: Loca.yes,
																action: { [weak self] in self?.delegate?.deleteAllData() })),
			])
		]
	}
    
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
    
    weak var delegate: SettingsMainVCDelegate?
    
    // MARK: - Init
    
    init() {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
	override func initialSetup() {
		super.initialSetup()
        
		self.title = Loca.Settings.title
		self.tabBarItem.image = #imageLiteral(resourceName: "Settings")
        
        self.configure()
	}
	
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .automatic
        }
        
        self.tableView.tableFooterView = self.footerView
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Private
    
    private func configure() {
        self.dataSource = GenericBasicTableViewDataSource(data: self.settings)
        self.dataSource?.tableView = self.tableView
        self.dataSource?.register(type: SettingsCell.self)
        self.dataSource?.invalidate()
    }
    
    private func showScheduleOnboarding() {
        self.delegate?.triggerScheduleOnboarding(completion: { [weak self] auth in
            self?.scheduleAuth = auth
        })
    }
    
    private func showGradeOnboarding() {
        self.delegate?.triggerGradeOnboarding(completion: { [weak self] auth in
            self?.gradesAuth = auth
        })
    }
    
    private func showLectureManager() {
        self.delegate?.showLectureManager(auth: self.scheduleAuth)
    }
	
	private func showLicense(name: String) {
		self.delegate?.showLicense(name: name)
	}
	
	private func showGitHub() {
		self.delegate?.showGitHub()
	}
	
    private func composeMail() {
        self.delegate?.composeMail()
    }
    
    private func showConfirmationAlert(title: String?, message: String?, actionTitle: String, action: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Loca.cancel, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { _ in action() }))
        self.present(alert, animated: true, completion: nil)
    }

}

// MARK: - UITableViewDelegate
extension SettingsMainVC {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let d = self.dataSource as? GenericBasicTableViewDataSource<SettingsItem> else { return }
        let item = d.data(at: indexPath)
        item.action()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SettingsMainVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
