//
//  Playlist.swift
//  Spotify
//
//  Created by Amir Sajad Nemati on 7/11/22.
//

import Foundation

struct PlayList: Codable {
    let description: String
    let external_urls: [String: String]
    let name: String
    let images: [APIImages]
    let id: String
    let owner: User
}
