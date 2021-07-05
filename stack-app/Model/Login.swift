//
//  Login.swift
//  stack-app
//
//  Created by 김부성 on 2021/06/08.
//

import Foundation
import Alamofire
import RxSwift

struct LoginResponse: Decodable {
    var code: Int
    var message: String
    var data: LoginData?
}

struct LoginData: Decodable {
    var token: String
}

struct User: Codable {
    let name: String
}

enum LoginError: Error {
    case defaultError
    case error(code: Int)
    
    var msg: String {
        switch self {
        case .defaultError:
            return "ERROR"
        case .error(let code):
            return "\(code) Error"
        }
    }
}

struct LoginModel {
    
    func requestLogin(id: String, pw: String) -> Observable<Result<LoginResponse, LoginError>> {
        return Observable.create { (observer) -> Disposable in
            
            // 파라미터
            let param: Parameters = [
                "id": id,
                "pw": pw
            ]
            
            Networking.post(uri: "/auth/login", param: param, header: nil) { error, data in
                // 정상
                if (error == nil) {
                    let decoder = JSONDecoder()
                    let jsonData = try? decoder.decode(LoginResponse.self, from: data!)
                    switch jsonData?.code {
                    case 200:
                        Token.shared.token = jsonData?.data?.token
                        observer.onNext(.success(jsonData!))
                    case 401, 404:
                        observer.onNext(.failure(.error(code: jsonData!.code)))
                    default:
                        observer.onNext(.failure(.defaultError))
                    }
                } else { // 네트워킹 실패
                    observer.onNext(.failure(.defaultError))
                    print(error!)
                }
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
}
