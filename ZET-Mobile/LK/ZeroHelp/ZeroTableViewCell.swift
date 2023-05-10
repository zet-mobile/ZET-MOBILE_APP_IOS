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
    let title_info = UILabel()
    let  icon_more = UIButton()
    
override func awakeFromNib() {
    super.awakeFromNib()
    
}

override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: "zero_cell")
    backgroundColor = .clear
    
    
    contentView.addSubview(button)
    contentView.addSubview(titleOne)
    contentView.addSubview(titleTwo)
    contentView.addSubview(title_info)
    contentView.addSubview(icon_more)
    
    contentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 130)
    
    button.frame = CGRect(x: UIScreen.main.bounds.size.width - 70, y: 10, width: 50, height: 50)
    button.setImage(#imageLiteral(resourceName: "choosed_help"), for: UIControl.State.normal)
    
    titleOne.frame = CGRect(x: 20, y: 10, width: 240, height: 30)
    titleOne.text = "Пакет 3 сомони"
    titleOne.numberOfLines = 1
    titleOne.textColor = colorBlackWhite
    titleOne.font = UIFont.boldSystemFont(ofSize: 20)
    titleOne.textAlignment = .left
    
    titleTwo.frame = CGRect(x: 20, y: 40, width: 340, height: 30)
    titleTwo.text = "3.5 сомони"
    titleTwo.numberOfLines = 1
    titleTwo.textColor = .orange
    titleTwo.font = UIFont.systemFont(ofSize: 15)
    titleTwo.textAlignment = .left
    
    title_info.text = "Меняйте лишнее на нужное! Услуга «Обмен» позволит Вам обменивать"
    title_info.numberOfLines = 2
    title_info.textColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1)
    title_info.font = UIFont.systemFont(ofSize: 17)
    title_info.lineBreakMode = NSLineBreakMode.byWordWrapping
    title_info.textAlignment = .left
    title_info.frame = CGRect(x: 20, y: 20, width: UIScreen.main.bounds.size.width - 40, height: 50)
    title_info.isHidden  = true
    title_info.adjustsFontSizeToFitWidth = false
    title_info.lineBreakMode = .byTruncatingTail
    
    //icon_more.setImage(#imageLiteral(resourceName: "View_all"), for: UIControl.State.normal)
    icon_more.backgroundColor = .clear
    icon_more.frame = CGRect(x: 20, y: 80, width: UIScreen.main.bounds.size.width  - 40, height: 20)
    icon_more.contentHorizontalAlignment = .left
    icon_more.setTitle("\(defaultLocalizer.stringForKey(key: "More_about_the_service"))  >", for: .normal)
    icon_more.setTitleColor(.orange, for: .normal)
    icon_more.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    icon_more.isHidden  = true
    //openmenu.addTarget(self, action: #selector(goback), for: UIControl.Event.touchUpInside)

}

override func layoutSubviews() {
    super.layoutSubviews()
}

required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}

}

