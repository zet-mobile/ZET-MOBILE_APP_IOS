//
//  ServicesTableViewCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/4/21.
//

import UIKit

protocol CellActionDelegate{
    func didServiceConnect(for cell: ServicesTableViewCell)
    func didServiceReconnect(for cell: ServicesConnectTableViewCell)
}

class ServicesTableViewCell: UITableViewCell {
    
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    var actionDelegate: CellActionDelegate?
    
        let icon_image = UIImageView()
        let serviceTitle = UILabel()
        let serviceDesc = UILabel()
        let servicePrice = UILabel()
        let getButton = UIButton()
        let discount = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: cellID4)
        backgroundColor = .clear
        
        icon_image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "Service_Default_dark") : UIImage(named: "Service_Default"))
        
        contentView.addSubview(icon_image)
        contentView.addSubview(serviceTitle)
        contentView.addSubview(serviceDesc)
        contentView.addSubview(servicePrice)
        contentView.addSubview(getButton)
        contentView.addSubview(discount)
        
      
        
      //  serviceTitle.frame = CGRect(x: 70, y: 10, width: UIScreen.main.bounds.size.width  - 100, height: 50)
        serviceTitle.text = ""
        serviceTitle.numberOfLines = 1
        serviceTitle.textColor = colorBlackWhite
        serviceTitle.font = UIFont.boldSystemFont(ofSize: 15)
        serviceTitle.textAlignment = .left
        
      //  serviceDesc.frame = CGRect(x: 70, y: 60, width: UIScreen.main.bounds.size.width  - 100, height: 60)
        serviceDesc.text = ""
        serviceDesc.numberOfLines = 0
        serviceDesc.textColor = darkGrayLight
        serviceDesc.font = UIFont.systemFont(ofSize: 15)
        serviceDesc.textAlignment = .left
        serviceDesc.lineBreakMode = .byWordWrapping
        
      //  servicePrice.frame = CGRect(x: 70, y: 60, width: 200, height: 60)
        
        servicePrice.textAlignment = .left
        
     //   discount.frame = CGRect(x: 150, y: 80, width: 50, height: 20)
        discount.textAlignment = .center
        discount.textColor = .white
        discount.backgroundColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00)
        discount.font = UIFont.systemFont(ofSize: 13)
        discount.isHidden = true
        
       // getButton.setImage(#imageLiteral(resourceName: "get_button"), for: UIControl.State.normal)
      //  getButton.frame = CGRect(x: UIScreen.main.bounds.size.width  - 160, y: 70, width: 140, height: 35)
        getButton.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
        getButton.setTitle(defaultLocalizer.stringForKey(key: "Connect"), for: .normal)
        getButton.setTitleColor(.white, for: .normal)
        getButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        getButton.isUserInteractionEnabled = true
        
        
        // Устанавливаем автолэйаут констрейнты при загрузке ячейки

        icon_image.translatesAutoresizingMaskIntoConstraints = false
        serviceTitle.translatesAutoresizingMaskIntoConstraints = false
        serviceDesc.translatesAutoresizingMaskIntoConstraints = false
        servicePrice.translatesAutoresizingMaskIntoConstraints = false
        discount.translatesAutoresizingMaskIntoConstraints = false
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
        servicePrice.leadingAnchor.constraint(equalTo: icon_image.trailingAnchor, constant: 8).isActive = true
        servicePrice.topAnchor.constraint(equalTo: serviceDesc.bottomAnchor, constant: 10).isActive = true
        servicePrice.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        
        discount.leadingAnchor.constraint(equalTo: servicePrice.trailingAnchor, constant: 4).isActive = true
        discount.heightAnchor.constraint(equalToConstant: 20).isActive = true
        discount.centerYAnchor.constraint(equalTo: servicePrice.centerYAnchor).isActive = true
        
        getButton.leadingAnchor.constraint(equalTo: discount.trailingAnchor, constant: 4).isActive = true
        getButton.topAnchor.constraint(equalTo: serviceDesc.bottomAnchor, constant: 10).isActive = true
        getButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        getButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        getButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        getButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        discount.layer.cornerRadius = discount.frame.height / 2
        discount.layer.masksToBounds = true
        
        getButton.layer.cornerRadius = 17.5
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //чтобы размер ячейки высчитывался атоматически и элементы не jumping
    func configureCell(with data: [String]) {
       // здесь происходит расчет и разбивка на подкл/откл услуги
        
        if data[7] == "connected" {
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let date = dateFormatter1.date(from: data[4])
            dateFormatter1.dateFormat = "dd-MM-yyyy"
            var next_apply_date  =  ""
            if data[4] != "" {
                next_apply_date = self.defaultLocalizer.stringForKey(key: "Active_before:") + "\(dateFormatter1.string(from: date!))"
                serviceDesc.text = data[5] + "\n\n" + next_apply_date
            }
            else {
                serviceDesc.text = data[5]
            }
           getButton.backgroundColor = .clear
           getButton.setTitle(defaultLocalizer.stringForKey(key: "Disable"), for: .normal)
           getButton.setTitleColor(UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00), for: .normal)
           getButton.layer.borderColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00).cgColor
           getButton.layer.borderWidth = 1
           icon_image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "Service_Active_dark") : UIImage(named: "Service_Active"))
        
           }
            else {
            serviceDesc.text = data[5]
            getButton.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
            getButton.setTitle(defaultLocalizer.stringForKey(key: "Connect"), for: .normal)
            getButton.setTitleColor(.white, for: .normal)
            icon_image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "Service_Default_dark") : UIImage(named: "Service_Default"))
        }
        serviceTitle.text = data[1]
     
        
        let cost: NSString = "\(data[2])" as NSString
        let range = (cost).range(of: cost as String)
        let costString = NSMutableAttributedString.init(string: cost as String)
        costString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange , range: range)
        costString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], range: range)
        
        var  period = " " + defaultLocalizer.stringForKey(key: "TJS") + "/" + data[6].uppercased()
        if data[6] == "" || data[6] == "0.0" {
            period = " " + defaultLocalizer.stringForKey(key: "TJS")
        }
        else {
            period = " " + defaultLocalizer.stringForKey(key: "TJS") +  "/" + data[6].uppercased()
        }
        
        let title_cost = period as NSString
        let titleString = NSMutableAttributedString.init(string: title_cost as String)
        let range2 = (title_cost).range(of: title_cost as String)
        titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: darkGrayLight , range: range2)
        titleString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)], range: range2)
        
        costString.append(titleString)
        servicePrice.attributedText = costString
        
        if data[9] != "" {
            discount.text = "-" + data[9] + "%"
            discount.isHidden = false
        }
        else {
            discount.isHidden = true
        }
        
        
    }

}
