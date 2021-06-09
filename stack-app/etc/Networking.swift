//
//  Networking.swift
//  stack-app
//
//  Created by 김부성 on 2021/06/08.
//

import UIKit
import Alamofire

struct Networking {
    static let SessionManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5
        return Session(configuration: configuration)
    }()
    
    static func post(uri: String, param: Parameters?, header: HTTPHeaders? ,completion: @escaping (Data?, AFError?) -> Void) {
        
        let baseURL = "http://10.80.162.86:3000/v1"
        let url:String = baseURL + uri
        
        SessionManager.request(url, method: .post, parameters: param, headers: header).responseData {
            switch $0.result {
            case .success(let value):
                completion(value, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
