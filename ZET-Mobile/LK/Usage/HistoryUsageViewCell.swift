//
//  HistoryUsageViewCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/11/21.
//

import UIKit

class HistoryUsageViewCell: UITableViewCell {

    let icon_image = UIImageView()
    let serviceTitle = UILabel()
    let descriptionOfCharge = UILabel()
    let servicePrice = UILabel()
    let timeOfCharge = UILabel()

override func awakeFromNib() {
    super.awakeFromNib()
    
}

override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: "history_usage")
    backgroundColor = .clear
    
    icon_image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "in_money_dark") : UIImage(named: "in_money"))
    contentView.addSubview(icon_image)
    contentView.addSubview(serviceTitle)
    contentView.addSubview(descriptionOfCharge)
    contentView.addSubview(servicePrice)
    contentView.addSubview(timeOfCharge)
    
    //contentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 100)
    
    icon_image.translatesAutoresizingMaskIntoConstraints = false
    serviceTitle.translatesAutoresizingMaskIntoConstraints = false
    descriptionOfCharge.translatesAutoresizingMaskIntoConstraints = false
    servicePrice.translatesAutoresizingMaskIntoConstraints = false
    timeOfCharge.translatesAutoresizingMaskIntoConstraints = false
    
 
    
    //icon_image.frame = CGRect(x: 10, y: 20, width: 50, height: 50)
    
    icon_image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
    icon_image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
    //ico_image.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    icon_image.widthAnchor.constraint(equalToConstant: 50).isActive = true
    icon_image.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    serviceTitle.leadingAnchor.constraint(equalTo: icon_image.trailingAnchor, constant: 10).isActive = true
    serviceTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
   // serviceTitle.frame = CGRect(x: 80, y: 10, width: 240, height: 50)
    serviceTitle.numberOfLines = 2
    serviceTitle.textColor = colorBlackWhite
    serviceTitle.font = UIFont.systemFont(ofSize: 17)
    serviceTitle.textAlignment = .left
    
    
    servicePrice.leadingAnchor.constraint(equalTo: serviceTitle.trailingAnchor, constant: 10).isActive = true
    servicePrice.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
    servicePrice.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
    //servicePrice.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (servicePrice.text!.count * 15) - 10, y: 10, width: (servicePrice.text!.count * 15), height: 50)
    servicePrice.textColor = UIColor(red: 0.153, green: 0.682, blue: 0.376, alpha: 1)
    servicePrice.font = UIFont.systemFont(ofSize: 18)
    servicePrice.textAlignment = .right
   

    descriptionOfCharge.leadingAnchor.constraint(equalTo: icon_image.trailingAnchor, constant: 10).isActive = true
    descriptionOfCharge.topAnchor.constraint(equalTo: serviceTitle.bottomAnchor, constant: 10).isActive = true
   // descriptionOfCharge.frame = CGRect(x: 80, y: 50, width: 340, height: 30)
    descriptionOfCharge.numberOfLines = 1
    descriptionOfCharge.textColor = .gray
    descriptionOfCharge.font = UIFont.systemFont(ofSize: 15)
    descriptionOfCharge.textAlignment = .left
    
    
    timeOfCharge.leadingAnchor.constraint(equalTo: descriptionOfCharge.trailingAnchor, constant: 10).isActive = true
    timeOfCharge.topAnchor.constraint(equalTo: serviceTitle.bottomAnchor, constant: 10).isActive = true
    timeOfCharge.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
    //timeOfCharge.frame = CGRect(x: Int(UIScreen.main.bounds.size.width) - (timeOfCharge.text!.count * 15) - 10, y: 50, width: (timeOfCharge.text!.count * 15), height: 30)
    timeOfCharge.numberOfLines = 1
    timeOfCharge.textColor = .gray
    timeOfCharge.font = UIFont.systemFont(ofSize: 15)
    timeOfCharge.textAlignment = .right
  
}

override func layoutSubviews() {
    super.layoutSubviews()
}

required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}
    
    
}
