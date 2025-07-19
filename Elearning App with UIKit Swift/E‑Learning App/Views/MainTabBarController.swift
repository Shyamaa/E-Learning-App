//
//  MainTabBarController.swift
//  E‑Learning App
//
//  Created by MMI Softwares Pvt Ltd on 19/07/25.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupViewControllers()
    }
    
    private func setupTabBar() {
        tabBar.tintColor = .systemBlue
        tabBar.backgroundColor = .systemBackground
        tabBar.unselectedItemTintColor = .systemGray
    }
    
    private func setupViewControllers() {
        let homeVC = HomeViewController()
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        let coursesVC = CourseListViewController()
        let coursesNav = UINavigationController(rootViewController: coursesVC)
        coursesNav.tabBarItem = UITabBarItem(
            title: "Courses",
            image: UIImage(systemName: "book"),
            selectedImage: UIImage(systemName: "book.fill")
        )
        
        let searchVC = SearchViewController()
        let searchNav = UINavigationController(rootViewController: searchVC)
        searchNav.tabBarItem = UITabBarItem(
            title: "Search",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass")
        )
        
        let profileVC = ProfileViewController()
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        viewControllers = [homeNav, coursesNav, searchNav, profileNav]
    }
}

// These view controllers are now implemented in separate files 