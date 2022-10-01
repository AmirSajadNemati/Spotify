//
//  SearchResultResponse.swift
//  Spotify
//
//  Created by Amir Sajad Nemati on 9/27/22.
//

import Foundation

struct SearchResultResponse: Codable {
    let playlists: SearchPlaylistsResponse
    let artists: SearchArtistsResponse
    let albums: SearchAlbumsResponse
    let tracks: SearchTracksResponse
}

struct SearchPlaylistsResponse: Codable {
    let items : [PlayList]
}

struct SearchArtistsResponse: Codable {
    let items : [Artist]
}

struct SearchAlbumsResponse: Codable {
    let items : [Album]
}
	
struct SearchTracksResponse: Codable {
    let items : [AudioTrack]
}
