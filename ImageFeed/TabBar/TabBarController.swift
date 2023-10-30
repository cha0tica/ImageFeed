//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Agata on 27.09.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    private struct Keys {
        static let main = "Main"
        static let imagesListViewController = "ImagesListViewController"
        static let tabBarProfileImageName = "tab_profile_active"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let storybord = UIStoryboard(name: Keys.main, bundle: .main)
        
        let imageListViewController = storybord.instantiateViewController(withIdentifier: Keys.imagesListViewController)
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: Keys.tabBarProfileImageName),
            selectedImage: nil
        )
        
        self.viewControllers = [imageListViewController, profileViewController]
    }
}
