//
//  LibraryToggleView.swift
//  Spotify
//
//  Created by Amir Sajad Nemati on 10/30/22.
//

import UIKit

protocol LibraryToggleViewDelegate: AnyObject {
    func LibraryToggleViewDidTapPlaylists(_ toggleView: LibraryToggleView)
    func LibraryToggleViewDidTapAlbums(_ toggleView: LibraryToggleView)
}

class LibraryToggleView: UIView {

    // MARK : - Properties & SubViews
    enum State {
        case playlist
        case album
    }
    var state: State = .playlist
    
    weak var delegate: LibraryToggleViewDelegate?
    private let playlistsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Playlists", for: .normal)
        
        return button
    }()
    
    private let albumsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Albums", for: .normal)
        
        return button
    }()
    
    private var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    // MARK : - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(playlistsButton)
        addSubview(albumsButton)
        addSubview(indicatorView)
        
        
        playlistsButton.addTarget(self, action: #selector(didTapPlaylists), for: .touchUpInside)
        albumsButton.addTarget(self, action: #selector(didTapAlbums), for: .touchUpInside)
        
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playlistsButton.frame = CGRect(x: 0,
                                       y: 0,
                                       width: 100,
                                       height: 40)
        
        albumsButton.frame = CGRect(x: 100,
                                    y: 0,
                                    width: 100,
                                    height: 40)
        layoutIndicator()
    }
    
    // OBJ-C Funcitons
    @objc func didTapPlaylists(){
        delegate?.LibraryToggleViewDidTapPlaylists(self)
        state = .playlist
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
    }
    
    @objc func didTapAlbums(){
        delegate?.LibraryToggleViewDidTapAlbums(self)
        state = .album
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
    }
    
    private func layoutIndicator(){
        switch state {
        case .playlist:
            indicatorView.frame = CGRect(x: 0, y: playlistsButton.bottom, width: 100, height: 3)
        case .album:
            indicatorView.frame = CGRect(x: playlistsButton.width, y: albumsButton.bottom, width: 100, height: 3)
        }
    }
    
    func update(for state: State){
        self.state = state
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
    }
}
