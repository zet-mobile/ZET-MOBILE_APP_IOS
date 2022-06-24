//
//  ServicesConnectTableViewCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/8/21.
//

import UIKit

class ServicesConnectTableViewCell: UITableViewCell {
    
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    let ico_image = UIImageView()
    let titleOne = UILabel()
    let titleTwo = UILabel()
    let titleThree = UILabel()
    let getButton = UIButton()
    let ic_image = UIImageView()
    let spisanie = UILabel()

override func awakeFromNib() {
    super.awakeFromNib()
    
}

override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: "serv_connect")
    backgroundColor = .clear
    
    ico_image.image = UIImage(named: "services_cell_img")
    ic_image.image = UIImage(named: "Ellipse")
 
    contentView.addSubview(ico_image)
    contentView.addSubview(titleOne)
    contentView.addSubview(titleTwo)
    contentView.addSubview(titleThree)
    contentView.addSubview(getButton)
    contentView.addSubview(ic_image)
    contentView.addSubview(spisanie)
    
    contentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 130)
    
    ico_image.frame = CGRect(x: 10, y: 20, width: 50, height: 50)
    ic_image.frame = CGRect(x: 70, y: 136, width: 8, height: 8)
    
    titleOne.frame = CGRect(x: 70, y: 10, width: 240, height: 50)
    titleOne.text = ""
    titleOne.numberOfLines = 2
    titleOne.textColor = colorBlackWhite
    titleOne.font = UIFont.boldSystemFont(ofSize: 16)
    titleOne.textAlignment = .left
    titleTwo.lineBreakMode = .byWordWrapping
    
    titleTwo.frame = CGRect(x: 70, y: 35, width: UIScreen.main.bounds.size.width - 100, height: 60)
    titleTwo.text = ""
    titleTwo.numberOfLines = 2
    titleTwo.textColor = darkGrayLight
    titleTwo.font = UIFont.systemFont(ofSize: 15)
    titleTwo.textAlignment = .left
    titleTwo.lineBreakMode = .byWordWrapping
    
    titleThree.frame = CGRect(x: 70, y: 80, width: 200, height: 60)
    titleThree.textAlignment = .left
    
    //getButton.setImage(#imageLiteral(resourceName: "turn_off"), for: UIControl.State.normal)
    getButton.frame = CGRect(x: UIScreen.main.bounds.size.width - 190, y: 90, width: 160, height: 40)
    getButton.backgroundColor = .clear
    getButton.setTitle(defaultLocalizer.stringForKey(key: "Disable"), for: .normal)
    getButton.setTitleColor(UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00), for: .normal)
    getButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
    getButton.layer.cornerRadius = getButton.frame.height / 2
    getButton.layer.borderColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00).cgColor
    getButton.layer.borderWidth = 1
    
    spisanie.frame = CGRect(x: 90, y: 110, width: 200, height: 60)
    spisanie.text = ""
    spisanie.numberOfLines = 2
    spisanie.textColor = .lightGray
    spisanie.font = UIFont.systemFont(ofSize: 15)
    spisanie.textAlignment = .left
}

override func layoutSubviews() {
    super.layoutSubviews()
}

required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}

}
