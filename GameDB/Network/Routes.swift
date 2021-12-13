//
//  Routes.swift
//  GameDB
//
//  Created by Can Tekinalp on 12.12.2021.
//

import Alamofire

let baseURL = "https://api.rawg.io/api"

enum ApiRoutes {
    case getList
    case getDetails(gameId: Int)
    case raw(String)
    
    var path: String {
        switch self {
        case .getList:
            return "/games"
        case .getDetails(let gameId):
            return "/games/\(gameId)"
        default:
            return ""
        }
    }
    
    var urlString: String {
        switch self {
        case .raw(let url):
            return url
        default:
            return "\(baseURL)\(path)"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var encoding: ParameterEncoding {
        switch self {
        default:
            return URLEncoding.default
        }
    }
    
    var headers: HTTPHeaders {
        return HTTPHeaders.default
    }
    
    func buildRequest(parameters: [String: Any]) -> URLRequest? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        headers.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.name) }
        var passedParameters = parameters
        passedParameters["key"] = apiKey
        return try? encoding.encode(urlRequest, with: passedParameters)
    }
}
