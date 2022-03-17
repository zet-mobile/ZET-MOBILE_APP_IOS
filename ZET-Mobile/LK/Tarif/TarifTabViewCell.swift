//
//  TarifTabViewCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/5/21.
//

import UIKit

class TarifTabViewCell: UITableViewCell {

    let ico_image = UIImageView()
    let titleOne = UILabel()
    let titleTwo = UILabel()
    let titleThree = UILabel()

override func awakeFromNib() {
    super.awakeFromNib()
    
}

override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: "tarif_tab_cell")
    backgroundColor = .clear
    
    ico_image.image = UIImage(named: "services_cell_img")
    titleOne.text = "Трафик трансфер"
    
    contentView.addSubview(ico_image)
    contentView.addSubview(titleOne)
    contentView.addSubview(titleTwo)
    contentView.addSubview(titleThree)
    
    contentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 100)
    
    ico_image.frame = CGRect(x: 20, y: 20, width: 50, height: 50)
    
    titleOne.frame = CGRect(x: 80, y: 10, width: 200, height: 50)
    titleOne.text = "Фаври"
    titleOne.numberOfLines = 1
    titleOne.textColor = .black
    titleOne.font = UIFont.boldSystemFont(ofSize: 16)
    titleOne.textAlignment = .left
    
    titleTwo.frame = CGRect(x: 80, y: 35, width: 300, height: 60)
    titleTwo.text = ""
    titleTwo.numberOfLines = 2
    titleTwo.textColor = .darkGray
    titleTwo.font = UIFont.systemFont(ofSize: 15)
    titleTwo.textAlignment = .left
    
    titleThree.frame = CGRect(x: UIScreen.main.bounds.size.width - 220, y: 10, width: 200, height: 50)
    
    titleThree.textAlignment = .right
    
}

override func layoutSubviews() {
    super.layoutSubviews()
}

required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}

}

