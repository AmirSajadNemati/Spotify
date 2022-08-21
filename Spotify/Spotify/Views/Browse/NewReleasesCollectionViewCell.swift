//
//  NewReleasesCollectionViewCell.swift
//  Spotify
//
//  Created by Amir Sajad Nemati on 7/22/22.
//

import UIKit
import SDWebImage

class NewReleasesCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewReleasesCollectionViewCell"
    
    private let albumCoverImageView : UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let albumNameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
        
    }()
    
    private let artistNameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .thin)
        return label
        
    }()
    
    private let numberOfTracksLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
        
    }()
    
    override init(frame: CGRect) {

        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(numberOfTracksLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Album Cover Image View
        albumCoverImageView.sizeToFit()
        
        let imageSize = contentView.height - 10
        albumCoverImageView.frame = CGRect(x: 5,
                                           y: 5,
                                           width: imageSize,
                                           height: imageSize)
        // Album Name Label
        albumNameLabel.sizeToFit()
        albumNameLabel.frame = CGRect(x: albumCoverImageView.right + 10,
                                      y: contentView.top + 5,
                                      width: contentView.width - albumCoverImageView.width - 20,
                                      height: albumNameLabel.height)

        // Artist Name Label
        artistNameLabel.sizeToFit()
        artistNameLabel.frame = CGRect(x: albumCoverImageView.right + 10,
                                       y: albumNameLabel.height + 5,
                                       width: contentView.width - albumCoverImageView.width - 20,
                                       height: artistNameLabel.height)
        
        // Number of tracks label
        numberOfTracksLabel.sizeToFit()
        numberOfTracksLabel.frame = CGRect(x: albumCoverImageView.right + 10,
                                           y: contentView.bottom - 30 ,
                                           width: numberOfTracksLabel.width,
                                           height: numberOfTracksLabel.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        numberOfTracksLabel.text = nil
        albumCoverImageView.image = nil
    }
    
    func configureViewModel(with viewModel: NewReleaseCellViewModel){
        albumNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        numberOfTracksLabel.text = "Tracks: \(viewModel.numberOfTracks)"
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        
    }
}


