//
//  BallData.swift
//  8-Ball
//
//  Created by Tetiana Sierikova on 30.01.2022.
//

import Foundation

struct BallData: Codable {
    let magic: Magic
//    let answer: String
}

struct Magic: Codable {
    var answer: String
}


