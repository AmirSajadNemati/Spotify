//
//  PlayerControlsView.swift
//  Spotify
//
//  Created by Amir Sajad Nemati on 10/7/22.
//

import Foundation
import UIKit

struct PlayerControlsViewViewModel {
    let title: String
    let subtitle: String
}

protocol PlayerControlsViewDelgate: AnyObject {
    func didTapPlayPauseButton(_ playerControlsView: PlayerControlsView)
    func didTapForwardButton(_ playerControlsView: PlayerControlsView)
    func didTapBackwardButton(_ playerControlsView: PlayerControlsView)
    func playerControlView(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float)
}
final class  PlayerControlsView : UIView {
     
    weak var delegate : PlayerControlsViewDelgate?
    
    private var isPlaying = true
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Raha"
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.numberOfLines = 1
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Mehrad Hidden (ft. Arash Dara)"
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    private let playPauseButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(
            systemName: "pause",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let forwardButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(
            systemName: "forward.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    private let backwardButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(
            systemName: "backward.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    private let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        return slider
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        addSubview(playPauseButton)
        addSubview(forwardButton)
        addSubview(backwardButton)
        
        addSubview(volumeSlider)
        
        volumeSlider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged)
        
        clipsToBounds = true
        
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(didTapForward), for: .touchUpInside)
        backwardButton.addTarget(self, action: #selector(didTapBackward), for: .touchUpInside)
    }
    
    @objc func didSlideSlider(_ slider: UISlider) {
        let value = slider.value
        delegate?.playerControlView(self, didSlideSlider: value)
    }

    @objc private func didTapPlayPause(){
        delegate?.didTapPlayPauseButton(self)
        self.isPlaying = !isPlaying
        
        let pause = UIImage(
            systemName: "pause",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        
        let play = UIImage(
            systemName: "play.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        
        playPauseButton.setImage(isPlaying ? pause : play, for: .normal)
    }
    
    @objc private func didTapForward(){
        delegate?.didTapForwardButton(self)
    }
    
    @objc private func didTapBackward(){
        delegate?.didTapBackwardButton(self)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = CGRect(x: 5, y: 0, width: width - 10, height: 50)
        subtitleLabel.frame = CGRect(x: 5, y: titleLabel.bottom + 10, width: width - 10, height: 50)
        
        volumeSlider.frame = CGRect(x: 10, y: subtitleLabel.bottom + 20, width: width - 20, height: 44)
        
        let buttonSize: CGFloat = 60
        // PlayPause
        playPauseButton.frame = CGRect(
            x: (width - buttonSize)/2,
            y: volumeSlider.bottom + 30,
            width: buttonSize, height: buttonSize)
        // Forward
        forwardButton.frame = CGRect(
            x: playPauseButton.right + 60 - buttonSize,
            y: volumeSlider.bottom + 30,
            width: buttonSize, height: buttonSize)
        // Backward
        backwardButton.frame = CGRect(
            x: playPauseButton.left - 60,
            y: volumeSlider.bottom + 30,
            width: buttonSize, height: buttonSize)
    }
    
    func configure(with viewModel: PlayerControlsViewViewModel){
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
    }
}
