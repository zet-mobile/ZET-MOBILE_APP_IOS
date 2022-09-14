//
//  AboutViewCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 1/8/22.
//

import UIKit

class AboutViewCell: UITableViewCell {
    
    let icon = UIImageView()
    let button = UIButton()
    let titleOne = UILabel()
    let titleTwo = UILabel()

override func awakeFromNib() {
    super.awakeFromNib()
    
}

override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: "about_cell")
    backgroundColor = .clear
    
    contentView.addSubview(icon)
    contentView.addSubview(button)
    contentView.addSubview(titleOne)
    contentView.addSubview(titleTwo)
    
    contentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 130)
    
    icon.frame = CGRect(x: 20, y: 10, width: 50, height: 50)
    icon.image = UIImage(named: "about_app")
    
    button.frame = CGRect(x: UIScreen.main.bounds.size.width - 50, y: 20, width: 30, height: 30)
    button.setImage(#imageLiteral(resourceName: "next_arrow"), for: UIControl.State.normal)
    button.isUserInteractionEnabled = false
    
    titleOne.frame = CGRect(x: 80, y: 10, width: 240, height: 30)
    titleOne.text = ""
    titleOne.numberOfLines = 1
    titleOne.textColor = colorBlackWhite
    titleOne.font = UIFont.systemFont(ofSize: 18, weight: .regular)
    titleOne.textAlignment = .left
    
    titleTwo.frame = CGRect(x: 80, y: 30, width: UIScreen.main.bounds.size.width - 130, height: 50)
    titleTwo.text = ""
    titleTwo.numberOfLines = 2
    titleTwo.textColor = .lightGray
    titleTwo.font = UIFont.systemFont(ofSize: 16)
    titleTwo.textAlignment = .left
    titleTwo.lineBreakMode = .byWordWrapping
}

override func layoutSubviews() {
    super.layoutSubviews()
}

required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}

}

