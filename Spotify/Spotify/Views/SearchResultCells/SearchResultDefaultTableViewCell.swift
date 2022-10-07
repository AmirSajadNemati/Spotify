//
//  SearchResultDefaultTableViewCell.swift
//  Spotify
//
//  Created by Amir Sajad Nemati on 10/7/22.
//

import UIKit
import SDWebImage



class SearchResultDefaultTableViewCell: UITableViewCell {
    
    static let identifier = "SearchResultDefaultTableViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
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
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize = contentView.height - 10
        iconImage.layer.cornerRadius = imageSize / 2
        iconImage.layer.masksToBounds = true
        iconImage.frame = CGRect(x: 5, y: 5 , width: imageSize, height: imageSize)
        label.frame = CGRect(x: imageSize + 10, y: 0, width: contentView.width - iconImage.right - 15, height: contentView.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        iconImage.image = nil
    }
    
    public func configure(with viewModel: SearchResultDefaultTableViewCellViewModel ){
        label.text = viewModel.title
        iconImage.sd_setImage(with: viewModel.imageURL, completed: nil)
    }
    
    
}
