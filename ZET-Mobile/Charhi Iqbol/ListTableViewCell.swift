//
//  ListTableViewCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 07/12/22.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    let button = UIButton()
    let titleOne = UILabel()

override func awakeFromNib() {
    super.awakeFromNib()
    
}

override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: "list_cell")
    backgroundColor = .clear
    
    contentView.addSubview(button)
    contentView.addSubview(titleOne)
    
    contentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 100)
    
    button.frame = CGRect(x: UIScreen.main.bounds.size.width - 50, y: 20, width: 30, height: 30)
    button.setImage(#imageLiteral(resourceName: "Stroke_next"), for: UIControl.State.normal)
    button.isUserInteractionEnabled = false
    
    titleOne.frame = CGRect(x: 20, y: 0, width: 240, height: 70)
    titleOne.text = "jjjjj"
    titleOne.numberOfLines = 1
    titleOne.textColor = colorBlackWhite
    titleOne.font = UIFont.systemFont(ofSize: 18, weight: .regular)
    titleOne.textAlignment = .left
}

override func layoutSubviews() {
    super.layoutSubviews()
}

required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}

}

