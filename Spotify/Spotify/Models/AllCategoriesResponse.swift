//
//  AllCategoriesResponse.swift
//  Spotify
//
//  Created by Amir Sajad Nemati on 9/23/22.
//

import Foundation

struct AllCategoriesResponse: Codable {
    let categories: Categories
}

struct Categories: Codable {
    let items: [Category]
}

struct Category: Codable {
    let id: String
    let name: String
    let icons: [APIImages]
}
