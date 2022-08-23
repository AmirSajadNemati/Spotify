//
//  AlbumViewController.swift
//  Spotify
//
//  Created by Amir Sajad Nemati on 8/21/22.
//

import UIKit

class AlbumViewController: UIViewController {

    private let album: Album
    
    init(album: Album){
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        APICaller.shared.getAlbumDetails(for: album) { result in
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
