//
//  Post.swift
//  WhyiOS25
//
//  Created by Hannah Hoff on 3/20/19.
//  Copyright © 2019 Hannah Hoff. All rights reserved.
//

import Foundation

struct Post: Codable {
    var cohort: String
    var name: String
    var reason: String
    
    enum CodingKeys: String, CodingKey {

        case cohort = "cohort"
        case name = "name"
        case reason = "reason"
    }
}
