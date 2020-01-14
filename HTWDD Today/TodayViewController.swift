//
//  TodayViewController.swift
//  HTWDD Today
//
//  Created by Fabian Ehlert on 05.11.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NotificationCenter

class TodayViewController: UIViewController {
	
	// MARK: - Properties
    private let apiServivce = ApiService.shared()
    private var lesson: Lesson? {
        didSet {
            if self.lesson != nil {
                updateUserInterface()
            } else {
                emptyLesson()
            }
        }
    }
    
	private let disposeBag = DisposeBag()
	
    // MARK: - Outlets
    @IBOutlet weak var lblLectureTitle: UILabel!
    @IBOutlet weak var lblProfessor: UILabel!
    @IBOutlet weak var lblLectureType: BadgeLabel!
    @IBOutlet weak var lblRoom: BadgeLabel!
    @IBOutlet weak var lblLectureBegin: UILabel!
    @IBOutlet weak var lblLectureEnd: UILabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var lblHint: UILabel!
	@IBOutlet private weak var containerView: UIView!
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
        setup()
        
        requestTimetable()
            .debug()
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] (lesson: Lesson?) in
                    guard let self = self else { return }
                    self.lesson = lesson
                },
                onError: { [weak self] error in
                    guard let self = self else { return }
                    Log.error(error)
                    self.toggleViews(isHidden: true)
                    self.lblHint.text = R.string.localizable.examsNoCredentialsTitle()
                }
            ).disposed(by: disposeBag)
	}
    
    private func setup() {
        
        view.apply {
            $0.backgroundColor = .clear
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap)))
        }
        extensionContext?.widgetLargestAvailableDisplayMode = .compact
        
        lblLectureTitle.apply {
            $0.textColor = UIColor.htw.Label.primary
        }
        
        lblProfessor.apply {
            $0.textColor = UIColor.htw.Label.secondary
        }
        
        lblLectureType.apply {
            $0.backgroundColor  = UIColor.htw.Badge.primary
            $0.textColor        = UIColor.htw.Label.primary
        }
        
        lblRoom.apply {
            $0.backgroundColor  = UIColor.htw.Material.blue
            $0.textColor        = .white
        }
            
        lblLectureBegin.apply {
            $0.textColor = UIColor.htw.Label.primary
        }
        
        lblLectureEnd.apply {
            $0.textColor = UIColor.htw.Label.primary
        }
        
    }
    
    private func requestTimetable() -> Observable<Lesson?> {
        let (year, major, group, _) = KeychainService.shared.readStudyToken()
        if let year = year, let major = major, let group = group {
            return apiServivce
                .requestLessons(for: year, major: major, group: group)
                .observeOn(SerialDispatchQueueScheduler(qos: .background))
                .asObservable()
                .map { (lessons: [Lesson]) -> Lesson? in
                    var result: Lesson? = nil
                    if !lessons.isEmpty {
                        result = lessons
                            .filter { $0.weeksOnly.contains(Date().weekNumber) }
                            .filter { $0.day == ((Date().weekDay - 1) % 7) }
                            .sorted(by: { (lhs, rhs) -> Bool in
                                lhs.beginTime < rhs.beginTime
                            })
                            .filter { $0.endTime >= Date().string(format: "HH:mm:ss") }
                            .first
                    }
                    return result
                }
        } else {
            return Observable.error(AuthError.noStudyToken)
        }
    }
	
	// MARK: - UI
    private func updateUserInterface() {
        guard let lesson = lesson else {
            emptyLesson()
            return
        }
        
        toggleViews(isHidden: false)

        self.lblLectureTitle.text   = lesson.name
        self.lblProfessor.text      = lesson.professor
        self.lblLectureType.text    = lesson.type.localizedDescription
        self.lblRoom.text           = String(lesson.rooms.description.dropFirst().dropLast()).replacingOccurrences(of: "\"", with: "")
        self.lblLectureBegin.text   = String(lesson.beginTime.prefix(5))
        self.lblLectureEnd.text     = String(lesson.endTime.prefix(5))
        self.separatorView.backgroundColor =  "\(lesson.name) \(String(lesson.professor ?? ""))".materialColor
    }
    
    private func emptyLesson() {
        toggleViews(isHidden: true)
        lblHint.text = R.string.localizable.scheduleFreeDay()
    }
    
    private func toggleViews(isHidden: Bool) {
        lblHint.isHidden            = !isHidden
        lblLectureTitle.isHidden    = isHidden
        lblProfessor.isHidden       = isHidden
        lblLectureType.isHidden     = isHidden
        lblRoom.isHidden            = isHidden
        lblLectureBegin.isHidden    = isHidden
        lblLectureEnd.isHidden      = isHidden
        separatorView.isHidden      = isHidden
    }
	
    // MARK: - URL
    @objc
    func handleTap() {
        guard let url = URL.htw.route(for: .schedule) else { return }
        extensionContext?.open(url)
    }
}

// MARK: - NCWidgetProviding
extension TodayViewController: NCWidgetProviding {
	func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
		completionHandler(NCUpdateResult.newData)
	}
	
	func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
		let compactSize = self.extensionContext?.widgetMaximumSize(for: .compact) ?? CGSize.zero
		switch activeDisplayMode {
		case .compact:
			self.preferredContentSize = compactSize
		case .expanded:
			self.preferredContentSize = CGSize(width: compactSize.width, height: compactSize.height * 2)
        @unknown default:
            Log.verbose("@unknown default")
        }
	}
}
