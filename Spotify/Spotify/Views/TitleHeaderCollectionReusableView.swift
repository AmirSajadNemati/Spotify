//
//  TitleHeaderCollectionReusableView.swift
//  Spotify
//
//  Created by Amir Sajad Nemati on 9/16/22.
//

import UIKit

class TitleHeaderCollectionReusableView: UICollectionReusableView {
        
    static let identifier = "TitleHeaderCollectionReusableView"
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        label.frame = CGRect(
            x: 15,
            y: 0,
            width: width - 30,
            height: height)
    }
    
    func configure(with title: String){
        label.text = title
    }
    
    
}
