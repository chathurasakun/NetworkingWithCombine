//
//  CategoryProductsViewModel.swift
//  TestAPICombine
//
//  Created by CHATHURA ELLAWALA on 2024-03-03.
//

import Combine

class CategoryProductsViewModel: ObservableObject {
    let apiClient: ApiClientProtocol
    private var cancellables: Set<AnyCancellable> = []
    @Published var productsRecieved: Bool!
    let category: String!
    var products: [Product] = []
    
    init(apiClient: ApiClientProtocol, category: String) {
        self.apiClient = apiClient
        self.category = category
    }
    
    func getProductsOfCategory() {
        apiClient.getProductsForCategory(route: .getProductsForCategory(category: category))
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.productsRecieved = false
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
                guard let products = response.products else {
                    self?.productsRecieved = false
                    return
                }
                self?.products = products
                self?.productsRecieved = true
            }
            .store(in: &cancellables)
    }

}
