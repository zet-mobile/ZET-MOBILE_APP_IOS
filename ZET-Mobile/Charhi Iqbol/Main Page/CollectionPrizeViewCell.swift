//
//  CollectionPrizeViewCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 07/12/22.
//

import UIKit

class CollectionPrizeViewCell: UICollectionViewCell {
    
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
   // let view_prize = UIView()

    let image: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "")
        iv.contentMode = .scaleToFill
        iv.backgroundColor = .clear
        return iv
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = colorBlackWhite
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
            //view_prize.frame = CGRect(x: 10, y: 5, width: 200, height: 100)
        image.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            //label.textAlignment = .center
          // label.sizeToFit()
          //  label.center = CGPoint(x: image.bounds.midX, y: image.bounds.maxY)
        label.frame = CGRect(x:0, y: image.bounds.maxX, width: 118, height: 20)
        //view_prize.addSubview(image)
       // view_prize.addSubview(label)
        //contentView.addSubview(view_prize)
        
        contentView.addSubview(image)
        contentView.addSubview(label)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
