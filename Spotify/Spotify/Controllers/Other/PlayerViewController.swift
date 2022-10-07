//
//  PlayerViewController.swift
//  Spotify
//
//  Created by Amir Sajad Nemati on 7/11/22.
//

import UIKit

class PlayerViewController: UIViewController {
    
    private var imageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .blue
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private var controlsView = PlayerControlsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureButtons()
        
        view.addSubview(imageView)
        view.addSubview(controlsView)
        
        controlsView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.width)
        controlsView.frame = CGRect(
            x: 10,
            y: imageView.bottom + 15,
            width: view.width - 20,
            height: view.height  - imageView.height - view.safeAreaInsets.bottom - view.safeAreaInsets.top - 15)
    }

    private func configureButtons(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapAction))
    
    }
    
    @objc private func didTapClose(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapAction(){
        
    }
    
}

extension PlayerViewController: PlayerControlsViewDelgate {
    func didTapPlayPauseButton(_ playerControlsView: PlayerControlsView) {
                
    }
    
    func didTapForwardButton(_ playerControlsView: PlayerControlsView) {
            
    }
    
    func didTapBackwardButton(_ playerControlsView: PlayerControlsView) {
        
    }
    
    
}
