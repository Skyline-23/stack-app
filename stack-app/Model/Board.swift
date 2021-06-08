//
//  Post.swift
//  stack-app
//
//  Created by 김부성 on 2021/06/08.
//

import Foundation

struct Board: Decodable {
    var code: Int
    var message: String
    var data: [BoardData]
}

struct BoardData: Decodable {
    var idx: Int
    var title: String
    var content: String
    var userId: String
}
