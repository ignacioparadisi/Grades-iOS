//
//  ViewController.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/1/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    let homeViewController = UINavigationController(rootViewController: HomeViewController())
    let calendarViewController = UINavigationController(rootViewController: CalendarViewController())
    let gradesViewController = UINavigationController(rootViewController: GradesViewController())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addItemsToViewControllers()
        let viewControllers = [
            homeViewController,
            calendarViewController,
            gradesViewController
        ]
        self.viewControllers = viewControllers
       
    }
    
    private func addItemsToViewControllers() {
        let homeImage = UIImage(named: .home)
        let homeItem = UITabBarItem(title: "Home".localized, image: homeImage, selectedImage: homeImage)
        homeViewController.tabBarItem = homeItem
        
        let calendar = Calendar(identifier: .gregorian)
        let today = calendar.component(.day, from: Date())
        
        let calendarImage = UIImage(named: ImageNames.calendar.rawValue + "\(today)")
        let calendarItem = UITabBarItem(title: "Calendar".localized, image: calendarImage, selectedImage: calendarImage)
        calendarViewController.tabBarItem = calendarItem
        
        let gradesImage = UIImage(named: .grades)
        let gradesItem = UITabBarItem(title: "Grades".localized, image: gradesImage, selectedImage: gradesImage)
        gradesViewController.tabBarItem = gradesItem
    }


}

