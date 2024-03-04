//
//  ProductDetailViewModel.swift
//  TestAPICombine
//
//  Created by CHATHURA ELLAWALA on 2024-03-03.
//

import Combine

class ProductDetailViewModel: ObservableObject {
    let apiClient: ApiClientProtocol
    var product: Product
    @Published var productUpdated: Bool!
    private var cancellables: Set<AnyCancellable> = []
    
    init(apiClient: ApiClientProtocol, product: Product) {
        self.apiClient = apiClient
        self.product = product
    }
    
    func updateProduct() {
        apiClient.updateProduct(route: .updateProduct(product: product))
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.productUpdated = false
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
            } receiveValue: { [weak self] product in
                self?.product = product
                self?.productUpdated = true
            }
            .store(in: &cancellables)
    }

}
