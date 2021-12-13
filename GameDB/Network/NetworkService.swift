//
//  NetworkService.swift
//  GameDB
//
//  Created by Can Tekinalp on 12.12.2021.
//

import Alamofire

let unexpectedError = "Beklenmedik bir hata oluştu."

extension String: Error {}

final class NetworkService {
    
    @discardableResult
    static func request<T: Decodable>(decodable : T.Type, route: ApiRoutes, parameters: [String: String], handler: @escaping (Result<T, String>) -> Void) -> DataRequest? {

        guard let request = route.buildRequest(parameters: parameters) else {
            handler(.failure(unexpectedError))
            return nil
        }
    
        return AF.request(request).validate().responseDecodable(of: T.self) { (dataResponse) in
            switch dataResponse.result {
            case .success(let response):
                handler(.success(response))
            case .failure:
                handler(.failure(unexpectedError))
            }
        }
    }
    
}
