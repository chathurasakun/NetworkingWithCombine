//
//  LoginViewModel.swift
//  TestAPICombine
//
//  Created by CHATHURA ELLAWALA on 2024-03-02.
//

import Combine

class LoginViewModel: ObservableObject {
    
    let apiClient: ApiClientProtocol
    var userName: String = "kminchelle"
    var password: String = "0lelplR"
    private var cancellables: Set<AnyCancellable> = []
    @Published var authenticationSuccess: Bool!
    
    init(apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }
    
    func loginUser() {
        let credentials = LoginRequest(username: userName, password: password)
        apiClient.loginUser(route: .authenticate(credentials: credentials))
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.authenticationSuccess = false
                    if let code = error.responseCode {
                        print("code ", code)
                    }
                    if error.isSessionTaskError {
                        print("session Tak error")
                    }
                    if error.isResponseSerializationError {
                        print("serialization error")
                    }
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                print("login response ",response)
                self?.authenticationSuccess = true
            }
            .store(in: &cancellables)
    }

}
