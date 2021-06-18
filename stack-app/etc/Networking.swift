//
//  Networking.swift
//  stack-app
//
//  Created by 김부성 on 2021/06/08.
//

import UIKit

import Alamofire

protocol NetworkingProtocol {
    static func get(uri: String, param: Parameters?, header: HTTPHeaders?, completion: @escaping (AFError?, Data?) -> Void) -> Void
}

struct Networking: NetworkingProtocol {
    
    static let SessionManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5
        return Session(configuration: configuration)
    }()
    
    static let baseURL = "http://10.80.162.86:3000/v1"
    
    static func post(uri: String, param: Parameters?, header: HTTPHeaders?, completion: @escaping (AFError?, Data?) -> Void) {
        
        let url: String = baseURL + uri
        
        SessionManager.request(url, method: .post, parameters: param, headers: header).responseData {
            switch $0.result {
            case .success(let value):
                completion(nil, value)
            case .failure(let error):
                completion(error, nil)
            }
        }
    }
    
    static func get(uri: String, param: Parameters?, header: HTTPHeaders?, completion: @escaping (AFError?, Data?) -> Void) {
        let url: String = baseURL + uri
        
        SessionManager.request(url, method: .get, parameters: param, headers: header).responseData {
            switch $0.result {
            case .success(let value):
                completion(nil, value)
            case .failure(let error):
                completion(error, nil)
            }
        }
    }
}

class NetworkingMock: NetworkingProtocol {
    
    static func get(uri: String, param: Parameters?, header: HTTPHeaders?, completion: @escaping (AFError?, Data?) -> Void) {
        let filename = "MockPoint.json"
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }
        do {
            let data = try Data(contentsOf: file)
            completion(nil, data)
        } catch let error {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
    }
}
