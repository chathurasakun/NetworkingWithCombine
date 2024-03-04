//
//  CategoryCoordinator.swift
//  TestAPICombine
//
//  Created by CHATHURA ELLAWALA on 2024-03-03.
//

import UIKit

class CategoryCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let categoryListViewModel = CategoryListViewModel(apiClient: ApiClient())
        let categoryListViewController = CategoryListViewController(viewModel: categoryListViewModel)
        categoryListViewController.coordinator = self
        navigationController.pushViewController(categoryListViewController, animated: false)
    }
    
    func goToProductListPage(category: String) {
        let categoryProductsViewModel = CategoryProductsViewModel(apiClient: ApiClient(),
                                                                  category: category)
        let categoryProductsViewController = CategoryProductsViewController(
            viewModel: categoryProductsViewModel
        )
        navigationController.pushViewController(categoryProductsViewController, animated: true)
    }
    
    
}
