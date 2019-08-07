//
//  LoginViewController.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 06.08.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit
import Lottie
import RxSwift
import RxCocoa
import SwiftKeychainWrapper

class LoginViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var lblLoginHeader: UILabel!
    @IBOutlet weak var lblLoginDescription: UILabel!
    @IBOutlet weak var lblLoginInformation: UILabel!
    @IBOutlet weak var tfUserName: TextField!
    @IBOutlet weak var tfUserPassword: PasswordField!
    @IBOutlet weak var padLockAnimationView: AnimationView!
    @IBOutlet weak var topContraint: NSLayoutConstraint!
    @IBOutlet weak var bottomContraint: NSLayoutConstraint!
    @IBOutlet weak var btnLogin: UIButton!
    
    // MARK: - Properties
    weak var context: AppContext?
    weak var delegate: UIPageViewSwipeDelegate?
    private lazy var padLockAnimation: Animation? = {
       return Animation.named("PadlockGrey")
    }()
    
    private lazy var errorLoginAlert: UIAlertController = {
        return UIAlertController(title: R.string.localizable.gradesNoResultsTitle(), message: R.string.localizable.gradesNoResultsMessage(), preferredStyle: .alert).also { alert in
            alert.addAction(UIAlertAction(title: R.string.localizable.ok(), style: .default, handler: nil))
        }
    }()
    
    private struct State {
        var hasUserName: Bool = false
        var hasUserPassword: Bool = false
        var hasUserNameAndPassword: Bool {
            return hasUserName && hasUserPassword
        }
    }
    private let state = BehaviorRelay(value: State())
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        observe()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.padLockAnimationView.play()
        }
    }
    
    // MARK: - User Interaction
    @IBAction func onButtonTap(_ sender: UIButton) {
        view.endEditing(true)
        sender.setState(with: .inactive)
        if let authData = "s\(tfUserName.text?.nilWhenEmpty ?? String("")):\(tfUserPassword.text?.nilWhenEmpty ?? String(""))".data(using: .utf8) {
            context?.apiService.requestCourses(auth: authData.base64EncodedString(options: .lineLength64Characters))
                .asObservable()
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] result in
                    guard let self = self else { return }
                    KeychainService.shared[.authToken] = authData.base64EncodedString(options: .lineLength64Characters)
                    self.delegate?.next(animated: true)
                }, onError: { [weak self] in
                    guard let self = self else { return }
                    self.present(self.errorLoginAlert, animated: true, completion: nil)
                    sender.setState(with: .active)
                    Log.error($0)
                })
                .disposed(by: rx_disposeBag)
        }
    }
}

// MARK: - Setup
extension LoginViewController {
    
    private func setup() {
        lblLoginHeader.text         = R.string.localizable.onboardingLoginHeader()
        lblLoginDescription.text    = R.string.localizable.onboardingLoginDescription()
        lblLoginInformation.text    = R.string.localizable.onboardingLoginInformation()
        
        padLockAnimationView.apply {
            $0.animation    = padLockAnimation
            $0.contentMode  = .scaleAspectFill
            $0.loopMode     = .playOnce
        }
        
        tfUserName.apply {
            $0.placeholder      = R.string.localizable.onboardingUnixLoginSPlaceholder()
            $0.backgroundColor  = UIColor.htw.lightGrey
            $0.delegate         = self
        }
        
        tfUserPassword.apply {
            $0.placeholder      = R.string.localizable.onboardingUnixLoginPasswordPlaceholder()
            $0.backgroundColor  = UIColor.htw.lightGrey
            $0.delegate         = self
        }
        
        btnLogin.apply {
            $0.setTitle(R.string.localizable.letsgo(), for: .normal)
            $0.setState(with: .inactive)
            $0.makeDropShadow()
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(view.endEditing(_:))))
        keyboardObserve()
    }
    
    private func keyboardObserve() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            topContraint.constant       = -keyboardSize.height
            bottomContraint.constant    = -keyboardSize.height
            view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        topContraint.constant       = 0
        bottomContraint.constant    = 0
        view.layoutIfNeeded()
    }
    
    private func observe() {
        state.asObservable()
            .map({ $0.hasUserNameAndPassword })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] hasUserNameAndPassword in
                guard let self = self else { return }
                self.btnLogin.setState(with: hasUserNameAndPassword ? .active : .inactive)
            }, onError: { Log.error($0) })
            .disposed(by: rx_disposeBag)
    }
}

// MARK: - Textfield Delegate
extension LoginViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text else { return true }
        let newLength = textFieldText.count + string.count - range.length
        
        switch textField {
        case tfUserName:
            var mutableState = state.value
            mutableState.hasUserName = newLength >= 5
            state.accept(mutableState)
            return newLength <= 5
        
        case tfUserPassword:
            var mutableState = state.value
            mutableState.hasUserPassword = newLength >= 1
            state.accept(mutableState)
            return true
        
        default:
            return true
        }
    }
}
