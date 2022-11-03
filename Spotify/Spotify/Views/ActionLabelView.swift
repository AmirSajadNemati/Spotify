//
//  ActionLabelView.swift
//  Spotify
//
//  Created by Amir Sajad Nemati on 10/31/22.
//

import UIKit


struct ActionLabelViewViewModel {
    let text: String
    let actionTitle: String
}

protocol ActionLabelViewDelegate: AnyObject {
    func ActionLabelViewDidTapButton(_ actionViewLabel: ActionLabelView)
}

class ActionLabelView: UIView {

    weak var delegate: ActionLabelViewDelegate?
    
    private var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()
    
    private var actionButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        
        return button
        
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        
        addSubview(label)
        addSubview(actionButton)
        
        
        actionButton.addTarget(self, action: #selector(didTapAcitonButton), for: .touchUpInside)
    }
    
    @objc func didTapAcitonButton(){
        delegate?.ActionLabelViewDidTapButton(self)
        
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        actionButton.frame = CGRect(x: 0,
                                    y: height - 40,
                                    width: width,
                                    height: 40)
        label.frame = CGRect(x: 0,
                             y: 0,
                             width: width,
                             height: height - 45)
    }
    
    func configure(with viewModel: ActionLabelViewViewModel){
        label.text = viewModel.text
        actionButton.setTitle(viewModel.actionTitle, for: .normal)
        
    }

}
