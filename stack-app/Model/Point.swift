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
    var data: [PointData]
}

struct PointData: Decodable {
    var type: Int
    var score: Int
    var reason: String
}
