//
//  TimetableWeekView.swift
//  HTWDD
//
//  Created by Chris Herlemann on 15.12.20.
//  Copyright © 2020 HTW Dresden. All rights reserved.
//

import UIKit
import JZCalendarWeekView

protocol TimetableWeekViewDelegate: AnyObject {
    func export(_ lessonEvent: LessonEvent)
}

class TimetableWeekView: JZBaseWeekView {
    
    var isDarkMode: Bool {
        if #available(iOS 13.0, *) {
            return self.traitCollection.userInterfaceStyle == .dark
        }
        else {
            return false
        }
    }
    
    weak var delegate: TimetableWeekViewDelegate?
    
    override func registerViewClasses() {
        super.registerViewClasses()
        
        self.collectionView.register(UINib(nibName: "LessonCell", bundle: nil), forCellWithReuseIdentifier: "LessonCell")
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LessonCell", for: indexPath) as? LessonCell,
           let event = getCurrentEvent(with: indexPath) as? LessonEvent {
            cell.configureCell(event: event)
            cell.exportDelegate = self
            return cell
        }
        
        preconditionFailure("LessonCell should be casted")
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let cell = super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
        
        switch kind {
        case JZSupplementaryViewKinds.currentTimeline:
            break
        default:
            cell.backgroundColor = isDarkMode ? .black : .white
            cell.tintColor = .white
        }
        
        return cell
    }
    
    override func setup() {
        super.setup()
        
        setColors()
    }
    
    private func setColors() {
        
        if isDarkMode {
            collectionView.backgroundColor = .black
        } else {
            collectionView.backgroundColor = .white
        }
        
        collectionView.reloadData()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        setColors()
    }
}

extension TimetableWeekView: LessonCellExportDelegate {
    func export(_ lessonEvent: LessonEvent) {
        delegate?.export(lessonEvent)
    }
}

