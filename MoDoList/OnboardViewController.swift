//
//  OnboardViewController.swift
//  MoDoList
//
//  Created by Eun Jun Jang on 2016. 10. 14..
//  Copyright © 2016년 SilverJun. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class OnboardingPager : UIPageViewController {
    
    override func viewDidLoad() {
        // Set the dataSource and delegate in code.
        // I can't figure out how to do this in the Storyboard!
        dataSource = self
        delegate = self
        // this sets the background color of the built-in paging dots
        view.backgroundColor = UIColor.init(red: 48.0/255.0, green: 225.0/255.0, blue: 178.0/255.0, alpha: 1.0)

        
        // This is the starting point.  Start with step zero.
        setViewControllers([getOne()], direction: .Forward, animated: false, completion: nil)
    }
    
    func getOne() -> OnboardOneViewController {
        return storyboard!.instantiateViewControllerWithIdentifier("OnboardOneViewController") as! OnboardOneViewController
    }
    func getTwo() -> OnboardTwoViewController {
        return storyboard!.instantiateViewControllerWithIdentifier("OnboardTwoViewController") as! OnboardTwoViewController
    }
    func getThree() -> OnboardThreeViewController {
        return storyboard!.instantiateViewControllerWithIdentifier("OnboardThreeViewController") as! OnboardThreeViewController
    }
    func getFour() -> OnboardFourViewController {
        return storyboard!.instantiateViewControllerWithIdentifier("OnboardFourViewController") as! OnboardFourViewController
    }
    func getFive() -> OnboardFiveViewController {
        return storyboard!.instantiateViewControllerWithIdentifier("OnboardFiveViewController") as! OnboardFiveViewController
    }
    
}

// MARK: - UIPageViewControllerDataSource methods

extension OnboardingPager : UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if viewController.isKindOfClass(OnboardFiveViewController) {
            return getFour()
        } else if viewController.isKindOfClass(OnboardFourViewController) {
            return getThree()
        } else if viewController.isKindOfClass(OnboardThreeViewController) {
            return getTwo()
        } else if viewController.isKindOfClass(OnboardTwoViewController) {
            return getOne()
        } else {
            return nil
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if viewController.isKindOfClass(OnboardOneViewController) {
            return getTwo()
        } else if viewController.isKindOfClass(OnboardTwoViewController) {
            return getThree()
        } else if viewController.isKindOfClass(OnboardThreeViewController) {
            return getFour()
        } else if viewController.isKindOfClass(OnboardFourViewController) {
            return getFive()
        } else {
            return nil
        }
    }
    
    // Enables pagination dots
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 5
    }
    
    // This only gets called once, when setViewControllers is called
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}

// MARK: - UIPageViewControllerDelegate methods

extension OnboardingPager : UIPageViewControllerDelegate {
    
}