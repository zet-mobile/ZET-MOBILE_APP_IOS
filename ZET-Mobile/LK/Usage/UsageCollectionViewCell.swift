//
//  UsageCollectionViewCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/10/21.
//

import UIKit

class UsageCollectionViewCell: UICollectionViewCell {
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    let image: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Call_usage")
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        iv.frame = CGRect(x: 15, y: 10, width: 23, height: 23)
        return iv
    }()
    
    lazy var title1: UILabel = {
        let title = UILabel()
        title.text = defaultLocalizer.stringForKey(key: "zet_call")
        title.numberOfLines = 1
        title.textColor = colorBlackWhite
        title.font = UIFont.systemFont(ofSize: 16)
        title.textAlignment = .left
        title.frame = CGRect(x: 50, y: 0, width: 200, height: 45)
        
        return title
    }()
    
    lazy var rez1: UILabel = {
        let title = UILabel()
        title.text = ""
        title.numberOfLines = 1
        title.textColor = .orange
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textAlignment = .right
        title.frame = CGRect(x: 280, y: 0, width: 100, height: 45)
        
        return title
    }()
    
    lazy var Line1: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 50, y: 45, width: UIScreen.main.bounds.size.width - 105, height: 2)
        title.backgroundColor = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? .lightGray : UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1))
        return title
    }()
    
    let image2: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "zet")
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        iv.frame = CGRect(x: 15, y: 57, width: 23, height: 23)
        return iv
    }()
    
    lazy var title2: UILabel = {
        let title = UILabel()
        title.text = defaultLocalizer.stringForKey(key: "another_call")
        title.numberOfLines = 1
        title.textColor = colorBlackWhite
        title.font = UIFont.systemFont(ofSize: 16)
        title.textAlignment = .left
        title.frame = CGRect(x: 50, y: 47, width: 200, height: 45)
        
        return title
    }()
    
    lazy var rez2: UILabel = {
        let title = UILabel()
        title.text = ""
        title.numberOfLines = 1
        title.textColor = .orange
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textAlignment = .right
        title.frame = CGRect(x: 280, y: 47, width: 100, height: 45)
        
        return title
    }()
    
    lazy var Line2: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 50, y: 92, width: UIScreen.main.bounds.size.width - 105, height: 2)
        title.backgroundColor = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? .lightGray : UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1))
        return title
    }()
    
    let image3: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Chart")
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        iv.frame = CGRect(x: 15, y: 104, width: 27, height: 27)
        return iv
    }()
    
    lazy var title3: UILabel = {
        let title = UILabel()
        title.text = defaultLocalizer.stringForKey(key: "DATA")
        title.numberOfLines = 1
        title.textColor = colorBlackWhite
        title.font = UIFont.systemFont(ofSize: 16)
        title.textAlignment = .left
        title.frame = CGRect(x: 50, y: 94, width: 100, height: 45)
        
        return title
    }()
    
    lazy var rez3: UILabel = {
        let title = UILabel()
        title.text = ""
        title.numberOfLines = 1
        title.textColor = .orange
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textAlignment = .right
        title.frame = CGRect(x: 280, y: 94, width: 100, height: 45)
        
        return title
    }()
    
    lazy var Line3: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 50, y: 94, width: UIScreen.main.bounds.size.width - 105, height: 2)
        title.backgroundColor = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? .lightGray : UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1))
        return title
    }()
    
    let image4: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Message_usage")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        iv.frame = CGRect(x: 15, y: 151, width: 23, height: 23)
        return iv
    }()
    
    lazy var title4: UILabel = {
        let title = UILabel()
        title.text = defaultLocalizer.stringForKey(key: "SMS")
        title.numberOfLines = 1
        title.textColor = colorBlackWhite
        title.font = UIFont.systemFont(ofSize: 16)
        title.textAlignment = .left
        title.frame = CGRect(x: 50, y: 141, width: 100, height: 45)
        
        return title
    }()
    
    lazy var rez4: UILabel = {
        let title = UILabel()
        title.text = ""
        title.numberOfLines = 1
        title.textColor = .orange
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textAlignment = .right
        title.frame = CGRect(x: 280, y: 141, width: 100, height: 45)
        
        return title
    }()
    
    lazy var Line4: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 50, y: 141, width: UIScreen.main.bounds.size.width - 105, height: 2)
        title.backgroundColor = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? .lightGray : UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1))
        return title
    }()
    
    lazy var Line5: UILabel = {
        let title = UILabel()
        title.frame = CGRect(x: 50, y: 188, width: UIScreen.main.bounds.size.width - 105, height: 2)
        title.backgroundColor = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? .lightGray : UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1))
        return title
    }()
    
    let image5: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Call_usage")
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        iv.frame = CGRect(x: 15, y: 198, width: 23, height: 23)
        return iv
    }()
    
    lazy var title5: UILabel = {
        let title = UILabel()
        title.text = "Сомони"
        title.numberOfLines = 1
        title.textColor = colorBlackWhite
        title.font = UIFont.systemFont(ofSize: 16)
        title.textAlignment = .left
        title.frame = CGRect(x: 50, y: 188, width: 100, height: 45)
        
        return title
    }()
    
    lazy var rez5: UILabel = {
        let title = UILabel()
        title.text = ""
        title.numberOfLines = 1
        title.textColor = .orange
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textAlignment = .right
        title.frame = CGRect(x: 280, y: 188, width: 100, height: 45)
        
        return title
    }()
    
    var view_balance = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        view_balance.backgroundColor = colorGrayWhite
        view_balance.layer.cornerRadius = 10
        view_balance.frame = CGRect(x: 20, y: 0, width: UIScreen.main.bounds.size.width - 40, height: 240)
        
        view_balance.addSubview(image)
        view_balance.addSubview(title1)
        view_balance.addSubview(Line1)
        view_balance.addSubview(rez1)
        
        view_balance.addSubview(image2)
        
        view_balance.addSubview(title2)
        //contentView.addSubview(Line2)
        view_balance.addSubview(rez2)
        
        view_balance.addSubview(image3)
        view_balance.addSubview(title3)
        view_balance.addSubview(Line3)
        view_balance.addSubview(rez3)
        
        view_balance.addSubview(image4)
        view_balance.addSubview(title4)
        view_balance.addSubview(Line4)
        view_balance.addSubview(rez4)
        
        view_balance.addSubview(image5)
        view_balance.addSubview(title5)
        view_balance.addSubview(Line5)
        view_balance.addSubview(rez5)
        
        contentView.addSubview(view_balance)
        //image.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingLeft: 16)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
