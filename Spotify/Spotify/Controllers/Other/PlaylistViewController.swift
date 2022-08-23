//
//  PlaylistViewController.swift
//  Spotify
//
//  Created by Amir Sajad Nemati on 7/11/22.
//

import UIKit

class PlaylistViewController: UIViewController {

    private let playlist: PlayList
    
    init(playlist: PlayList){
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        APICaller.shared.getPlaylistDetails(for: playlist) { result in
            DispatchQueue.main.async {
                switch result{
                case .success(let model):
                    break
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    

    
}
