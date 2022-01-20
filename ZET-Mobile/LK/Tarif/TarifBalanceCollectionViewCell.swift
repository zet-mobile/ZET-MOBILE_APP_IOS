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
        iv.image = UIImage(named: "img-5")
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        return iv
    }()
    
    lazy var titleOne: UILabel = {
        let titleOne = UILabel()
        titleOne.text = "Трафик трансфер"
        titleOne.numberOfLines = 2
        titleOne.textColor = .black
        titleOne.font = UIFont.systemFont(ofSize: 10)
        //titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .center
        titleOne.frame = CGRect(x: 20, y: 60, width: 60, height: 60)
        
        return titleOne
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.addSubview(image)
        //contentView.addSubview(titleOne)
        image.frame = CGRect(x: 20, y: 5, width: 70, height: 70)
        //image.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingLeft: 16)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

