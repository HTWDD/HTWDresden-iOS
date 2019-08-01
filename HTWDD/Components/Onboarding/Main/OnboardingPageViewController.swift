//
//  OnboardingPageViewController.swift
//  HTWDD
//
//  Created by Mustafa Karademir on 31.07.19.
//  Copyright © 2019 HTW Dresden. All rights reserved.
//

import UIKit




class OnboardingPageViewController: UIPageViewController {
    
    // MARK: - Properties
    private(set) lazy var orderdViewControllers: [UIViewController] = {
        return [R.storyboard.onboarding.welcomeViewController()!,
                R.storyboard.onboarding.analyticsViewController()!.also { $0.delegate = self },
                R.storyboard.onboarding.welcomeViewController()!]
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        if let firstViewController = orderdViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pageControl?.pageIndicatorTintColor         = UIColor.htw.grey
        pageControl?.currentPageIndicatorTintColor  = UIColor.htw.blue
    }
}

// MARK: - PageViewDataSource & PageIndicator
extension OnboardingPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderdViewControllers.firstIndex(of: viewController) else { return nil }
        let prevoisIndex = viewControllerIndex - 1
        guard prevoisIndex >= 0 else { return nil }
        guard orderdViewControllers.count > prevoisIndex else { return nil }
        return orderdViewControllers[prevoisIndex]
        
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderdViewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderdViewControllers.count
        guard orderedViewControllersCount != nextIndex else { return nil }
        guard orderedViewControllersCount > nextIndex else { return nil }
        return orderdViewControllers[nextIndex]
        
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return orderdViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first, let firstViewControllerIndex = orderdViewControllers.firstIndex(of: firstViewController) else { return 0 }
        return firstViewControllerIndex
    }
}

// MARK: UIPage Swipe Delegate
extension OnboardingPageViewController: UIPageViewSwipeDelegate {
    func next(animated: Bool) {
        self.goToNextPage(animated: animated)
    }
    
    func previous(animated: Bool) {
        self.goToPreviousPage(animated: animated)
    }
}

