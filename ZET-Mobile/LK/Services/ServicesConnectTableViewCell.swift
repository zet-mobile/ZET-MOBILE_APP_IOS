//
//  ServicesConnectTableViewCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/8/21.
//

import UIKit

class ServicesConnectTableViewCell: UITableViewCell {
    
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    let icon_image = UIImageView()
    let serviceTitle = UILabel()
    let serviceDesc = UILabel()
    let servPrice = UILabel()
    let getButton = UIButton()
    let dote_image = UIImageView()
    let serviceCharge = UILabel()

    
override func awakeFromNib() {
    super.awakeFromNib()
    
}

override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: "serv_connect")
    backgroundColor = .clear
    
    icon_image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "Service_Active_dark") : UIImage(named: "Service_Active"))
   
    dote_image.image = UIImage(named: "Ellipse")
    dote_image.contentMode = .scaleAspectFit
    
    contentView.addSubview(icon_image)
    contentView.addSubview(serviceTitle)
    contentView.addSubview(serviceDesc)
    contentView.addSubview(servPrice)
    contentView.addSubview(getButton)
    contentView.addSubview(dote_image)
    contentView.addSubview(serviceCharge)
    
  //  contentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 130)
    

    
   // serviceTitle.frame = CGRect(x: 70, y: 10, width: 240, height: 50)
    serviceTitle.text = ""
    serviceTitle.numberOfLines = 2
    serviceTitle.textColor = colorBlackWhite
    serviceTitle.font = UIFont.boldSystemFont(ofSize: 16)
    serviceTitle.textAlignment = .left
    serviceTitle.lineBreakMode = .byWordWrapping
    
 //   serviceDesc.frame = CGRect(x: 70, y: 60, width: UIScreen.main.bounds.size.width - 100, height: 60)
    serviceDesc.text = ""
    serviceDesc.numberOfLines = 0
    serviceDesc.textColor = darkGrayLight
    serviceDesc.font = UIFont.systemFont(ofSize: 15)
    serviceDesc.textAlignment = .left
    serviceDesc.lineBreakMode = .byWordWrapping
    
   // servPrice.frame = CGRect(x: 70, y: 80, width: 200, height: 60)
    servPrice.textAlignment = .left
    
    //getButton.setImage(#imageLiteral(resourceName: "turn_off"), for: UIControl.State.normal)
  //  getButton.frame = CGRect(x: UIScreen.main.bounds.size.width - 190, y: 90, width: 160, height: 35)
    getButton.backgroundColor = .clear
    getButton.setTitle(defaultLocalizer.stringForKey(key: "Disable"), for: .normal)
    getButton.setTitleColor(UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00), for: .normal)
    getButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
    getButton.layer.cornerRadius = getButton.frame.height / 2
    getButton.layer.borderColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00).cgColor
    getButton.layer.borderWidth = 1
    getButton.isUserInteractionEnabled = true
    
   // serviceCharge.frame = CGRect(x: 90, y: 110, width: UIScreen.main.bounds.size.width - 130, height: 60)
    serviceCharge.text = ""
    serviceCharge.numberOfLines = 2
    serviceCharge.textColor = .lightGray
    serviceCharge.font = UIFont.systemFont(ofSize: 14)
    serviceCharge.textAlignment = .left
    
    // Устанавливаем автолэйаут констрейнты при загрузке ячейки

    icon_image.translatesAutoresizingMaskIntoConstraints = false
    dote_image.translatesAutoresizingMaskIntoConstraints = false
    serviceTitle.translatesAutoresizingMaskIntoConstraints = false
    serviceDesc.translatesAutoresizingMaskIntoConstraints = false
    servPrice.translatesAutoresizingMaskIntoConstraints = false
    serviceCharge.translatesAutoresizingMaskIntoConstraints = false
    getButton.translatesAutoresizingMaskIntoConstraints = false
    
    
    // Констрейнты для иконки слева
  
    icon_image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
    //ico_image.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    icon_image.widthAnchor.constraint(equalToConstant: 50).isActive = true
    icon_image.heightAnchor.constraint(equalToConstant: 50).isActive = true
    icon_image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
    
    // Констрейнты для первого UILabel
     serviceTitle.leadingAnchor.constraint(equalTo: icon_image.trailingAnchor, constant: 8).isActive = true
     serviceTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
     serviceTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
    
    // Констрейнты для второго UILabel
     serviceDesc.leadingAnchor.constraint(equalTo: icon_image.trailingAnchor, constant: 8).isActive = true
     serviceDesc.topAnchor.constraint(equalTo: serviceTitle.bottomAnchor, constant: 8).isActive = true
     serviceDesc.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
    
    // Констрейнты для третьего UILabel
     servPrice.leadingAnchor.constraint(equalTo: icon_image.trailingAnchor, constant: 8).isActive = true
   //  servPrice.topAnchor.constraint(equalTo: serviceDesc.bottomAnchor, constant: 8).isActive = true
     servPrice.centerYAnchor.constraint(equalTo: getButton.centerYAnchor).isActive = true
    
    getButton.leadingAnchor.constraint(equalTo: servPrice.trailingAnchor, constant: 8).isActive = true
    getButton.topAnchor.constraint(equalTo: serviceDesc.bottomAnchor, constant: 10).isActive = true
    getButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
    getButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
    getButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
    
    // Констрейнты для первого dote
    dote_image.leadingAnchor.constraint(equalTo: icon_image.trailingAnchor, constant: 8).isActive = true
    dote_image.topAnchor.constraint(equalTo: servPrice.bottomAnchor, constant: 8).isActive = true
    dote_image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15).isActive = true
    dote_image.widthAnchor.constraint(equalToConstant: 10).isActive = true
    dote_image.heightAnchor.constraint(equalToConstant: 60).isActive = true
    
    // Констрейнты для первого dote
    serviceCharge.leadingAnchor.constraint(equalTo: dote_image.trailingAnchor, constant: 6).isActive = true
    serviceCharge.topAnchor.constraint(equalTo: servPrice.bottomAnchor, constant: 8).isActive = true
    serviceCharge.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15).isActive = true
    serviceCharge.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
 
   
}

override func layoutSubviews() {
    super.layoutSubviews()
    
    getButton.layer.cornerRadius = 17.5
}

required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}

}
