//
//  RoumingTopViewCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 02/06/22.
//

import UIKit

class RoumingTopViewCell: UITableViewCell {
    
    let button = UIButton()
    let titleOne = UILabel()

override func awakeFromNib() {
    super.awakeFromNib()
    
}

override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: "roaming_top")
    contentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 80)
    
    backgroundColor = .clear
    
    selectionStyle = .gray

    contentView.addSubview(button)
    contentView.addSubview(titleOne)
    
    button.frame = CGRect(x: UIScreen.main.bounds.size.width - 70, y: 20, width: 50, height: 30)
    button.setImage(#imageLiteral(resourceName: "drop_icon"), for: UIControl.State.normal)
    
    titleOne.frame = CGRect(x: 20, y: 0, width: UIScreen.main.bounds.size.width - 90, height: 60)
    titleOne.text = ""
    titleOne.numberOfLines = 0
    titleOne.textColor = colorBlackWhite
    titleOne.font = UIFont.systemFont(ofSize: 20)
    titleOne.textAlignment = .left
  
}

override func layoutSubviews() {
    super.layoutSubviews()
}

required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}

}

