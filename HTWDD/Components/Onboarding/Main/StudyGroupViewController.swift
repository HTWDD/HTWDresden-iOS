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
    
    // MARK: - Properties
    weak var context: AppContext?
    private lazy var userAnimation: Animation? = {
        return Animation.named("UserGrey")
    }()
    weak var delegate: UIPageViewSwipeDelegate?
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
            return years.first(where: { $0.studyYear == year.studyYear })?.studyCourses
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
}

extension StudyGroupViewController {
    
    private func setup() {
        
        lblStudyGroups.text             = R.string.localizable.onboardingStudygroupTitle()
        lblStudygroupDescription.text   = R.string.localizable.onboardingStudygroupDescription()
        lblStudyGroupInformation.text   = R.string.localizable.onboardingStudygroupInformation()
        
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
        
        btnMajor.apply {
            $0.makeDropShadow()
            $0.setTitle(R.string.localizable.onboardingStudygroupMajor(), for: .normal)
            $0.setState(with: .inactive)
        }
        
        btnGroup.apply {
            $0.makeDropShadow()
            $0.setTitle(R.string.localizable.onboardingStudygroupGroup(), for: .normal)
            $0.setState(with: .inactive)
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
            .subscribe(onNext: { [weak self] isCompleted in
                guard let self = self else { return }
                if isCompleted {
                    KeychainService.shared.storeStudyToken(year: self.state.value.year?.studyYear.description, major: self.state.value.major?.studyCourse, group: self.state.value.group?.studyGroup)
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(750), execute: {
                        self.delegate?.next(animated: true)
                    })
                } else {
                    StudyYearRealm.clear()
                }
                }, onError: { Log.error($0) })
            .disposed(by: rx_disposeBag)
    }
    
}
