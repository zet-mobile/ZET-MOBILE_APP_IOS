//
//  ContactsTableViewCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 13/05/22.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {
    
    let ico_image = UIImageView()
    let titleOne = UILabel()
    let titleTwo = UILabel()

override func awakeFromNib() {
    super.awakeFromNib()
    
}

override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: "history_transfer")
    backgroundColor = .clear
    
    ico_image.image = UIImage(named: "noAvatar")
    
    contentView.addSubview(ico_image)
    contentView.addSubview(titleOne)
    contentView.addSubview(titleTwo)
    
    contentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 70)
    
    ico_image.frame = CGRect(x: 10, y: 10, width: 45, height: 45)
    
    titleOne.frame = CGRect(x: 70, y: 5, width: 240, height: 30)
    titleOne.text = ""
    titleOne.numberOfLines = 1
    titleOne.textColor = colorBlackWhite
    titleOne.font = UIFont.systemFont(ofSize: 18)
    titleOne.textAlignment = .left
    
    titleTwo.frame = CGRect(x: 70, y: 30, width: 340, height: 25)
    titleTwo.text = "kmlkml"
    titleTwo.numberOfLines = 1
    titleTwo.textColor = colorBlackWhite
    titleTwo.font = UIFont.systemFont(ofSize: 15)
    titleTwo.textAlignment = .left
    
}

override func layoutSubviews() {
    super.layoutSubviews()
}

required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}

}
