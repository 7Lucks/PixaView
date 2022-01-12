//
//  ApiResponse.swift
//  PixaView
//
//  Created by Дмитрий Игнатьев on 28.11.2021.
//

import UIKit


struct ImageAPIResponse: Codable{
    let total: Int
    let totalHits: Int
    let hits: [Hits]
}

struct Hits: Codable{
    let id: Int
    let webformatURL: String
    let tags: String
}

