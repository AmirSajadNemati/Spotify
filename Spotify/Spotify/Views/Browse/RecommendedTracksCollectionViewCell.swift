//
//  RecommendedTracksCollectionViewCell.swift
//  Spotify
//
//  Created by Amir Sajad Nemati on 7/22/22.
//

import UIKit

class RecommendedTracksCollectionViewCell: UICollectionViewCell {
                	
    static let identifier = "RecommendedTracksCollectionViewCellbr"
    
    private let trackCoverImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let trackNameLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        //label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
        
    }()
    
    private let artistNameLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .thin)
        return label
        
    }()
    
  
    override init(frame: CGRect) {

        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        contentView.addSubview(trackCoverImageView)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Album Cover Image View
        trackCoverImageView.sizeToFit()
        
        let imageSize =  contentView.height - 3
        trackCoverImageView.frame = CGRect(x: 1/5,
                                           y: 1.5,
                                           width: imageSize,
                                           height: imageSize)
        // Album Name Label
        trackNameLabel.sizeToFit()
        trackNameLabel.frame = CGRect(x: trackCoverImageView.right + 5,
                                      y: contentView.top + 5,
                                      width: contentView.width - imageSize - 5 ,
                                      height: trackNameLabel.height)

        // Artist Name Label
        artistNameLabel.sizeToFit()
        artistNameLabel.frame = CGRect(x: trackCoverImageView.right + 5,
                                       y: trackNameLabel.bottom + 5,
                                       width: contentView.width - (imageSize * 2) - 5,
                                       height: artistNameLabel.height)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = nil
        artistNameLabel.text = nil
        trackCoverImageView.image = nil
    }
    
    func configureViewModel(with viewModel: RecommendedTrackViewModel){
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        trackCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        
    }
}




