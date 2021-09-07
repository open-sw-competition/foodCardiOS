//
//  JSONModel.swift
//  FoodVoucher
//
//  Created by 임명심 on 2021/09/01.
//

import Foundation

struct Result: Codable {
    let data: [StoreItem]
}

struct StoreItem: Codable {
    let mrhstNm: String
    let latitude: String
    let longitude: String
    let phoneNumber: String
    let id: String
    let rating: Int
}
