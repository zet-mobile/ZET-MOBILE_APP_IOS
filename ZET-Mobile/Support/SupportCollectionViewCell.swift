//
//  SupportCollectionViewCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 06/04/22.
//

import UIKit

class SupportCollectionViewCell: UICollectionViewCell {
    
    lazy var button: UIButton = {
        let button = UIButton(frame: CGRect(x: 10, y: 0, width: 40, height: 40))
        button.setImage(UIImage(named: "instagrams"), for: .normal)
        //openmenu.addTarget(self, action: #selector(goback), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        contentView.autoresizesSubviews = true
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.addSubview(button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
