//
//  StudyGroupViewController.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 02.08.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit
import Lottie
import RxSwift
import RxCocoa

class StudyGroupViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var lblStudyGroups: UILabel!
    @IBOutlet weak var lblStudygroupDescription: UILabel!
    @IBOutlet weak var lblStudyGroupInformation: UILabel!
    @IBOutlet weak var userAnimationView: AnimationView!
    @IBOutlet weak var btnYear: UIButton!
    @IBOutlet weak var btnMajor: UIButton!
    @IBOutlet weak var btnGroup: UIButton!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblMajor: UILabel!
    @IBOutlet weak var lblGroup: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    
    // MARK: - Properties
    weak var context: AppContext?
    private lazy var userAnimation: Animation? = {
        return Animation.named("UserGrey")
    }()
    weak var delegate: UIPageViewSwipeDelegate?
    var delegateClosure: (() -> Void)? = nil
    private let visualEffectView = UIVisualEffectView(effect: nil)
    private lazy var animator: UIViewPropertyAnimator = {
        return UIViewPropertyAnimator(duration: 0.4, curve: .easeInOut, animations: {
            self.visualEffectView.effect = UIBlurEffect(style: .regular)
        })
    }()
    private var state = BehaviorRelay(value: State())
    
    // MARK: - States
    private struct State {
        // MARK: - State.Study Year
        var years: [StudyYear]?
        var year: StudyYear? {
            didSet {
                if oldValue?.studyYear != year?.studyYear {
                    major = nil
                    group = nil
                }
            }
        }
        
        // MARK: - State.Study Courses
        var majors: [StudyCourse]? {
            guard let years = years, let year = year else { return nil }
            return years
                .first(where: { $0.studyYear == year.studyYear })?
                .studyCourses?
                .filter({ !$0.name.isEmpty })
        }
        var major: StudyCourse? {
            didSet {
                if oldValue?.studyCourse != major?.studyCourse {
                    group = nil
                }
            }
        }
        
        // MARK: - State.Study Groups
        var groups: [StudyGroup]? {
            guard let major = major, let majors = majors else { return nil }
            return majors.first(where: { $0.studyCourse == major.studyCourse })?.studyGroups
        }
        var group: StudyGroup?
        
        // MARK: - State.Completed
        var completed: Bool {
            return year != nil && major != nil && group != nil
        }
    }
    
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
            self.userAnimationView.play()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if delegate == nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(25), execute: { [weak self] in
                guard let self = self else { return }
                self.animator.startAnimation()
            })
        }
    }
    
    // MARK: - User Interaction
    @IBAction func onButtonsTouch(_ sender: UIButton) {
        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .medium)
        impactFeedbackgenerator.prepare()
        impactFeedbackgenerator.impactOccurred()
        
        let selectionViewController = R.storyboard.onboarding.studyGroupSelectionViewController()!.also {
            $0.modalPresentationStyle = .overCurrentContext
        }
        
        switch sender {
        case btnYear:
            selectionViewController.data = state.value.years ?? []
            selectionViewController.onSelect = { [weak self] selection in
                guard let self = self, let selection = selection else { return }
                if let selection = selection as? StudyYear {
                    var mutableState = self.state.value
                    mutableState.year = selection
                    self.state.accept(mutableState)
                }
            }
            present(selectionViewController, animated: true, completion: nil)
        
        case btnMajor:
            selectionViewController.data = state.value.majors ?? []
            selectionViewController.onSelect = { [weak self] selection in
                guard let self = self, let selection = selection else { return }
                if let selection = selection as? StudyCourse {
                    var mutableState = self.state.value
                    mutableState.major = selection
                    self.state.accept(mutableState)
                }
            }
            present(selectionViewController, animated: true, completion: nil)
            
        case btnGroup:
            selectionViewController.data = state.value.groups ?? []
            selectionViewController.onSelect = { [weak self] selection in
                guard let self = self, let selection = selection else { return }
                
                if let selection = selection as? StudyGroup {
                    var mutableState = self.state.value
                    mutableState.group = selection
                    self.state.accept(mutableState)
                }
            }
            
            present(selectionViewController, animated: true, completion: nil)
        default:
            break
        }
    }
    
    @IBAction func onCancelTap(_ sender: UIButton) {
        UIImpactFeedbackGenerator(style: .medium)
            .also { $0.prepare() }
            .apply { $0.impactOccurred() }
        
        disolveWithAnimation()
    }
    
    private func disolveWithAnimation() {
        UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut, animations: { [weak self] in
            guard let self = self else { return }
            self.visualEffectView.effect = nil
        }).apply { $0.startAnimation() }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(170)) { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension StudyGroupViewController {
    
    private func setup() {
        
        lblStudyGroups.apply {
            $0.text         = R.string.localizable.onboardingStudygroupTitle()
            $0.textColor    = UIColor.htw.Label.primary
        }
        
        lblStudygroupDescription.apply {
            $0.text         = R.string.localizable.onboardingStudygroupDescription()
            $0.textColor    = UIColor.htw.Label.primary
        }
        
        lblStudyGroupInformation.apply {
            $0.text         = R.string.localizable.onboardingStudygroupInformation()
            $0.textColor    = UIColor.htw.Label.secondary
        }
        
        userAnimationView.apply {
            $0.animation    = userAnimation
            $0.contentMode  = .scaleAspectFill
            $0.loopMode     = .playOnce
        }
        
        btnYear.apply {
            $0.makeDropShadow()
            $0.setTitle(R.string.localizable.onboardingStudygroupYear(), for: .normal)
            $0.setState(with: .inactive)
        }
        
        lblYear.apply {
            $0.textColor    = UIColor.htw.Label.secondary
            $0.font         = UIFont.htw.Labels.secondary
        }
        
        btnMajor.apply {
            $0.makeDropShadow()
            $0.setTitle(R.string.localizable.onboardingStudygroupMajor(), for: .normal)
            $0.setState(with: .inactive)
        }
        
        lblMajor.apply {
            $0.textColor    = UIColor.htw.Label.secondary
            $0.font         = UIFont.htw.Labels.secondary
        }
        
        btnGroup.apply {
            $0.makeDropShadow()
            $0.setTitle(R.string.localizable.onboardingStudygroupGroup(), for: .normal)
            $0.setState(with: .inactive)
        }
        
        lblGroup.apply {
            $0.textColor    = UIColor.htw.Label.secondary
            $0.font         = UIFont.htw.Labels.secondary
        }
        
        if delegate == nil {
            btnClose.apply {
                $0.isHidden = false
                $0.setTitle(R.string.localizable.onboardingStudygroupNotnow(), for: .normal)
            }
            view.insertSubview(visualEffectView.also { $0.frame = self.view.frame }, at: 0)
        }
    }
    
    private func observe() {
        
        context?.apiService.requestStudyGroups()
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                var mutableState = self.state.value
                mutableState.years = data
                self.state.accept(mutableState)
                }, onError: { Log.error($0) })
            .disposed(by: rx_disposeBag)
        
        state.asObservable()
            .map({ $0.years != nil })
            .subscribe(onNext: { [weak self] hasYears in
                guard let self = self else {  return }
                self.btnYear.setState(with: hasYears ? .active : .inactive) }, onError: { Log.error($0) })
            .disposed(by: rx_disposeBag)
        
        state.asObservable()
            .map({ $0.year != nil })
            .subscribe(onNext: { [weak self] hasYear in
                guard let self = self else {  return }
                self.btnMajor.setState(with: hasYear ? .active : .inactive)
                self.lblYear.apply {
                    $0.isHidden = !hasYear
                    if let year = self.state.value.year {
                        $0.text = "\(year.studyYear + 2000)"
                    }
                }
                }, onError: { Log.error($0) })
            .disposed(by: rx_disposeBag)
        
        state.asObservable()
            .map({ $0.major != nil })
            .subscribe(onNext: { [weak self] hasMajor in
                guard let self = self else { return }
                self.btnGroup.setState(with: hasMajor ? .active : .inactive)
                self.lblMajor.apply {
                    $0.isHidden = !hasMajor
                    if let major = self.state.value.major {
                        $0.text = "\(major.name.nilWhenEmpty ?? String("---"))\n\(major.studyCourse)"
                    }
                }
                }, onError: { Log.error($0) })
            .disposed(by: rx_disposeBag)
        
        state.asObservable()
            .map({ $0.group != nil })
            .subscribe(onNext: { [weak self] hasGroup in
                guard let self = self else { return }
                self.lblGroup.apply {
                    $0.isHidden = !hasGroup
                    if let group = self.state.value.group {
                        $0.text = "\(group.name)\n\(group.studyGroup)"
                    }
                }
                }, onError: { Log.error($0) })
            .disposed(by: rx_disposeBag)
        
        state.asObservable()
            .map({ $0.completed })
            .subscribe(onNext: { [weak self] (isCompleted: Bool) in
                guard let self = self else { return }
                if isCompleted {
                    KeychainService.shared.storeStudyToken(year: self.state.value.year?.studyYear.description,
                                                           major: self.state.value.major?.studyCourse,
                                                           group: self.state.value.group?.studyGroup,
                                                           graduation: self.state.value.group?.name)
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(750), execute: {
                        self.delegate?.next(animated: true)
                        if let delegateClosure = self.delegateClosure {
                            delegateClosure()
                            self.disolveWithAnimation()
                        }
                    })
                }
            }, onError: { Log.error($0) })
            .disposed(by: rx_disposeBag)
    }
    
}
