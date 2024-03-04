//
//  LoginViewController.swift
//  TestAPICombine
//
//  Created by CHATHURA ELLAWALA on 2024-03-02.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    // MARK: - Variable
    let viewModel: LoginViewModel!
    private var cancellables: Set<AnyCancellable> = []
    weak var coordinator: AuthCoordinator?
    
    // MARK: - Components
    private let usernameTxtField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        textField.placeholder = "Type Username Here..."
        return textField
    }()
    
    private let passwordTxtField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        textField.placeholder = "Type Password Here..."
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        button.backgroundColor = .black
        return button
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .red
        return label
    }()
    
    init(viewModel: LoginViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        setUpObservers()
    }
    
    deinit {
        print("LoginViewController Deallocated")
    }
    
    // MARK: - Combine Observers
    private func setUpObservers() {
        viewModel.$authenticationSuccess
            .sink { [weak self] success in
                guard let success = success else { return }
                if success {
                    DispatchQueue.main.async {
                        self?.coordinator?.moveToAuthenticatedPath()
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.errorLabel.text = "Invalid credentails"
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - SetUp UI
    private func setUpUI() {
        view.backgroundColor = .blue
        
        view.addSubview(usernameTxtField)
        NSLayoutConstraint.activate([
            usernameTxtField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            usernameTxtField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
            usernameTxtField.heightAnchor.constraint(equalToConstant: 44),
            usernameTxtField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15)
        ])
        usernameTxtField.layer.cornerRadius = 7
        usernameTxtField.delegate = self
        
        view.addSubview(passwordTxtField)
        NSLayoutConstraint.activate([
            passwordTxtField.topAnchor.constraint(equalTo: usernameTxtField.bottomAnchor,
                                                  constant: 10),
            passwordTxtField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
            passwordTxtField.heightAnchor.constraint(equalToConstant: 44),
            passwordTxtField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15)
        ])
        passwordTxtField.layer.cornerRadius = 7
        passwordTxtField.delegate = self
        
        view.addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: passwordTxtField.bottomAnchor,
                                                  constant: 10),
            loginButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
            loginButton.heightAnchor.constraint(equalToConstant: 44),
            loginButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15)
        ])
        loginButton.layer.cornerRadius = 7
        
        loginButton.addTarget(self, action: #selector(onTapLogin(_:)), for: .touchUpInside)
        
        view.addSubview(errorLabel)
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10),
            errorLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
            errorLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15)
        ])
    }
    
    @objc private func onTapLogin(_ sender: UIButton) {
        if !viewModel.password.isEmpty && !viewModel.userName.isEmpty {
            viewModel.loginUser()
        }
    }
}

// MARK: - UITextField Delegates
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let stringValue = textField.text else { return }

        switch textField {
        case usernameTxtField:
            viewModel.userName = stringValue
        case passwordTxtField:
            viewModel.password = stringValue
        default:
            break
        }
    }
}
