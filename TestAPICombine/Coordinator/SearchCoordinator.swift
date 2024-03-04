//
//  SearchCoordinator.swift
//  TestAPICombine
//
//  Created by CHATHURA ELLAWALA on 2024-03-03.
//

import UIKit

class SearchCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let productListViewModel = ProductListViewModel(apiClient: ApiClient())
        let productListViewController = ProductListViewController(viewModel: productListViewModel)
        navigationController.pushViewController(productListViewController, animated: true)
    }
    
    
}
