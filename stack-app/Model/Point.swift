//
//  Point.swift
//  stack-app
//
//  Created by 김부성 on 2021/06/08.
//

import Foundation

struct Point: Decodable {
    var code: Int
    var message: String
    var data: PointData
}

struct PointData: Decodable {
    var user: [UserData]
    var score: [ScoreData]
}

struct UserData: Decodable {
    var name: String
    var number: Int
}

struct ScoreData: Decodable {
    var type: Int
    var score: Double
    var reason: String
    var created_at: String
}
