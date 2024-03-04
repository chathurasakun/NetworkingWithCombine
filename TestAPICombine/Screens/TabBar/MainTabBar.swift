//
//  MainTabBar.swift
//  TestAPICombine
//
//  Created by CHATHURA ELLAWALA on 2024-03-03.
//

import UIKit

class MainTabBar: UITabBarController {
    // MARK: - Varaibles
    weak var coordinator: MainTabCoordinator?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }
    
    deinit {
        print("MainTabBar Deallocated")
    }
    
    // MARK: - SetUp UI
    private func setUpUI() {
        view.backgroundColor = .white
        
        let searchImage = UIImage(systemName: "rectangle.and.text.magnifyingglass") ?? UIImage()
        let productListViewModel = ProductListViewModel(apiClient: ApiClient())
        let productListViewController = ProductListViewController(viewModel: productListViewModel)
        productListViewController.delegate = self
        let searchProductTab = createNavController(vc: productListViewController, title: "Search",
                                                   image: searchImage, tag: 0)
        
        let categoryImage = UIImage(systemName: "bag.fill") ?? UIImage()
        let categoryListViewModel = CategoryListViewModel(apiClient: ApiClient())
        let categoryListViewController = CategoryListViewController(viewModel: categoryListViewModel)
        let categoryTab = createNavController(vc: categoryListViewController, title: "Category",
                                              image: categoryImage, tag: 1)
        
        viewControllers = [searchProductTab, categoryTab]
    }
    
    private func createNavController(vc: UIViewController, title: String,
                                     image: UIImage, tag: Int) -> UINavigationController {
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem = UITabBarItem(title: title, image: image, tag: tag)
        return navController
    }

}

extension MainTabBar: ProductListViewControllerProtocol {
    func logoutFromApp() {
        let loginViewModel = LoginViewModel(apiClient: ApiClient())
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        self.navigationController?.setViewControllers([loginViewController], animated: true)
    }
}
