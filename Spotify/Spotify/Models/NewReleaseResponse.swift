//
//  NewReleaseResponse.swift
//  Spotify
//
//  Created by Amir Sajad Nemati on 7/22/22.
//

import Foundation

struct NewReleaseResponse: Codable {
    let albums: AlbumsResponse
}

struct AlbumsResponse: Codable {
    let items: [Album]
}

struct Album: Codable {
    let album_type: String
    let available_markets: [String]
    let id: String
    var images: [APIImages]
    let name: String
    let release_date: String
    let total_tracks: Int
    let artists: [Artist]
    
}



