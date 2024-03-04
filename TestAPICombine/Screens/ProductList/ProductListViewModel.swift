//
//  ProductListViewModel.swift
//  TestAPICombine
//
//  Created by CHATHURA ELLAWALA on 2024-02-29.
//
import Foundation
import Combine

class ProductListViewModel: ObservableObject {
    let apiClient: ApiClientProtocol
    private var cancellables: Set<AnyCancellable> = []
    @Published var productsRecieved: Bool!
    let perPage = 10
    var currentPage = 1
    var searchQuery = "Q"
    var repoList: [Repo] = []
    var products: [Product] = []
    
    init(apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }
    
    func getRepoList() {
        let repoRequest = GetRepoRequest(q: searchQuery, per_page: perPage, page: currentPage)
        let repoRequestDictionary = repoRequest.toDictionary()
        apiClient.getTodoList(route: .getTodos(repoRequestDictionary))
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
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
            } receiveValue: { [weak self] repos in
                self?.repoList = repos.items
            }
            .store(in: &cancellables)
    }
    
    func getAllProducts() {
        apiClient.getAllProducts(route: .getAllProducts)
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
    
    func getProductById(productId: Int) {
        apiClient.getProductById(route: .getProductById(productId: productId))
            .sink { [weak self] completion in
                // handle error
            } receiveValue: { [weak self] product in
                self?.products.append(product)
            }
            .store(in: &cancellables)
    }
    
    func searchProduct(queryString: String) {
        let searchProductQueryParams = ["q": queryString]
        apiClient.searchProduct(route: .searchProduct(searchProductQueryParams))
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
