//
//  ScheduleWeekVC.swift
//  HTWDD
//
//  Created by Fabian Ehlert on 30.10.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import UIKit
import RxSwift

final class ScheduleWeekVC: ScheduleBaseVC {

    private let days = [
        Loca.monday_short,
        Loca.tuesday_short,
        Loca.wednesday_short,
        Loca.thursday_short,
        Loca.friday_short,
        Loca.saturday_short,
        Loca.sunday_short
    ]
    
	// MARK: - Init
    
	init(configuration: ScheduleDataSource.Configuration) {
        let layout = ScheduleWeekLayout()
        var config = configuration
        config.originDate = nil
        super.init(configuration: config, layout: layout, startHour: 6.5)
        layout.dataSource = self
        self.dataSource.delegate = self
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func initialSetup() {
        super.initialSetup()
        self.collectionView.isDirectionalLockEnabled = true
        
        self.dataSource.register(type: LectureCollectionViewCell.self)
        self.dataSource.registerSupplementary(LectureTimeView.self, kind: .description) { [weak self] time, indexPath in
            guard let `self` = self else {
                return
            }
            let hour = Int(self.startHour) - 1 + indexPath.row
            time.hour = hour
        }
	}
    
    override func headerText(day: Day, date: Date) -> String {
        let index = day.rawValue
        return self.days[index]
    }

    override func jumpToToday() {
        self.scrollToToday(animated: true)
    }
    
    private func scrollToToday(animated: Bool) {
        guard let semesterInformation = self.dataSource.semesterInformation else {
            return
        }
        
        let semesterBegin = semesterInformation.period.begin.date
        let daysUntilStartOfWeek = Date().beginOfWeek.daysSince(other: semesterBegin)
        let indexPath = IndexPath(item: 0, section: daysUntilStartOfWeek)
        
        guard self.collectionView.numberOfSections >= indexPath.section else {
            return
        }
        
        // scroll to item
        self.collectionView.scrollToItem(at: indexPath, at: .left, animated: animated)
        self.collectionView.contentOffset.x -= ScheduleWeekLayout.Const.timeWidth + self.itemMargin
    }
    
}

// MARK: - ScheduleWeekLayoutDataSource
extension ScheduleWeekVC: ScheduleWeekLayoutDataSource {
	var widthPerDay: CGFloat {
		let numberOfDays = 6
		return self.view.bounds.width / CGFloat(numberOfDays)
	}

	var height: CGFloat {
		let navbarHeight = self.navigationController?.navigationBar.bottom ?? 0
		return self.collectionView.bounds.height - navbarHeight
	}

	var endHour: CGFloat {
		return 21.3
	}

	func dateComponentsForItem(at indexPath: IndexPath) -> (begin: DateComponents, end: DateComponents)? {
		guard let item = self.dataSource.lecture(at: indexPath) else {
			return nil
		}
		return (item.begin, item.end)
	}
    
    var todayIndexPath: IndexPath? {
        return self.dataSource.indexPathOfToday
    }
}

extension ScheduleWeekVC: ScheduleDataSourceDelegate {
    
    func scheduleDataSourceHasFinishedLoading() {
        // we explicitly need to wait for the next run loop
        DispatchQueue.main.async {
            self.scrollToToday(animated: false)
        }
    }
    
    func scheduleDataSourceHasUpdated() {
        
    }
    
}

extension ScheduleWeekVC: TabbarChildViewController {
    func tabbarControllerDidSelectAlreadyActiveChild() {
        self.jumpToToday()
    }
}
