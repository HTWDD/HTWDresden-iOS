//
//  TimetableViewController.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 01.10.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//
import Action
import RxSwift

class TimetableListViewController: TimetableBaseViewController {

    @IBOutlet var tableView: UITableView!
    var items: [Timetables] = [] {
        didSet {
            reloadData()
        }
    }
    
    lazy var action: Action<Void, [Timetables]> = Action { [weak self] (_) -> Observable<[Timetables]> in
        guard let self = self else { return Observable.empty() }
        return self.viewModel.load().observeOn(MainScheduler.instance)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.apply {
            $0.estimatedRowHeight   = 200
            $0.rowHeight            = UITableView.automaticDimension
            $0.delegate = self
        }
        
        load()
    }
    
    override func setup() {
        refreshControl = UIRefreshControl().also {
            $0.tintColor = .white
            $0.rx.bind(to: action, input: ())
        }
        
        tableView.apply {
            $0.separatorStyle   = .none
            $0.backgroundColor  = UIColor.htw.veryLightGrey
            $0.backgroundView   = stateView
            $0.register(TimetableHeaderViewCell.self)
            $0.register(TimetableLessonViewCell.self)
            $0.register(TimetableFreedayViewCell.self)
        }
    }

    private func load() {
        
        action.elements.subscribe(onNext: { [weak self] items in
            guard let self = self else { return }
            self.items = items
            self.stateView.isHidden = true
            
            if items.isEmpty {
                self.stateView.setup(with: EmptyResultsView.Configuration(icon: "🥺", title: R.string.localizable.scheduleNoResultsTitle(), message: R.string.localizable.scheduleNoResultsMessage(), hint: nil, action: nil))
                self.items = []
            } else {
                self.scrollToToday(notAnimated: true)
            }
        }).disposed(by: rx_disposeBag)
        
        action.errors.subscribe(onNext: { [weak self] error in
            guard let self = self else { return }
            self.items = []
                
            self.stateView.setup(with: EmptyResultsView.Configuration(icon: "🤯", title: R.string.localizable.examsNoCredentialsTitle(), message: R.string.localizable.examsNoCredentialsMessage(), hint: R.string.localizable.add(), action: UITapGestureRecognizer(target: self, action: #selector(self.onTap))))
            
        }).disposed(by: rx_disposeBag)
        
        action.execute()
    }
    
    @objc private func onTap() {
        let viewController = R.storyboard.onboarding.studyGroupViewController()!
        viewController.context = self.context
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        viewController.delegateClosure = { [weak self] in
            guard let self = self else {
                return
            }
            
            self.load()
        }
        
        present(viewController, animated: true, completion: nil)
    }
    
    override func reloadData(){
        tableView.reloadData()
    }
    
    override func scrollToToday(notAnimated: Bool = true) {
        guard !items.isEmpty else {
            return
        }
        
        var indexOfHeader: Int = 0
        indexer: for (index, element) in items.enumerated() {
            switch element {
            case .header(let model):
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy"
                
                if let elementDate = dateFormatter.date(from: model.header),
                   elementDate.localDate >= Calendar.current.startOfDay(for: Date().localDate) {
                    indexOfHeader = index
                    break indexer
                }
            default: break
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.scrollToRow(at: IndexPath(row: indexOfHeader, section: 0), at: .top, animated: !notAnimated)
        }
    }
    
    override func getAllLessons() -> [Lesson]? {
        
        var lessons: [Lesson]? = items.compactMap {
        
            if case .lesson(let model) = $0 {
                return model
            }
            
            return .none
        }
        
        lessons?.removeDuplicates()
        
        return lessons
    }
    
    override func getSemesterWeeks() -> [Int] {
        guard let lessons = getAllLessons() else { return [] }
        
        var semesterWeeks: [Int] = []
        var lessonDateStrings: [String] = []
        
        lessons.forEach { lesson in
            lessonDateStrings.append(contentsOf: lesson.lessonDays)
        }
        
        lessonDateStrings.removeDuplicates()
        lessonDateStrings.forEach { lessonDate in
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            
            if let date = dateFormatter.date(from: lessonDate) {
                semesterWeeks.append(Calendar.current.component(.weekOfYear, from: date))
            }
        }
        semesterWeeks.removeDuplicates()
        semesterWeeks.sort()
        return semesterWeeks
    }
}

// MARK: - Timetable Datasource
extension TimetableListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (items[indexPath.row]) {
        case .header(let model):
            return tableView.dequeueReusableCell(TimetableHeaderViewCell.self, for: indexPath)!.also {
                $0.setup(with: model)
            }
        case .lesson(let model):
            return tableView.dequeueReusableCell(TimetableLessonViewCell.self, for: indexPath)!.also {
                $0.exportDelegate = self
                $0.setup(with: model)
            }
        case .freeday(let model):
            return tableView.dequeueReusableCell(TimetableFreedayViewCell.self, for: indexPath)!.also {
                $0.setup(with: model)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (items[indexPath.row]) {
        case .lesson(let model):
            let detailsLessonViewController = R.storyboard.timetable.timetableLessonDetailsViewController()!.also {
                $0.context      = context
                $0.semseterWeeks = getSemesterWeeks()
            }
            
            detailsLessonViewController.setup(model: model)
            self.navigationController?.pushViewController(detailsLessonViewController, animated: true)
        default: break
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = tableView.contentOffset.y
        if let cell = tableView.visibleCells.compactMap( { $0 as? TimetableFreedayViewCell } ).first {
            let x = cell.imageViewFreeday.frame.origin.x
            let w = cell.imageViewFreeday.bounds.width
            let h = cell.imageViewFreeday.bounds.height
            let y = (((offsetY + cell.frame.height * 2.5 ) - cell.frame.origin.y) / h) * 1.5
            cell.imageViewFreeday.frame = CGRect(x: x, y: y, width: w, height: h)
        }
    }
    
}

extension TimetableListViewController: LessonViewCellExportDelegate {
    
    func export(_ lesson: Lesson) {
        
        let exportMenu = UIAlertController(title: R.string.localizable.exportTitle(), message: R.string.localizable.exportMessage(), preferredStyle: .actionSheet)
        
        let fullExportAction = UIAlertAction(title: R.string.localizable.exportAll(), style: .default, handler: { _ in
  
            self.viewModel.export(lessons: [lesson])
            self.showSuccessMessage()
        })
        
        let cancelAction = UIAlertAction(title: R.string.localizable.cancel(), style: .cancel)
        
        exportMenu.addAction(fullExportAction)
        exportMenu.addAction(cancelAction)
        
        self.present(exportMenu, animated: true, completion: nil)
    }
}
