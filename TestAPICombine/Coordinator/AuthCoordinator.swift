//
//  AuthCoordinator.swift
//  TestAPICombine
//
//  Created by CHATHURA ELLAWALA on 2024-03-03.
//

import UIKit

class AuthCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loginViewModel = LoginViewModel(apiClient: ApiClient())
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        loginViewController.coordinator = self
        navigationController.pushViewController(loginViewController, animated: true)
    }
    
    func moveToAuthenticatedPath() {
        let mainTabCoordinator = MainTabCoordinator(navigationController: navigationController)
        mainTabCoordinator.start()
    }
    
}
