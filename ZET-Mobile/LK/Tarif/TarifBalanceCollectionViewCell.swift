//
//  TarifBalanceCollectionViewCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/5/21.
//

import UIKit

class TarifBalanceCollectionViewCell: UICollectionViewCell {
    
    let image: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "")
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        return iv
    }()
    
    lazy var titleOne: UILabel = {
        let titleOne = UILabel()
        titleOne.text = ""
        titleOne.numberOfLines = 1
        titleOne.textColor = .orange
        titleOne.font = UIFont.boldSystemFont(ofSize: 16)
        //titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .center
        titleOne.frame = CGRect(x: 20, y: 50, width: 80, height: 30)
        
        return titleOne
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.addSubview(image)
        contentView.sendSubviewToBack(image)
        contentView.addSubview(titleOne)
        image.frame = CGRect(x: 20, y: 5, width: 80, height: 80)
        //image.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingLeft: 16)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

