//
//  FeaturedPlaylistsCollectionViewCell.swift
//  Spotify
//
//  Created by Amir Sajad Nemati on 7/22/22.
//

import UIKit

class FeaturedPlaylistsCollectionViewCell: UICollectionViewCell {
 
    static let identifier = "FeaturedPlaylistsCollectionViewCell"

    
    private let playlistCoverImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let playlistNameLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
        
    }()
    
    private let creatorNameLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .thin)
        return label
        
    }()
    
  
    override init(frame: CGRect) {

        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        contentView.addSubview(playlistCoverImageView)
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(creatorNameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Album Cover Image View
        playlistCoverImageView.sizeToFit()
        
        let imageSize =  contentView.height * 2/3
        playlistCoverImageView.frame = CGRect(x: (contentView.width - imageSize) / 2,
                                           y: 5,
                                           width: imageSize,
                                           height: imageSize)
        // Album Name Label
        playlistNameLabel.sizeToFit()
        playlistNameLabel.frame = CGRect(x: 5,
                                      y: playlistCoverImageView.bottom + 5,
                                      width: contentView.width - 10 ,
                                      height: playlistNameLabel.height)

        // Artist Name Label
        creatorNameLabel.sizeToFit()
        creatorNameLabel.frame = CGRect(x: 5,
                                       y: contentView.bottom - 25,
                                       width:contentView.width - 10,
                                       height: creatorNameLabel.height)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playlistNameLabel.text = nil
        creatorNameLabel.text = nil
        playlistCoverImageView.image = nil
    }
    
    func configureViewModel(with viewModel: FeaturedPlaylistViewModel){
        playlistNameLabel.text = viewModel.name
        creatorNameLabel.text = viewModel.creatorName
        playlistCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        
    }
}



