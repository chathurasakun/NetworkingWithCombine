//
//  CategoryListViewModel.swift
//  TestAPICombine
//
//  Created by CHATHURA ELLAWALA on 2024-03-03.
//

import Combine

class CategoryListViewModel: ObservableObject {
    let apiClient: ApiClientProtocol
    var categories: [String] = []
    @Published var categoriesRecieved: Bool!
    private var cancellables: Set<AnyCancellable> = []
    
    init(apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }
    
    func getAllCategories() {
        apiClient.getAllCategories(route: .getAllCategories)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.categoriesRecieved = false
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
            } receiveValue: { [weak self] categories in
                self?.categories = categories
                self?.categoriesRecieved = true
            }
            .store(in: &cancellables)
    }
}
