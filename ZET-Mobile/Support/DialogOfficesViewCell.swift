//
//  DialogOfficesViewCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 06/04/22.
//

import UIKit

class DialogOfficesViewCell: UITableViewCell {
    let ico_image = UIImageView()
    let titleOne = UILabel()

override func awakeFromNib() {
    super.awakeFromNib()
    
}

override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: "DialogOfficesViewCell")
    backgroundColor = .clear
    
    
    contentView.addSubview(ico_image)
    contentView.addSubview(titleOne)
    
    contentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 80)
    
    ico_image.frame = CGRect(x: 10, y: 0, width: 30, height: 30)
    
    titleOne.frame = CGRect(x: 50, y: 0, width: UIScreen.main.bounds.size.width - 80, height: 30)
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
