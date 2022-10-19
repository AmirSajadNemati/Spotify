//
//  PlayerViewController.swift
//  Spotify
//
//  Created by Amir Sajad Nemati on 7/11/22.
//

import UIKit
import SDWebImage

protocol PlayerViewControllerDelegate: AnyObject {
    func didTapForward()
    func didTapBackward()
    func didTapPlayPause()
    func didSlideSlider(_ value: Float)
}

class PlayerViewController: UIViewController {
    
    weak var dataSource: PlayerDataSource?
    weak var delegate: PlayerViewControllerDelegate?
    
    
    
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
        
        configure()
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
    
    private func configure(){
        imageView.sd_setImage(with: dataSource?.imageURL, completed: nil)
        controlsView.configure(with: PlayerControlsViewViewModel(
            title: dataSource?.songName ?? "",
            subtitle: dataSource?.subtitle ?? ""))
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
    func playerControlView(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float) {
        delegate?.didSlideSlider(value)
    }
    
    func didTapPlayPauseButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapPlayPause()
    }
    
    func didTapForwardButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapForward()
    }
    
    func didTapBackwardButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapBackward()
    }
    
    
}
