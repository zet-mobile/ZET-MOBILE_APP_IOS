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
    //button.frame = CGRect(x: UIScreen.main.bounds.size.width - 50, y: 20, width: 30, height: 30)
    button.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([button.topAnchor.constraint(equalTo: contentView.topAnchor),
                                button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                                button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                                button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
    button.setImage(#imageLiteral(resourceName: "Stroke_next"), for: UIControl.State.normal)
    button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 300, bottom: 0, right: 0)
    button.isUserInteractionEnabled = false
    titleOne.frame = CGRect(x: 20, y: 0, width: 240, height: 70)
    titleOne.text = ""
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

