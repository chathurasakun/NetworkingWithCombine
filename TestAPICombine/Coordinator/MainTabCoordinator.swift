//
//  MainTabCoordinator.swift
//  TestAPICombine
//
//  Created by CHATHURA ELLAWALA on 2024-03-03.
//

import UIKit

class MainTabCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let mainTabBar = UITabBarController()
        navigationController.isNavigationBarHidden = true
        
        let searchCoordinator = SearchCoordinator(navigationController: UINavigationController())
        let searchImage = UIImage(systemName: "rectangle.and.text.magnifyingglass") ?? UIImage()
        let searchNavController = setNavigationController(title: "Search", image: searchImage,
                                                          child: searchCoordinator, tag: 0)
        
        let categoryCoordinator = CategoryCoordinator(navigationController: UINavigationController())
        let categoryImage = UIImage(systemName: "bag.fill") ?? UIImage()
        let categoryNavController = setNavigationController(title: "Category", image: categoryImage,
                                                            child: categoryCoordinator, tag: 1)
        
        mainTabBar.viewControllers = [searchNavController, categoryNavController]
        navigationController.setViewControllers([mainTabBar], animated: false)
        
    }
    
    private func setNavigationController(title: String, image: UIImage,
                                         child: Coordinator, tag: Int) -> UINavigationController {
        childCoordinators.append(child)
        child.start()
        
        let navController = child.navigationController
        navController.tabBarItem = UITabBarItem(title: title, image: image, tag: tag)
        return navController
    }
    
    
}
