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
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirectURI = "https://www.iosacademy.io/"
        static let scopes  = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
    }
    
    private init() {}
    
    private var isRefreshingToken = false
    
    public var signInURL: URL? {
        
        
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        return URL(string: string)
    }
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    public func exchangeCodeForToken(
        code: String,
        completion: @escaping ((Bool) -> Void))
    {
            //get token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type",
                         value: "authorization_code"),
            URLQueryItem(name: "code",
                         value: code),
            URLQueryItem(name: "redirect_uri",
                         value: Constants.redirectURI),

            
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("failure to get 64base")
            completion(false)
            return
        }
        
        request.setValue("Basic \(base64String) ",
                         forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data,
                    error == nil else {
                        completion(false)
                        return
                  }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                completion(true)
                
            }
            catch{
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    private var onRefreshBlocks = [((String) -> Void)]()
    
    ///Supplies valid  tokens to use with API calls
    public func withValidToken(completion: @escaping (String) -> Void){
        
        guard !isRefreshingToken else{
            //Append the completion
            onRefreshBlocks.append(completion)
            return
        }
        if shouldRefreshToken{
            // Refresh
            refreshTokenIfNeeded(completion: { [weak self] success in
                if let token = self?.accessToken, success {
                    completion(token)
                }
            })
            
        }
        else if let token = accessToken {
            completion(token)
        }
        
    }
    
    public func refreshTokenIfNeeded(completion: ((Bool) -> Void)?) {
        
        guard shouldRefreshToken else {
            completion?(true)
            return
        }
        guard let refreshToken = self.refreshToken else {
            return
        }
        
        //refresh the token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        isRefreshingToken = true
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type",
                         value: "refresh_token"),
            URLQueryItem(name: "refresh_token",
                         value: refreshToken),


            
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("failure to get 64base")
            completion?(false)
            return
        }
        
        request.setValue("Basic \(base64String) ",
                         forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            self?.isRefreshingToken = false
            guard let data = data,
                    error == nil else {
                        completion?(false)
                        return
                  }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.onRefreshBlocks.forEach{ $0(result.access_token) }
                self?.onRefreshBlocks.removeAll()
                self?.cacheToken(result: result)
                completion?(true)
                
                
            }
            catch{
                print(error.localizedDescription)
                completion?(false)
            }
        }
        task.resume()


    }
    
    public func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.access_token,
                                       forKey: "access_token")
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(refresh_token,
                                           forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)),
                                       forKey: "expirationDate")
    }
    
    public func signOut(completion: (Bool) -> Void) {
        UserDefaults.standard.setValue(nil,
                                       forKey: "access_token")
        
        UserDefaults.standard.setValue(nil,
                                       forKey: "refresh_token")
        
        UserDefaults.standard.setValue(nil,
                                       forKey: "expirationDate")
        
        completion(true)
        
    }
}
