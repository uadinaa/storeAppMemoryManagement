//
//  TabBarView.swift
//  storeAppMemoryManagement
//
//  Created by Дина Абитова on 19.02.2025.
//

import UIKit

class TabBarViewController : UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = UINavigationController(rootViewController: FeedViewController())
        let vc3 = UINavigationController(rootViewController: ProfileViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "globe.europe.africa.fill")
        vc3.tabBarItem.image = UIImage(systemName: "person.crop.circle.fill")

        vc1.title = "Posts"
        vc3.title = "Profile"
        
        tabBar.backgroundColor = .systemBackground
        tabBar.tintColor = .red
        setViewControllers([vc1, vc3], animated: true)
        
    }
}
