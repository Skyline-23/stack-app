//
//  UserRanking.swift
//  stack-app
//
//  Created by 김부성 on 2021/06/08.
//

import Foundation

struct PlusUserRanking: Decodable {
    var code: Int
    var message: String
    var data: [PlusRank]
}

struct MinusUserRanking: Decodable {
    var code: Int
    var message: String
    var data: [MinusRank]
}

struct PlusRank: Decodable {
    var name: String
    var bonus_Point: Int
}

struct MinusRank: Decodable {
    var name: String
    var minus_point: Int
}
