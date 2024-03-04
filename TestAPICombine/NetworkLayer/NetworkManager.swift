//
//  NetworkManager.swift
//  TestAPICombine
//
//  Created by CHATHURA ELLAWALA on 2024-02-29.
//

import Foundation
import Alamofire

protocol ApiConfiguartion: URLRequestConvertible {
    var method: HTTPMethod { get }
    var baseUrl: String { get }
    var endPoint: String { get }
    var parameters: Parameters? { get }
    
    func asURLRequest() throws -> URLRequest
}

enum APIRouter: ApiConfiguartion {
    case authenticate(credentials: LoginRequest)
    case getTodos(_ params: Parameters)
    case getAllProducts
    case getAllCategories
    case getProductsForCategory(category: String)
    case getProductById(productId: Int)
    case searchProduct(_ params: Parameters)
    case updateProduct(product: Product)
    
    /// Set Method
    var method: HTTPMethod {
        switch self {
        case .getTodos:
            return .get
        case .getProductById(_):
            return .get
        case .authenticate(_):
            return .post
        case .getAllProducts:
            return .get
        case .searchProduct(_):
            return .get
        case .getAllCategories:
            return .get
        case .getProductsForCategory(_):
            return .get
        case .updateProduct(_):
            return .patch
        }
    }
    
    /// Set Base URL
    var baseUrl: String {
//        return "https://api.github.com/"
        return "https://dummyjson.com/"
    }
    
    /// End Points
    var endPoint: String {
        switch self {
        case .getTodos:
            return "search/repositories"
        case .getProductById(productId: let productId):
            return "products/\(productId)"
        case .authenticate(_):
            return "auth/login"
        case .getAllProducts:
            return "products"
        case .searchProduct(_):
            return "products/search"
        case .getAllCategories:
            return "products/categories"
        case .getProductsForCategory(category: let category):
            return "products/category/\(category)"
        case .updateProduct(product: let product):
            if let id = product.id {
                return "products/\(id)"
            }
            return ""
        }
    }
    
    /// Parameters
    var parameters: Parameters? {
        switch self {
        case .getTodos(let getRepoRequest):
            return getRepoRequest
        case .searchProduct(let getProductRequest):
            return getProductRequest
        default:
            return nil
        }
    }
    
    /// URLRequest Convertible
    func asURLRequest() throws -> URLRequest {
        let fullPath = baseUrl + endPoint
        let url = try fullPath.asURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        
        if let parameters = parameters {
            switch self {
            case .getTodos:
                return try URLEncoding.default.encode(urlRequest, with: parameters)
            case .searchProduct:
                return try URLEncoding.default.encode(urlRequest, with: parameters)
            default:
                break
            }
        }
        
        switch self {
        case .authenticate(let credentials):
            urlRequest.httpBody = try JSONEncoder().encode(credentials)
        case .getProductById(productId: _), .getAllProducts, .getAllCategories,
                .getProductsForCategory(category: _):
            return try URLEncoding.default.encode(urlRequest, with: nil)
        case .updateProduct(let product):
            urlRequest.httpBody = try JSONEncoder().encode(product)
        default:
            break
        }
        
        return urlRequest
    }
}
