//
//  CollectionPrizeViewCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 07/12/22.
//

import UIKit

class CollectionPrizeViewCell: UICollectionViewCell {
    
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    let image: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "")
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.addSubview(image)
        image.frame = CGRect(x: 10, y: 5, width: 70, height: 70)
        
        
        //image.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingLeft: 16)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
