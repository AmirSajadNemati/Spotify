//
//  SearchResult.swift
//  Spotify
//
//  Created by Amir Sajad Nemati on 9/27/22.
//

import Foundation

enum SearchResult {
    case artist(model: Artist)
    case playlist(model: PlayList)
    case album(model: Album)
    case track(model: AudioTrack)
}
