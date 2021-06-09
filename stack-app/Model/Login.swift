//
//  Login.swift
//  stack-app
//
//  Created by 김부성 on 2021/06/08.
//

import Foundation

struct LoginResponse: Decodable {
    var code: Int
    var message: String
    var data: LoginData?
}

struct LoginData: Decodable {
    var token: String
}
