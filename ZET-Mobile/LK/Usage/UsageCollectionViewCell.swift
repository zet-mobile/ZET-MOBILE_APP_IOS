//
//  UsageCollectionViewCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/10/21.
//

import UIKit

class UsageCollectionViewCell: UICollectionViewCell {
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    let iconMinOut: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Call_usage")
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
     //   iv.frame = CGRect(x: 15, y: 10, width: 23, height: 23)
        return iv
    }()
    
    lazy var titleMinOut: UILabel = {
        let title = UILabel()
        title.text = defaultLocalizer.stringForKey(key: "zet_call")
        title.numberOfLines = 2
        title.textColor = colorBlackWhite
        title.font = UIFont.systemFont(ofSize: 16)
        title.textAlignment = .left
     //   title.frame = CGRect(x: 50, y: 0, width: 200, height: 45)
        
        return title
    }()
    
    lazy var usageMinOut: UILabel = {
        let title = UILabel()
        title.text = ""
        title.numberOfLines = 1
        title.textColor = .orange
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textAlignment = .right
      //  title.frame = CGRect(x: 280, y: 0, width: 100, height: 45)
        
        return title
    }()
    
    lazy var LineMinOut: UILabel = {
        let title = UILabel()
     //   title.frame = CGRect(x: 50, y: 45, width: UIScreen.main.bounds.size.width - 105, height: 2)
        title.backgroundColor = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? .lightGray : UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1))
        return title
    }()
    
    let iconMinIn: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "zet")
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
     //   iv.frame = CGRect(x: 15, y: 57, width: 23, height: 23)
        return iv
    }()
    
    lazy var titleMinIn: UILabel = {
        let title = UILabel()
        title.text = defaultLocalizer.stringForKey(key: "calls within the network")
        title.numberOfLines = 2
        title.textColor = colorBlackWhite
        title.font = UIFont.systemFont(ofSize: 16)
        title.textAlignment = .left
   //     title.frame = CGRect(x: 50, y: 47, width: 200, height: 45)
        
        return title
    }()
    
    lazy var usageMinIn: UILabel = {
        let title = UILabel()
        title.text = ""
        title.numberOfLines = 1
        title.textColor = .orange
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textAlignment = .right
     //   title.frame = CGRect(x: 280, y: 47, width: 100, height: 45)
        
        return title
    }()
    
    lazy var lineMinIn: UILabel = {
        let title = UILabel()
       // title.frame = CGRect(x: 50, y: 92, width: UIScreen.main.bounds.size.width - 105, height: 2)
        title.backgroundColor = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? .lightGray : UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1))
        return title
    }()
    
    let iconMB: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Chart")
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        iv.frame = CGRect(x: 15, y: 104, width: 27, height: 27)
        return iv
    }()
    
    lazy var titleMB: UILabel = {
        let title = UILabel()
        title.text = defaultLocalizer.stringForKey(key: "DATA")
        title.numberOfLines = 1
        title.textColor = colorBlackWhite
        title.font = UIFont.systemFont(ofSize: 16)
        title.textAlignment = .left
       // title.frame = CGRect(x: 50, y: 94, width: 100, height: 45)
        
        return title
    }()
    
    lazy var usageMb: UILabel = {
        let title = UILabel()
        title.text = ""
        title.numberOfLines = 1
        title.textColor = .orange
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textAlignment = .right
       // title.frame = CGRect(x: 280, y: 94, width: 100, height: 45)
        
        return title
    }()
    
    lazy var lineMb: UILabel = {
        let title = UILabel()
      //  title.frame = CGRect(x: 50, y: 94, width: UIScreen.main.bounds.size.width - 105, height: 2)
        title.backgroundColor = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? .lightGray : UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1))
        return title
    }()
    
    let icomSms: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Message_usage")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
    //    iv.frame = CGRect(x: 15, y: 151, width: 23, height: 23)
        return iv
    }()
    
    lazy var titleSms: UILabel = {
        let title = UILabel()
        title.text = defaultLocalizer.stringForKey(key: "SMS2")
        title.numberOfLines = 1
        title.textColor = colorBlackWhite
        title.font = UIFont.systemFont(ofSize: 16)
        title.textAlignment = .left
     //   title.frame = CGRect(x: 50, y: 141, width: 100, height: 45)
        
        return title
    }()
    
    lazy var usageSms: UILabel = {
        let title = UILabel()
        title.text = ""
        title.numberOfLines = 1
        title.textColor = .orange
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textAlignment = .right
     //   title.frame = CGRect(x: 280, y: 141, width: 100, height: 45)
        
        return title
    }()
    
    lazy var lineSms: UILabel = {
        let title = UILabel()
     //   title.frame = CGRect(x: 50, y: 141, width: UIScreen.main.bounds.size.width - 105, height: 2)
        title.backgroundColor = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? .lightGray : UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1))
        return title
    }()
    
    lazy var lineMoney: UILabel = {
        let title = UILabel()
     //   title.frame = CGRect(x: 50, y: 188, width: UIScreen.main.bounds.size.width - 105, height: 2)
        title.backgroundColor = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? .lightGray : UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1))
        return title
    }()
    
    let iconMoneySpend: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Call_usage")
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        //iv.frame = CGRect(x: 15, y: 198, width: 23, height: 23)
        return iv
    }()
    
    lazy var titleMoneySpend: UILabel = {
        let title = UILabel()
        title.text = defaultLocalizer.stringForKey(key: "Somoni")
        title.numberOfLines = 1
        title.textColor = colorBlackWhite
        title.font = UIFont.systemFont(ofSize: 16)
        title.textAlignment = .left
        //title.frame = CGRect(x: 50, y: 188, width: 100, height: 45)
        
        return title
    }()
    
    lazy var usageMoney: UILabel = {
        let title = UILabel()
        title.text = ""
        title.numberOfLines = 1
        title.textColor = .orange
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textAlignment = .right
        //title.frame = CGRect(x: 280, y: 188, width: 100, height: 45)
        
        return title
    }()
    
    var view_balance = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        view_balance.backgroundColor = colorGrayWhite
        view_balance.layer.cornerRadius = 16
        view_balance.frame = CGRect(x: 20, y: 10, width: UIScreen.main.bounds.size.width - 40, height: 280)
        
        view_balance.addSubview(iconMinOut)
        view_balance.addSubview(titleMinOut)
        view_balance.addSubview(usageMinOut)
        view_balance.addSubview(LineMinOut)
        
        
        //минуты вне сети
        
        iconMinOut.translatesAutoresizingMaskIntoConstraints = false
        iconMinOut.leadingAnchor.constraint(equalTo: view_balance.leadingAnchor, constant: 16).isActive = true
        iconMinOut.topAnchor.constraint(equalTo: view_balance.topAnchor, constant: 16).isActive = true
        iconMinOut.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iconMinOut.heightAnchor.constraint(equalToConstant: 24).isActive = true
       
        titleMinOut.translatesAutoresizingMaskIntoConstraints = false
        titleMinOut.leadingAnchor.constraint(equalTo: iconMinOut.trailingAnchor, constant: 9).isActive = true
        titleMinOut.trailingAnchor.constraint(equalTo: usageMinOut.leadingAnchor, constant: 9).isActive = true
        titleMinOut.centerYAnchor.constraint(equalTo: iconMinOut.centerYAnchor).isActive = true
    
        usageMinOut.translatesAutoresizingMaskIntoConstraints = false
        usageMinOut.trailingAnchor.constraint(equalTo: view_balance.trailingAnchor, constant: -16).isActive = true
      //  usageMinOut.topAnchor.constraint(equalTo: view_balance.topAnchor, constant: 15).isActive = true
        usageMinOut.centerYAnchor.constraint(equalTo: iconMinOut.centerYAnchor).isActive = true
        
        LineMinOut.translatesAutoresizingMaskIntoConstraints = false
        LineMinOut.leadingAnchor.constraint(equalTo: titleMinOut.leadingAnchor, constant: 0).isActive = true
        LineMinOut.trailingAnchor.constraint(equalTo: view_balance.trailingAnchor, constant: -16).isActive = true
        LineMinOut.topAnchor.constraint(equalTo: titleMinOut.bottomAnchor, constant: 15).isActive = true
        LineMinOut.heightAnchor.constraint(equalToConstant: 1).isActive = true
       
        view_balance.addSubview(iconMinIn)
        view_balance.addSubview(titleMinIn)
        view_balance.addSubview(usageMinIn)
        view_balance.addSubview(lineMinIn)
        
        //минуты внутри сети
                                
        iconMinIn.translatesAutoresizingMaskIntoConstraints = false
        iconMinIn.leadingAnchor.constraint(equalTo: view_balance.leadingAnchor, constant: 16).isActive = true
        iconMinIn.topAnchor.constraint(equalTo: LineMinOut.topAnchor, constant: 16).isActive = true
        iconMinIn.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iconMinIn.heightAnchor.constraint(equalToConstant: 20.73).isActive = true
                             
        titleMinIn.translatesAutoresizingMaskIntoConstraints = false
        titleMinIn.leadingAnchor.constraint(equalTo: iconMinIn.trailingAnchor, constant: 9).isActive = true
        titleMinOut.trailingAnchor.constraint(equalTo: usageMinIn.leadingAnchor, constant: 9).isActive = true
        titleMinIn.centerYAnchor.constraint(equalTo: iconMinIn.centerYAnchor).isActive = true
    
        usageMinIn.translatesAutoresizingMaskIntoConstraints = false
        usageMinIn.trailingAnchor.constraint(equalTo: view_balance.trailingAnchor, constant: -16).isActive = true
      //  usageMinOut.topAnchor.constraint(equalTo: view_balance.topAnchor, constant: 15).isActive = true
        usageMinIn.centerYAnchor.constraint(equalTo: iconMinIn.centerYAnchor).isActive = true
       
        lineMinIn.translatesAutoresizingMaskIntoConstraints = false
        lineMinIn.leadingAnchor.constraint(equalTo: titleMinIn.leadingAnchor, constant: 0).isActive = true
        lineMinIn.trailingAnchor.constraint(equalTo: view_balance.trailingAnchor, constant: -16).isActive = true
        lineMinIn.topAnchor.constraint(equalTo: titleMinIn.bottomAnchor, constant: 15).isActive = true
        lineMinIn.heightAnchor.constraint(equalToConstant: 1).isActive = true
      
        view_balance.addSubview(iconMB)
        view_balance.addSubview(titleMB)
        view_balance.addSubview(lineMb)
        view_balance.addSubview(usageMb)
        
        //mb
        
        iconMB.translatesAutoresizingMaskIntoConstraints = false
        iconMB.leadingAnchor.constraint(equalTo: view_balance.leadingAnchor, constant: 16).isActive = true
        iconMB.topAnchor.constraint(equalTo: lineMinIn.topAnchor, constant: 16).isActive = true
        iconMB.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iconMB.heightAnchor.constraint(equalToConstant: 24).isActive = true
                             
        titleMB.translatesAutoresizingMaskIntoConstraints = false
        titleMB.leadingAnchor.constraint(equalTo: iconMB.trailingAnchor, constant: 9).isActive = true
        titleMB.trailingAnchor.constraint(equalTo: usageMb.leadingAnchor, constant: 9).isActive = true
        titleMB.centerYAnchor.constraint(equalTo: iconMB.centerYAnchor).isActive = true
    
        usageMb.translatesAutoresizingMaskIntoConstraints = false
        usageMb.trailingAnchor.constraint(equalTo: view_balance.trailingAnchor, constant: -16).isActive = true
      //  usageMinOut.topAnchor.constraint(equalTo: view_balance.topAnchor, constant: 15).isActive = true
        usageMb.centerYAnchor.constraint(equalTo: iconMB.centerYAnchor).isActive = true
       
        lineMb.translatesAutoresizingMaskIntoConstraints = false
        lineMb.leadingAnchor.constraint(equalTo: titleMB.leadingAnchor, constant: 0).isActive = true
        lineMb.trailingAnchor.constraint(equalTo: view_balance.trailingAnchor, constant: -16).isActive = true
        lineMb.topAnchor.constraint(equalTo: titleMB.bottomAnchor, constant: 15).isActive = true
        lineMb.heightAnchor.constraint(equalToConstant: 1).isActive = true
 
        
        view_balance.addSubview(icomSms)
        view_balance.addSubview(titleSms)
        view_balance.addSubview(lineSms)
        view_balance.addSubview(usageSms)
        
        //sms
        
        icomSms.translatesAutoresizingMaskIntoConstraints = false
        icomSms.leadingAnchor.constraint(equalTo: view_balance.leadingAnchor, constant: 16).isActive = true
        icomSms.topAnchor.constraint(equalTo: lineMb.topAnchor, constant: 16).isActive = true
        icomSms.widthAnchor.constraint(equalToConstant: 24).isActive = true
        icomSms.heightAnchor.constraint(equalToConstant: 24).isActive = true
                             
        titleSms.translatesAutoresizingMaskIntoConstraints = false
        titleSms.leadingAnchor.constraint(equalTo: icomSms.trailingAnchor, constant: 9).isActive = true
        titleSms.trailingAnchor.constraint(equalTo: usageSms.leadingAnchor, constant: 9).isActive = true
        titleSms.centerYAnchor.constraint(equalTo: icomSms.centerYAnchor).isActive = true
    
        usageSms.translatesAutoresizingMaskIntoConstraints = false
        usageSms.trailingAnchor.constraint(equalTo: view_balance.trailingAnchor, constant: -16).isActive = true
      //  usageMinOut.topAnchor.constraint(equalTo: view_balance.topAnchor, constant: 15).isActive = true
        usageSms.centerYAnchor.constraint(equalTo: icomSms.centerYAnchor).isActive = true
       
        lineSms.translatesAutoresizingMaskIntoConstraints = false
        lineSms.leadingAnchor.constraint(equalTo: titleSms.leadingAnchor, constant: 0).isActive = true
        lineSms.trailingAnchor.constraint(equalTo: view_balance.trailingAnchor, constant: -16).isActive = true
        lineSms.topAnchor.constraint(equalTo: titleSms.bottomAnchor, constant: 15).isActive = true
        lineSms.heightAnchor.constraint(equalToConstant: 1).isActive = true
 
        view_balance.addSubview(iconMoneySpend)
        view_balance.addSubview(titleMoneySpend)
    //    view_balance.addSubview(lineMoney)
        view_balance.addSubview(usageMoney)
        
        //money
        
        iconMoneySpend.translatesAutoresizingMaskIntoConstraints = false
        iconMoneySpend.leadingAnchor.constraint(equalTo: view_balance.leadingAnchor, constant: 16).isActive = true
        iconMoneySpend.topAnchor.constraint(equalTo: lineSms.topAnchor, constant: 16).isActive = true
        iconMoneySpend.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iconMoneySpend.heightAnchor.constraint(equalToConstant: 24).isActive = true
        iconMoneySpend.bottomAnchor.constraint(equalTo: view_balance.bottomAnchor, constant: -16).isActive = true
        
        titleMoneySpend.translatesAutoresizingMaskIntoConstraints = false
        titleMoneySpend.leadingAnchor.constraint(equalTo: iconMoneySpend.trailingAnchor, constant: 9).isActive = true
        titleMoneySpend.trailingAnchor.constraint(equalTo: usageMoney.leadingAnchor, constant: 9).isActive = true
        titleMoneySpend.centerYAnchor.constraint(equalTo: iconMoneySpend.centerYAnchor).isActive = true
    
        usageMoney.translatesAutoresizingMaskIntoConstraints = false
        usageMoney.trailingAnchor.constraint(equalTo: view_balance.trailingAnchor, constant: -16).isActive = true
      //  usageMinOut.topAnchor.constraint(equalTo: view_balance.topAnchor, constant: 15).isActive = true
        usageMoney.centerYAnchor.constraint(equalTo: iconMoneySpend.centerYAnchor).isActive = true
       
      //  lineMoney.translatesAutoresizingMaskIntoConstraints = false
      //  lineMoney.leadingAnchor.constraint(equalTo: titleMoneySpend.leadingAnchor, constant: 0).isActive = true
      //  lineMoney.trailingAnchor.constraint(equalTo: view_balance.trailingAnchor, constant: -16).isActive = true
      //  lineMoney.topAnchor.constraint(equalTo: titleMoneySpend.bottomAnchor, constant: 15).isActive = true
      //  lineMoney.heightAnchor.constraint(equalToConstant: 1).isActive = true


     //   let heightConstraint = view_balance.heightAnchor.constraint(equalToConstant: 280)
        
        let height = view_balance.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
     //   {
           print("Высота view_balance: \(height)")
           // Обновляем ограничение высоты view_balance
     //  }
        view_balance.frame = CGRect(x: 20, y: 10, width: UIScreen.main.bounds.size.width - 40, height: height)
       
        
        contentView.addSubview(view_balance)
        //image.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingLeft: 16)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
