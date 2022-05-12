//
//  ProfileMenuCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 2/24/22.
//

import UIKit

class ProfileMenuCell: UITableViewCell {

    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
        let ico_image = UIImageView()
        let titleOne = UILabel()
        let titleTwo = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "profile_menu_cell")
        backgroundColor = .clear
        
        ico_image.image = UIImage(named: "user_profile_menu")
        
        contentView.addSubview(ico_image)
        contentView.addSubview(titleOne)
        contentView.addSubview(titleTwo)
        
        ico_image.frame = CGRect(x: 20, y: 25, width: 50, height: 50)
        
        titleOne.frame = CGRect(x: 80, y: 20, width: UIScreen.main.bounds.size.width  - 100, height: 30)
        titleOne.text = "Александр"
        titleOne.numberOfLines = 1
        titleOne.textColor = darkGrayLight
        titleOne.font = UIFont.systemFont(ofSize: 15)
        titleOne.textAlignment = .left
        
        titleTwo.frame = CGRect(x: 80, y: 50, width: UIScreen.main.bounds.size.width  - 100, height: 30)
        titleTwo.text = "+956654448162"
        titleTwo.numberOfLines = 1
        titleTwo.textColor = colorBlackWhite
        titleTwo.font = UIFont.systemFont(ofSize: 16)
        titleTwo.textAlignment = .left
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

