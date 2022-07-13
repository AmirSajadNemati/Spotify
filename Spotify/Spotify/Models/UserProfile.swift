//
//  UserProfile.swift
//  Spotify
//
//  Created by Amir Sajad Nemati on 7/11/22.
//

import Foundation


struct UserProfile: Codable{
    
    let country: String
    let display_name: String
    let email: String
    let explicit_content: [String: Int]
    let external_urls: [String: String]
    //let followers: [String: String]
    let id: String
    let product: String
    let images: [UserImage]

}

struct UserImage: Codable{
    let url: String
}
