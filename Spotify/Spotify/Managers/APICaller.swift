//
//  APICaller.swift
//  Spotify
//
//  Created by Amir Sajad Nemati on 7/11/22.
//

import Foundation
import AVFoundation

final class APICaller{
    
    static let shared = APICaller()
    
    
    private init(){}
    
    struct Constants {
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    
    enum APIError: Error{
        case failedToGetData
    }
    
    // MARK : - Get User Profile
    public func getCurrentUserProfile(completion : @escaping (Result<UserProfile, Error>) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/me"),
                      type: .GET) { baseRequest in
            
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data , error == nil else {
                    
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    completion(.success(result))
                }
                catch{
                    print(error)
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    enum HttpMethod: String {
        case POST
        case GET
        case DELETE
        case PUT
    }
    
    
    // MARK : - API Caller Functions
    public func getReccomendations(genres: Set<String>, completion: @escaping ((Result<RecommendationsResponse, Error>) -> Void)) {
        let seeds = genres.joined(separator: ",")
                createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations?seed_genres=\(seeds)&limit=10"),
                              type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                    completion(.success(result))
                }
                catch {
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
            
        }
    }
    
    public func getRecommendedGenres( completion: @escaping (Result<RecommendedGenresResponse, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations/available-genre-seeds"),
                      type: .GET,
                      completion: { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
                    completion(.success(result))
                }
                catch {
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
            
        })
    }
    public func getFeaturedPlaylists(completion: @escaping (Result<FeaturedPlaylistsResponse, Error>) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/featured-playlists?limit=30"),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: data)
                    completion(.success(result))
                }
                catch {
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
            
        }
    
    }
    
    
    
    public func getNewReleases(completion: @escaping (Result<NewReleaseResponse, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/new-releases?limit=30"),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data , error == nil else {

                    completion(.failure(APIError.failedToGetData))
                    return
                }

                do {
                    let result = try JSONDecoder().decode(NewReleaseResponse.self, from: data)
                    //print(result)
                    completion(.success(result))
                }
                catch {
                    print(error.localizedDescription + "newrelease")
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    public func getAlbumDetails(for album: Album, completion: @escaping (Result<AlbumDetailsResponse, Error>) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/albums/" + album.id),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _ , error in
                guard let data = data , error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do{
                    let result = try JSONDecoder().decode(AlbumDetailsResponse.self, from: data)
                    completion(.success(result))
                }
                catch{
                    print(error)
                    completion(.failure(error))
                    
                }
            }
            task.resume()
        }
    }
    
    public func getCurentUserAlbums(completion: @escaping (Result<[Album], Error> ) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/me/albums"),
                      type: .GET) { baseRequest in
            
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data , error == nil else {
                    
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {

                    let result = try JSONDecoder().decode(LibraryAlbumsResponse.self, from: data)
                    completion(.success(result.items.compactMap({ $0.album })))
                }
                catch{
                    
                    print(error)
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    public func saveAlbumInLibrary(album: Album, completion: @escaping(Bool) -> Void ){
        createRequest(with: URL(
            string: Constants.baseAPIURL + "/me/albums?ids=\(album.id)"),
                      type: .PUT) { baseRequest in
            var request = baseRequest
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil,
                      let code = (response as? HTTPURLResponse)?.statusCode else {
                          completion(false)
                          return 
                      }
                
                completion(code == 200)
                      
            }
            task.resume()
        
        }
        
    }
    
    public func getPlaylistDetails(for playlist: PlayList, completion: @escaping (Result<PlaylistDetailsResponse, Error>) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/playlists/" + playlist.id),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _ , error in
                guard let data = data , error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do{
                    let result = try JSONDecoder().decode(PlaylistDetailsResponse.self, from: data)
                    completion(.success(result))
                }
                catch{
                    print(error)
                    completion(.failure(error))
                    
                }
            }
            task.resume()
        }
    }
    
