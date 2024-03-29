//
//  AddBalanceOptionViewCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 2/9/22.
//

import UIKit

class AddBalanceOptionViewCell: UITableViewCell {
    
    let ico_image = UIImageView()
    let titleOne = UILabel()

override func awakeFromNib() {
    super.awakeFromNib()
    
}

override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: "add_balance_cell")
    backgroundColor = .clear
    
    
    contentView.addSubview(ico_image)
    contentView.addSubview(titleOne)
    
    contentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 60)
    
    ico_image.frame = CGRect(x: 10, y: 10, width: 45, height: 45)
    
    titleOne.frame = CGRect(x: 80, y: 0, width: 240, height: 60)
    titleOne.text = ""
    titleOne.numberOfLines = 2
    titleOne.textColor = colorBlackWhite
    titleOne.font = UIFont.systemFont(ofSize: 17)
    titleOne.textAlignment = .left
    
}

override func layoutSubviews() {
    super.layoutSubviews()
}

required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}
    

}
