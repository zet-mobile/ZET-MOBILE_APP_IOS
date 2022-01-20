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
    titleOne.text = "Переадресация вызова"
    titleOne.numberOfLines = 1
    titleOne.textColor = .black
    titleOne.font = UIFont.boldSystemFont(ofSize: 16)
    titleOne.textAlignment = .left
    
    titleTwo.frame = CGRect(x: 70, y: 35, width: UIScreen.main.bounds.size.width - 100, height: 60)
    titleTwo.text = "Переадресация вызова позволит Вам переадресовать все входящие звон ..."
    titleTwo.numberOfLines = 2
    titleTwo.textColor = .darkGray
    titleTwo.font = UIFont.systemFont(ofSize: 15)
    titleTwo.textAlignment = .left
    
    titleThree.frame = CGRect(x: 70, y: 80, width: 200, height: 60)
    let cost: NSString = "10" as NSString
    let range = (cost).range(of: cost as String)
    let costString = NSMutableAttributedString.init(string: cost as String)
    costString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange , range: range)
    costString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], range: range)
    
    let title_cost = " с/месяц" as NSString
    let titleString = NSMutableAttributedString.init(string: title_cost as String)
    let range2 = (title_cost).range(of: title_cost as String)
    titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkGray , range: range2)
    titleString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: range)
    
    costString.append(titleString)
    titleThree.attributedText = costString
        //+ titleString
    //titleThree.numberOfLines = 2
    //titleThree.textColor = .darkGray
    //titleThree.font = UIFont.systemFont(ofSize: 15)
    titleThree.textAlignment = .left
    
    //getButton.setImage(#imageLiteral(resourceName: "turn_off"), for: UIControl.State.normal)
    getButton.frame = CGRect(x: UIScreen.main.bounds.size.width - 180, y: 90, width: 150, height: 30)
    getButton.backgroundColor = .clear
    getButton.setTitle(defaultLocalizer.stringForKey(key: "disable"), for: .normal)
    getButton.setTitleColor(UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00), for: .normal)
    getButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
    getButton.layer.cornerRadius = getButton.frame.height / 2
    getButton.layer.borderColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00).cgColor
    getButton.layer.borderWidth = 1
    
    spisanie.frame = CGRect(x: 95, y: 110, width: 200, height: 60)
    spisanie.text = "списание 25.12.21"
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
