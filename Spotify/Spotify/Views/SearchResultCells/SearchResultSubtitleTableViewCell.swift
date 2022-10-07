//
//  SearchResultSubtitleTableViewCell.swift
//  Spotify
//
//  Created by Amir Sajad Nemati on 10/7/22.
//

import UIKit
import SDWebImage
class SearchResultSubtitleTableViewCell: UITableViewCell {

   static let identifier = "SearchResultSubtitleTableViewCell"
   
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let subtitleLabel: UILabel = {
       let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        
        return label
    }()
    
    private let iconImage: UIImageView = {
        let image = UIImageView()
        
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(iconImage)
        contentView.addSubview(subtitleLabel)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize = contentView.height - 10
        let labelHeight = contentView.height / 2
        
        iconImage.layer.masksToBounds = true
        iconImage.frame = CGRect(x: 5, y: 5 , width: imageSize, height: imageSize)
        label.frame = CGRect(x: imageSize + 10, y: 0, width: contentView.width - iconImage.right - 15, height: labelHeight)
        subtitleLabel.frame = CGRect(x: imageSize + 10, y: label.bottom, width: contentView.width - iconImage.right - 15, height: labelHeight)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        subtitleLabel.text = nil
        iconImage.image = nil
    }
    
    public func configure(with viewModel: SearchResultSubtitleTableViewCellViewModel ){
        label.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        iconImage.sd_setImage(with: viewModel.imageURL, completed: nil)
    }

}
