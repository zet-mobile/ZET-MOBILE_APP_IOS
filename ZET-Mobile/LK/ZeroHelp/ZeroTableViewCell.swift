//
//  ZeroTableViewCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 12/10/21.
//

import UIKit

class ZeroTableViewCell: UITableViewCell {

    let button = UIButton()
    let titleOne = UILabel()
    let titleTwo = UILabel()

override func awakeFromNib() {
    super.awakeFromNib()
    
}

override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: "zero_cell")
    backgroundColor = .clear
    
    
    contentView.addSubview(button)
    contentView.addSubview(titleOne)
    contentView.addSubview(titleTwo)
    
    contentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 130)
    
    button.frame = CGRect(x: UIScreen.main.bounds.size.width - 70, y: 10, width: 50, height: 50)
    button.setImage(#imageLiteral(resourceName: "choosed_help"), for: UIControl.State.normal)
    
    titleOne.frame = CGRect(x: 20, y: 10, width: 240, height: 30)
    titleOne.text = "Пакет 3 сомони"
    titleOne.numberOfLines = 1
    titleOne.textColor = .black
    titleOne.font = UIFont.boldSystemFont(ofSize: 20)
    titleOne.textAlignment = .left
    
    titleTwo.frame = CGRect(x: 20, y: 40, width: 340, height: 30)
    titleTwo.text = "3.5 сомони"
    titleTwo.numberOfLines = 1
    titleTwo.textColor = .orange
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

