//
//  HistoryUsageViewCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/11/21.
//

import UIKit

class HistoryUsageViewCell: UITableViewCell {

    let ico_image = UIImageView()
    let titleOne = UILabel()
    let titleTwo = UILabel()
    let titleThree = UILabel()
    let titleFour = UILabel()

override func awakeFromNib() {
    super.awakeFromNib()
    
}

override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: "history_usage")
    backgroundColor = .clear
    
    ico_image.image = UIImage(named: "in_money")
    
    contentView.addSubview(ico_image)
    contentView.addSubview(titleOne)
    contentView.addSubview(titleTwo)
    contentView.addSubview(titleThree)
    contentView.addSubview(titleFour)
    
    contentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 130)
    
    ico_image.frame = CGRect(x: 10, y: 20, width: 50, height: 50)
    
    titleOne.frame = CGRect(x: 80, y: 10, width: 240, height: 50)
    titleOne.text = "Пополнение счета с банковской карты"
    titleOne.numberOfLines = 2
    titleOne.textColor = .black
    titleOne.font = UIFont.systemFont(ofSize: 17)
    titleOne.textAlignment = .left
    
    titleTwo.frame = CGRect(x: 80, y: 60, width: 340, height: 30)
    titleTwo.text = "Пополнение"
    titleTwo.numberOfLines = 2
    titleTwo.textColor = .gray
    titleTwo.font = UIFont.systemFont(ofSize: 15)
    titleTwo.textAlignment = .left
    
    titleThree.frame = CGRect(x: 280, y: 10, width: 100, height: 50)
    titleThree.text = "+ 24 С"
    titleThree.textColor = UIColor(red: 0.153, green: 0.682, blue: 0.376, alpha: 1)
    titleThree.font = UIFont.systemFont(ofSize: 18)
    titleThree.textAlignment = .right
    
    titleFour.frame = CGRect(x: 180, y: 60, width: 200, height: 30)
    titleFour.text = "21-10-2021 13:48"
    titleFour.numberOfLines = 2
    titleFour.textColor = .gray
    titleFour.font = UIFont.systemFont(ofSize: 15)
    titleFour.textAlignment = .right
    
}

override func layoutSubviews() {
    super.layoutSubviews()
}

required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}
    

}
