//
//  LibraryAlbumsResponse.swift
//  Spotify
//
//  Created by Amir Sajad Nemati on 11/4/22.
//

import Foundation

struct LibraryAlbumsResponse: Codable {
    let items: [SavedAlbum]
}

struct SavedAlbum: Codable {
    let added_at: String
    let album: Album
}
