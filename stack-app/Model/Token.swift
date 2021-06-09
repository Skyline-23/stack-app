//
//  Token.swift
//  stack-app
//
//  Created by 김부성 on 2021/06/09.
//

import Foundation

struct Token {
    static var shared = Token()
    var token: String?
}
