//
//  SettingsModel.swift
//  Spotify
//
//  Created by Amir Sajad Nemati on 7/15/22.
//

import Foundation


struct Section {
    let title: String
    let options: [Option]
}

struct Option{
    let title: String
    let handler: () -> Void
}
