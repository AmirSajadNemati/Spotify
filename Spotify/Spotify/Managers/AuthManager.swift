//
//  AuthManager.swift
//  Spotify
//
//  Created by Amir Sajad Nemati on 7/11/22.
//

import Foundation


final class AuthManager{
    static let shared = AuthManager()
    
    struct Constants{
        static let clientID = "af5eb0bef1ab48c0b706f0669250e832"
        static let clientSecret = "64b9c7fe2b2e4747a341ee1056876f75"
    }
    
    private init() {}
    
    public var signInURL: URL? {
        let scopes = "user-read-private"
        let redirectURI = "https://www.iosacademy.io/"
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(scopes)&redirect_uri=\(redirectURI)&show_dialog=TRUE"
        return URL(string: string)
    }
    
    var isSignedIn: Bool {
        return false
    }
    
    private var accessToken: String? {
        return nil
    }
    
    private var refreshToken: String? {
        return nil
    }
    
    private var tokenExpirationDate: Date? {
        return nil
    }
    
    private var shouldRefreshToken: Bool? {
        return false
    }
    
    public func exchangeCodeForToken(
        code: String,
        completion: ((Bool) -> Void))
    {
            //get token
        }
    public func refreshAccessToken() {
        
    }
    
    public func cacheToken() {
        
    }
}
