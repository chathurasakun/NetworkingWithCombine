//
//  ApiClient.swift
//  TestAPICombine
//
//  Created by CHATHURA ELLAWALA on 2024-02-29.
//

import Foundation
import Combine
import Alamofire

protocol ApiClientProtocol {
    func loginUser(route: APIRouter) -> AnyPublisher<LoginResponse, AFError>
    func getTodoList(route: APIRouter) -> AnyPublisher<Repos, AFError>
    func getAllProducts(route: APIRouter) -> AnyPublisher<ProductResponse, AFError>
    func getAllCategories(route: APIRouter) -> AnyPublisher<[String], AFError>
    func getProductsForCategory(route: APIRouter) -> AnyPublisher<ProductResponse, AFError>
    func getProductById(route: APIRouter) -> AnyPublisher<Product, AFError>
    func searchProduct(route: APIRouter) -> AnyPublisher<ProductResponse, AFError>
    func updateProduct(route: APIRouter) -> AnyPublisher<Product, AFError>
}

class ApiClient: ApiClientProtocol {
    func loginUser(route: APIRouter) -> AnyPublisher<LoginResponse, AFError> {
        return AF.request(route)
            .validate()
            .publishDecodable(type: LoginResponse.self)
            .value()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getAllProducts(route: APIRouter) -> AnyPublisher<ProductResponse, AFError> {
        return AF.request(route)
            .validate()
            .publishDecodable(type: ProductResponse.self)
            .value()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getAllCategories(route: APIRouter) -> AnyPublisher<[String], AFError> {
        return AF.request(route)
            .validate()
            .publishDecodable(type: [String].self)
            .value()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getProductsForCategory(route: APIRouter) -> AnyPublisher<ProductResponse, AFError> {
        return AF.request(route)
            .validate()
            .publishDecodable(type: ProductResponse.self)
            .value()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getTodoList(route: APIRouter) -> AnyPublisher<Repos, AFError> {
        return AF.request(route)
            .validate()
            .publishDecodable(type: Repos.self)
            .value()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getProductById(route: APIRouter) -> AnyPublisher<Product, AFError> {
        return AF.request(route)
            .validate()
            .publishDecodable(type: Product.self)
            .value()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func searchProduct(route: APIRouter) -> AnyPublisher<ProductResponse, AFError> {
        return AF.request(route)
            .validate()
            .publishDecodable(type: ProductResponse.self)
            .value()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func updateProduct(route: APIRouter) -> AnyPublisher<Product, AFError> {
        return AF.request(route)
            .validate()
            .publishDecodable(type: Product.self)
            .value()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
