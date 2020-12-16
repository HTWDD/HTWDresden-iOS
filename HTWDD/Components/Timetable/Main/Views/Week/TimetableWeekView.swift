//
//  TimetableWeekView.swift
//  HTWDD
//
//  Created by Chris Herlemann on 15.12.20.
//  Copyright © 2020 HTW Dresden. All rights reserved.
//

import UIKit
import JZCalendarWeekView

class TimetableWeekView: JZBaseWeekView {

    override func registerViewClasses() {
        super.registerViewClasses()

        self.collectionView.register(UINib(nibName: "LessonCell", bundle: nil), forCellWithReuseIdentifier: "LessonCell")
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LessonCell", for: indexPath) as? LessonCell,
            let event = getCurrentEvent(with: indexPath) as? LessonEvent {
            cell.configureCell(event: event)
            return cell
        }
        preconditionFailure("LessonCell and DefaultEvent should be casted")
    }
}