    public func getCurrentUserPlaylists( completion: @escaping (Result<[PlayList], Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/me/playlists/?limit=20"),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(LibraryPlaylistsResponse.self, from: data)
                    completion(.success(result.items))
                } catch {
                    completion(.failure(error))
                }
 
            }
            task.resume()
        }
    }
    public func createPlaylist(name: String, completion: @escaping (Bool) -> Void ){
        getCurrentUserProfile { [weak self] result in
            switch result{
            case .success(let profile):
                let urlString = URL(string: Constants.baseAPIURL + "/users/\(profile.id)/playlists")
                
                self?.createRequest(with: urlString,
                                    type: .POST,
                                    completion: { baseRequest in
                    var request  = baseRequest
                    let json = [
                        "name": name
                    ]
                    request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
                    
                    let task = URLSession.shared.dataTask(with: request) { data, _, error in
                        
                        guard let data = data, error == nil else {
                            completion(false)
                            return
                        }
                        
                        do {
                            let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                            if let response = result as? [String: Any], response["id"] as? String != nil {
                                print("Created!")
                                completion(true)
                            } else {
                                print("Failed to get id.")
                                completion(false)
                            }
                        } catch {
                            print(error.localizedDescription)
                            completion(false)
                        }
                    }
                    task.resume()
                })
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    public func addTrackToPlaylist(track: AudioTrack, playlist: PlayList, completion: @escaping (Bool) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/playlists/\(playlist.id)/tracks"),
                      type: .POST) { baseRequest in
            var request = baseRequest
            let json = [
                "uris" :["spotify:track:\(track.id)"]
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(
                with: request,
                completionHandler: { data, _, error in
                    guard let data = data, error == nil else {
                        print(APIError.failedToGetData )
                        print("addtrack")
                        completion(false)
                        return
                    }
                    do {
                        let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                        if let response = result as? [String: Any],
                           response["snapshot_id"] as? String != nil {
                            completion(true)
                        }
                    } catch {
                        print(error.localizedDescription)
                        completion(false)
                        
                    }
                })
            task.resume()
        }
        
    }
    public func removeTrackFromPLaylist(track: AudioTrack, playlist: PlayList, completion: @escaping (Bool) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/playlists/\(playlist.id)/tracks"),
                      type: .DELETE) { baseRequest in
            var request = baseRequest
            let json = [
                "tracks" :
                    [
                        [
                            "uri": "spotify:track:\(track.id)"
                        ]
                    ]
            ]
            print(json)
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(
                with: request,
                completionHandler: { data, _, error in
                    guard let data = data, error == nil else {
                        print(APIError.failedToGetData)
                        completion(false)
                        return
                    }
                    do {
                        let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                        if let response = result as? [String: Any],
                           response["snapshot_id"] as? String != nil {
                            completion(true)
                        }
                    } catch {
                        print(error.localizedDescription)
                        completion(false)
                        
                    }
                })
            task.resume()
        }
    }
    
    public func getCategories(completion: @escaping (Result<[Category], Error>) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/categories?limit=40"),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(AllCategoriesResponse.self, from: data)
                    //try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    //print(result.categories.items)
                    completion(.success(result.categories.items))
                }
                catch {
                    print(error)
                    print("here too")
                    
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getCategoriesPlaylists(category: Category, completion: @escaping (Result<[PlayList], Error>) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/categories/\(category.id)/playlists?limit=20"),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    
                    return
                }
                do{
                    let result = try JSONDecoder().decode(CategoryPlaylistsResponse.self, from: data)
                    // let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    //print(result)
                    completion(.success(result.playlists.items))
                }
                catch {
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func search(with query: String, completion: @escaping (Result<[SearchResult], Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/search?type=album,artist,playlist,track&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&limit=10"),
                      type: .GET ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(SearchResultResponse.self, from: data)
                    var searchResults : [SearchResult] = []
                    searchResults.append(contentsOf: result.tracks.items.compactMap({.track(model: $0)}))
                    searchResults.append(contentsOf: result.albums.items.compactMap({.album(model: $0)}))
                    searchResults.append(contentsOf: result.playlists.items.compactMap({.playlist(model: $0)}))
                    searchResults.append(contentsOf: result.artists.items.compactMap({.artist(model: $0)}))
                    
                    completion(.success(searchResults))
                }
                catch {
                    print("error here")
                    completion(.failure(error))
                }
            }
            task.resume()
                
                
            }
        }
    
    
    
    // MARK : - Private
    
    
    private func createRequest(with url: URL?,
                               type: HttpMethod,
                               completion: @escaping (URLRequest) -> Void ){
        
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else {
                return
            }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)",
                             forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }        
    }
}
