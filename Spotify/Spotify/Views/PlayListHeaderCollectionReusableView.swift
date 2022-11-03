//
//  PlayListHeaderCollectionReusableView.swift
//  Spotify
//
//  Created by Amir Sajad Nemati on 9/16/22.
//

import UIKit
import SDWebImage

protocol PlayListHeaderCollectionReusableViewDelegate: AnyObject {
    func PlayListHeaderCollectionReusableViewDidTapPlayAll(_ header: PlayListHeaderCollectionReusableView)
}

final class PlayListHeaderCollectionReusableView: UICollectionReusableView {
      
    static let identifier = "PlayListHeaderCollectionReusableView"
    
    weak var delegate : PlayListHeaderCollectionReusableViewDelegate?
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private var ownerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    private var playAllButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .systemGreen
        button.tintColor = .white
        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular))
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        return button
    }()
    
    // MARK : - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(nameLabel)
        addSubview(ownerLabel)
        addSubview(descriptionLabel)
        addSubview(imageView)
        addSubview(playAllButton)
        playAllButton.addTarget(self,
                                action: #selector(didTapPlayAll),
                                for: .touchUpInside)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc func didTapPlayAll(){
        delegate?.PlayListHeaderCollectionReusableViewDidTapPlayAll(self)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Image View
        let imageSize: CGFloat = height / 1.8
        imageView.frame = CGRect(
            x: (width - imageSize) / 2,
            y: 20,
            width: imageSize,
            height: imageSize
        )
        
        nameLabel.frame = CGRect(
            x: 10,
            y: imageView.bottom,
            width: width - 20,
            height: 44)
        
        descriptionLabel.frame = CGRect(
            x: 10,
            y: nameLabel.bottom ,
            width: width - 20,
            height: 44)
        
        ownerLabel.frame = CGRect(
            x: 10,
            y: descriptionLabel.bottom,
            width: width - 20,
            height: 44)
        
        
        playAllButton.frame = CGRect(
            x: width - 80,
            y: height - 80,
            width: 60,
            height: 60)
    }
    
    func configure(with viewModel: PlayListHeaderViewViewModel){
        nameLabel.text = viewModel.name
        ownerLabel.text = viewModel.ownerName
        descriptionLabel.text = viewModel.description
        imageView.sd_setImage(with: viewModel.artworkURL,placeholderImage: UIImage(systemName: "photo"), completed: nil)
    }
}
