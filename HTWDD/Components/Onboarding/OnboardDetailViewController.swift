//
//  OnboardDetailViewController.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 29.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit

class OnboardDetailViewController<Product>: ViewController, UITextFieldDelegate {

    var onFinish: ((Product?) -> Void)?

    struct Config {
        var title: String
        var description: String
        var contentViews: [UIView]
        var contentViewsStackViewAxis: UILayoutConstraintAxis
        var notNowText: String
        var continueButtonText: String
    }

    /// Set this config before calling super.initialSetup!
    var config: Config?

    private lazy var continueButton = ReactiveButton()

    // MARK: - Overwrite functions

    @objc func continueBoarding() {
        preconditionFailure("Overwrite this  method in your subclass!")
    }

    @objc func skipBoarding() {
        self.onFinish?(nil)
    }

    func shouldReplace(textField: UITextField, newString: String) -> Bool {
        return true
    }

    func shouldContinue() -> Bool {
        return false
    }
    
    func checkState() {
        self.continueButton.isEnabled = self.shouldContinue()
    }

    // MARK: - ViewController lifecycle

    override func initialSetup() {
        super.initialSetup()

        guard let config = self.config else {
            preconditionFailure("Tried to use OnboardDetailViewController without config. Abort!")
        }

        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        // --- Title Label ---

        let titleLabel = UILabel()
        titleLabel.text = config.title
        titleLabel.font = .systemFont(ofSize: 44, weight: .bold)
        titleLabel.textColor = UIColor.htw.textHeadline
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let titleContainer = UIView()
        titleContainer.translatesAutoresizingMaskIntoConstraints = false
        titleContainer.addSubview(titleLabel)
        self.view.addSubview(titleContainer)

        // --- Description Label ---

        let descriptionLabel = UILabel()
        descriptionLabel.text = config.description
        descriptionLabel.font = .systemFont(ofSize: 17, weight: .medium)
        descriptionLabel.textColor = UIColor.htw.textBody
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        // --- Text fields ---

        let configureTextField: (UIView) -> Void = {
            guard let textField = $0 as? UITextField else {
                return
            }
            textField.font = .systemFont(ofSize: 30, weight: .medium)
            textField.backgroundColor = UIColor.htw.veryLightGrey
            textField.textAlignment = .center
            textField.delegate = self
            textField.addTarget(self, action: #selector(self.inputChanges(textField:)), for: .editingChanged)
            textField.translatesAutoresizingMaskIntoConstraints = false
        }

        config.contentViews
            .forEach(configureTextField)

        let textFieldStackView = UIStackView(arrangedSubviews: config.contentViews)
        textFieldStackView.axis = config.contentViewsStackViewAxis
        textFieldStackView.distribution = .fillEqually
        textFieldStackView.spacing = 12
        textFieldStackView.translatesAutoresizingMaskIntoConstraints = false

        let centerStackView = UIStackView(arrangedSubviews: [
            descriptionLabel,
            textFieldStackView
            ])
        centerStackView.axis = .vertical
        centerStackView.distribution = .fill
        centerStackView.spacing = 40
        centerStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(centerStackView)

        // --- Continue Button ---

        self.continueButton.isEnabled = false
        self.continueButton.setTitle(config.continueButtonText, for: .normal)
        self.continueButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        self.continueButton.backgroundColor = UIColor.htw.blue
        self.continueButton.layer.cornerRadius = 12
        self.continueButton.translatesAutoresizingMaskIntoConstraints = false
        self.continueButton.rx
            .controlEvent(.touchUpInside)
            .subscribe({ [weak self] _ in self?.continueBoarding() })
            .disposed(by: self.rx_disposeBag)
        self.view.addSubview(self.continueButton)

        // --- Skip Button ---

        let skip = ReactiveButton()
        skip.setTitle(config.notNowText, for: .normal)
        skip.setTitleColor(UIColor.htw.blue, for: .normal)
        skip.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        skip.translatesAutoresizingMaskIntoConstraints = false
        skip.rx
            .controlEvent(.touchUpInside)
            .subscribe({ [weak self] _ in self?.skipBoarding() })
            .disposed(by: self.rx_disposeBag)
        titleContainer.addSubview(skip)

        // --- Constraints ---

        let stackViewHeight: CGFloat
        if config.contentViewsStackViewAxis == .horizontal {
            stackViewHeight = 60
        } else {
            stackViewHeight = 60.0 * CGFloat(config.contentViews.count) + textFieldStackView.spacing * (CGFloat(config.contentViews.count) - 1)
        }

        NSLayoutConstraint.activate([
            titleContainer.topAnchor.constraint(equalTo: self.view.htw.safeAreaLayoutGuide.topAnchor, constant: 12),
            titleContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            titleContainer.bottomAnchor.constraint(equalTo: centerStackView.topAnchor),
            titleContainer.widthAnchor.constraint(equalTo: centerStackView.widthAnchor),

            skip.topAnchor.constraint(equalTo: titleContainer.topAnchor),
            skip.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor),

            titleLabel.centerXAnchor.constraint(equalTo: titleContainer.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: titleContainer.centerYAnchor),

            centerStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            centerStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -50),
            centerStackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),

            textFieldStackView.heightAnchor.constraint(equalToConstant: stackViewHeight),

            self.continueButton.heightAnchor.constraint(equalToConstant: 55),
            self.continueButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.continueButton.widthAnchor.constraint(equalTo: centerStackView.widthAnchor),
            self.continueButton.bottomAnchor.constraint(equalTo: self.view.htw.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .default
	}

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    @objc func inputChanges(textField: TextField) {
        self.checkState()
    }

    // MARK: - UITextFieldDelegate

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string) as String

        return self.shouldReplace(textField: textField, newString: newString)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

}
