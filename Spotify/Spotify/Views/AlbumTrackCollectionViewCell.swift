//
//  AlbumTrackCollectionViewCell.swift
//  Spotify
//
//  Created by Amir Sajad Nemati on 9/16/22.
//


import Foundation
import UIKit

class AlbumTrackCollectionViewCell: UICollectionViewCell {
                    
    static let identifier = "AlbumTrackCollectionViewCell"
    
    
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
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Album Cover Image View
        
        
        let imageSize =  contentView.height - 3

        // Album Name Label
        trackNameLabel.sizeToFit()
        trackNameLabel.frame = CGRect(x: 5,
                                      y: contentView.top + 5,
                                      width: contentView.width - imageSize - 5 ,
                                      height: trackNameLabel.height)

        // Artist Name Label
        artistNameLabel.sizeToFit()
        artistNameLabel.frame = CGRect(x: 5,
                                       y: trackNameLabel.bottom + 5,
                                       width: contentView.width - (imageSize * 2) - 5,
                                       height: artistNameLabel.height)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = nil
        artistNameLabel.text = nil
    }
    
    func configureViewModel(with viewModel: AlbumTrackCollectionCellViewModel){
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        
    }
}





