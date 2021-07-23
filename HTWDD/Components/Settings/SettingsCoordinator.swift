//
//  SettingsCoordinator.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 04.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import SafariServices
import MessageUI

protocol SettingsCoordinatorDelegate: AnyObject {
    func deleteAllData()
}

// MARK: - Settings Coordinator Delegate
protocol SettingsCoordinatorRoutingDelegate: AnyObject {
    func showSelectStudyGroup(completion: @escaping () -> Void)
    func showLogin(completion: @escaping () -> Void)
    func showMail()
    func showImpressum()
    func showPrivacy()
    func showGithub()
    func resetData()
    func showResetElectiveDialog()
}

class SettingsCoordinator: Coordinator {

    var rootViewController: UIViewController { return UIViewController() }
	
    private lazy var settingsViewController: SettingsViewController = {
        return R.storyboard.settings.settingsViewController()!.also {
            $0.delegate = self
        }
    }()
    
	var childCoordinators = [Coordinator]()
	
    weak var delegate: SettingsCoordinatorDelegate?
    
	let context: AppContext
    init(context: AppContext, delegate: SettingsCoordinatorDelegate) {
		self.context = context
        self.delegate = delegate
	}
    
    func start() -> SettingsViewController {
        return settingsViewController
    }
}


// MARK: - Routing Delegate
extension SettingsCoordinator: SettingsCoordinatorRoutingDelegate {
    
    func showSelectStudyGroup(completion: @escaping () -> Void) {
        let viewController = R.storyboard.onboarding.studyGroupViewController()!.also {
            $0.context                  = context
            $0.modalPresentationStyle   = .overCurrentContext
            $0.modalTransitionStyle     = .crossDissolve
            $0.delegateClosure          = completion
        }
        settingsViewController.present(viewController, animated: true, completion: nil)
    }
    
    func showLogin(completion: @escaping () -> Void) {
        let viewController = R.storyboard.onboarding.loginViewController()!.also {
            $0.context                  = context
            $0.modalPresentationStyle   = .overCurrentContext
            $0.modalTransitionStyle     = .crossDissolve
            $0.delegateClosure          = completion
        }
        settingsViewController.present(viewController, animated: true, completion: nil)
    }
    
    func showMail() {
        if MFMailComposeViewController.canSendMail() {
            let mailBody = String(format: "\n\nHTW iOS App\nVersion: %@ (%@)\nDevice: %@ (%@ %@)",
                                  Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String,
                                  Bundle.main.infoDictionary!["CFBundleVersion"] as! String,
                                  UIDevice.current.modelName,
                                  UIDevice.current.systemName,
                                  UIDevice.current.systemVersion)
            
            let composeViewController = MFMailComposeViewController().also {
                $0.mailComposeDelegate      = settingsViewController
                $0.navigationBar.tintColor  = .white
                $0.view.backgroundColor     = UIColor.htw.veryLightGrey
                $0.setToRecipients([R.string.localizable.settingsItemsMailMail()])
                $0.setSubject("[iOS] HTW App Feedback")
                $0.setMessageBody(mailBody, isHTML: false)
            }
            settingsViewController.navigationController?.present(composeViewController, animated: true, completion: nil)
        } else {
            UIPasteboard.general.string = R.string.localizable.settingsItemsMailMail()
            settingsViewController.present(UIAlertController(title: R.string.localizable.settingsItemsMailFallbackTitle(), message: R.string.localizable.settingsItemsMailFallbackMessage(), preferredStyle: .alert).also {
                $0.addAction(UIAlertAction(title: R.string.localizable.ok(), style: .default, handler: nil))
            }, animated: true, completion: nil)
        }
    }
    
    func showImpressum() {
        settingsViewController.navigationController?.pushViewController(R.storyboard.settings.wkWebViewController()!.also {
            $0.show(title: R.string.localizable.settingsItemsLegalTitle(), filename: "HTW-Impressum.html")
        }, animated: true)
    }
    
    func showPrivacy() {
        settingsViewController.navigationController?.pushViewController(R.storyboard.settings.wkWebViewController()!.also {
            $0.show(title: R.string.localizable.settingsSetctionContactPrivacy(), filename: "HTW-Datenschutz.html")
        }, animated: true)
    }
    
    func showGithub() {
        if let url = URL(string: "https://github.com/HTWDD/HTWDresden-iOS") {
            settingsViewController.present(SFSafariViewController(url: url).also {
                $0.preferredBarTintColor = UIColor.htw.blue
            }, animated: true, completion: nil)
        }
    }
    
    func resetData() {
        let alert = UIAlertController(title: R.string.localizable.attention(), message: R.string.localizable.settingsItemsDeleteAllConfirmationText(), preferredStyle: .alert).also {
            $0.addAction(UIAlertAction(title: R.string.localizable.yes(), style: .default, handler: { [weak self] _ in
                guard let self = self else { return }
                self.delegate?.deleteAllData()
            }))
            $0.addAction(UIAlertAction(title: R.string.localizable.cancel(), style: .cancel, handler: nil))
        }
        settingsViewController.present(alert, animated: true, completion: nil)
    }
    
    func showResetElectiveDialog() {
        let alert = UIAlertController(title: R.string.localizable.settingsResetElectiveLessonsAlertTitle(), message: R.string.localizable.settingsResetElectiveLessonsAlertMessage(), preferredStyle: .alert).also {
            $0.addAction(UIAlertAction(title: R.string.localizable.yes(), style: .default, handler: { [weak self] _ in
                self?.resetElectiveLessons()
            }))
            $0.addAction(UIAlertAction(title: R.string.localizable.cancel(), style: .cancel, handler: nil))
        }
        settingsViewController.present(alert, animated: true, completion: nil)
    }
    
    private func resetElectiveLessons() {
        let electiveLessonsIds = TimetableRealm.read()
            .filter({ !$0.id.hasPrefix(Lesson.customLessonPrefix) })
            .map { $0.id }
        
        TimetableRealm.delete(ids: electiveLessonsIds)
    }
}
