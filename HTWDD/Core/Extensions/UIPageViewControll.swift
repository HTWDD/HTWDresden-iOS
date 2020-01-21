//
//  UIPageViewControll.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 31.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import Foundation

extension UIPageViewController {
    
    var pageControl: UIPageControl? {
        return view.subviews.first(where: { $0 is UIPageControl }) as? UIPageControl
    }
    
    func goToNextPage(animated: Bool = true) {
        guard let currentViewController = viewControllers?.first, let nextViewController = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) else { return }
        setViewControllers([nextViewController], direction: .forward, animated: animated, completion: nil)
    }
    
    func goToPreviousPage(animated: Bool = true) {
        guard let currentViewController = viewControllers?.first, let prevoisViewController = dataSource?.pageViewController(self, viewControllerBefore: currentViewController) else { return }
        setViewControllers([prevoisViewController], direction: .reverse, animated: animated, completion: nil)
    }
}
