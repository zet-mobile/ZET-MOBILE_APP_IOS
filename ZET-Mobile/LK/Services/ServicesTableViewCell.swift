//
//  ServicesTableViewCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/4/21.
//

import UIKit

class ServicesTableViewCell: UITableViewCell {
    
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
        let ico_image = UIImageView()
        let titleOne = UILabel()
        let titleTwo = UILabel()
        let titleThree = UILabel()
        let getButton = UIButton()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: cellID4)
        backgroundColor = .clear
        
        ico_image.image = UIImage(named: "services_cell_img")
        
        contentView.addSubview(ico_image)
        contentView.addSubview(titleOne)
        contentView.addSubview(titleTwo)
        contentView.addSubview(titleThree)
        contentView.addSubview(getButton)
        
        ico_image.frame = CGRect(x: 10, y: 20, width: 50, height: 50)
        
        titleOne.frame = CGRect(x: 70, y: 10, width: UIScreen.main.bounds.size.width  - 100, height: 50)
        titleOne.text = "Переадресация вызова"
        titleOne.numberOfLines = 1
        titleOne.textColor = .black
        titleOne.font = UIFont.boldSystemFont(ofSize: 16)
        titleOne.textAlignment = .left
        
        titleTwo.frame = CGRect(x: 70, y: 35, width: UIScreen.main.bounds.size.width  - 100, height: 60)
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
        titleString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: range2)
        
        costString.append(titleString)
        titleThree.attributedText = costString
        titleThree.textAlignment = .left
        
       // getButton.setImage(#imageLiteral(resourceName: "get_button"), for: UIControl.State.normal)
        getButton.frame = CGRect(x: UIScreen.main.bounds.size.width  - 190, y: 90, width: 160, height: 40)
        getButton.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
        getButton.setTitle(defaultLocalizer.stringForKey(key: "connect"), for: .normal)
        getButton.setTitleColor(.white, for: .normal)
        getButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        getButton.layer.cornerRadius = getButton.frame.height / 2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
