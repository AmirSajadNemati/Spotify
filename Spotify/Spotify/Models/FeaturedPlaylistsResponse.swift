//
//  FeaturedPlaylistsResponse.swift
//  Spotify
//
//  Created by Amir Sajad Nemati on 7/22/22.
//

import Foundation


struct FeaturedPlaylistsResponse: Codable {
    let playlists: PlayListsResponse
}

struct CategoryPlaylistsResponse: Codable {
    let playlists: PlayListsResponse
}

struct PlayListsResponse: Codable {
    let items: [PlayList]

}


struct User: Codable {
    let display_name: String
    let external_urls: [String: String]
    let id: String
}

