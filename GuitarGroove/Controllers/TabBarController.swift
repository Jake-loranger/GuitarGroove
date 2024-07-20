//
//  TabBarController.swift
//  GuitarGroove
//
//  Created by Jacob  Loranger on 7/20/24.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }
    
    func configureTabBar() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .systemBackground
        UITabBar.appearance().tintColor = .systemGray
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        viewControllers = [createRecordNC(), createLibraryNC()]
    }
    
    private func createRecordNC() -> UINavigationController {
        let recordVC = RecordVC()
        recordVC.tabBarItem = UITabBarItem(title: "Record", image: UIImage(systemName: "mic.circle"), tag: 0)
        
        let recordNC = UINavigationController(rootViewController: recordVC)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        recordNC.navigationBar.standardAppearance = appearance
        recordNC.navigationBar.scrollEdgeAppearance = appearance
        
        return recordNC
    }

    private func createLibraryNC() -> UINavigationController {
        let libraryVC = LibraryVC()
        libraryVC.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "music.note.house"), tag: 1)
        
        let libraryNC = UINavigationController(rootViewController: libraryVC)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        libraryNC.navigationBar.standardAppearance = appearance
        libraryNC.navigationBar.scrollEdgeAppearance = appearance
        
        return libraryNC
    }
}
