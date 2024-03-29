//
//  SupportListCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 1/9/22.
//

import UIKit

class SupportListCell: UITableViewCell {
    
    let button = UIButton()
    let titleOne = UILabel()
    let titleTwo = UILabel()

override func awakeFromNib() {
    super.awakeFromNib()
    
}

override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: "support_list_cell")
    backgroundColor = .clear
    
    contentView.addSubview(button)
    contentView.addSubview(titleOne)
    contentView.addSubview(titleTwo)
    
    contentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 140)
    
    button.frame = CGRect(x: UIScreen.main.bounds.size.width - 50, y: 35, width: 30, height: 30)
    button.setImage(#imageLiteral(resourceName: "next_arrow"), for: UIControl.State.normal)
    
    titleOne.frame = CGRect(x: 20, y: 10, width: UIScreen.main.bounds.size.width - 100, height: 50)
    titleOne.numberOfLines = 2
    titleOne.textColor = colorBlackWhite
    titleOne.font = UIFont.systemFont(ofSize: 17)
    titleOne.textAlignment = .left
    
    titleTwo.frame = CGRect(x: 20, y: 50, width: 340, height: 30)
    titleTwo.numberOfLines = 1
    titleTwo.textColor = UIColor(red: 0.37, green: 0.76, blue: 0.36, alpha: 1.00)
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

