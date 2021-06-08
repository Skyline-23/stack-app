//
//  Networking.swift
//  stack-app
//
//  Created by 김부성 on 2021/06/08.
//

import UIKit
import Alamofire

struct Networking {
    static func network(uri: String, param: Parameters?, header: HTTPHeaders? ,completion: @escaping (Data) -> Void) throws {
            let baseURL = "http://10.80.162.86:3000/"
            let url:String = baseURL + uri
            var APIError: Error?
            
            AF.request(url, method: .get, parameters: param, headers: header).responseJSON {
                switch $0.result {
                case .success(let value):
                    completion(value as! Data)
                case .failure(let error):
                    APIError = error
                }
            }
            if APIError != nil {
                throw APIError!
            }
    }
}
