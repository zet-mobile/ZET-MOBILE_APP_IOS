//
//  TarifView.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/5/21.
//

import UIKit

class TarifView: UIView {

    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    lazy var zetImage: UIImageView = {
        let zetImage = UIImageView()
       // zetImage.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "Active_Tarif — dark") : UIImage(named: "Active_Tarif"))
        zetImage.frame = CGRect(x: 20, y: 5, width: 48, height: 48)
        
        return zetImage
    }()
    
    lazy var welcome: UILabel = {
        let welcome = UILabel()
        welcome.text = ""
        welcome.numberOfLines = 0
        welcome.textColor = colorBlackWhite
        welcome.font = UIFont.systemFont(ofSize: 22)
        welcome.lineBreakMode = NSLineBreakMode.byWordWrapping
        welcome.textAlignment = .left
        welcome.frame = CGRect(x: 85, y: 5, width: 300, height: 30)
        
        return welcome
    }()
    
    lazy var user_name: UILabel = {
        let user_name = UILabel()
        user_name.text = ""
        user_name.numberOfLines = 0
        user_name.textColor = darkGrayLight
        user_name.font = UIFont.preferredFont(forTextStyle: .subheadline)
        user_name.font = UIFont.systemFont(ofSize: 15)
        user_name.lineBreakMode = NSLineBreakMode.byWordWrapping
        user_name.textAlignment = .left
        user_name.frame = CGRect(x: 85, y: 35, width: 300, height: 25)
        
        return user_name
    }()
    
    lazy var titleOne: UILabel = {
        let title = UILabel()
        title.text = defaultLocalizer.stringForKey(key: "Your_tariff")
        title.numberOfLines = 0
        title.textColor = colorBlackWhite
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.boldSystemFont(ofSize: 19)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 20, y: 195, width: 200, height: 30)
        
        return title
    }()
    
    lazy var titleOneRes: UILabel = {
        let title = UILabel()
        title.text = ""
        title.numberOfLines = 0
        title.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.systemFont(ofSize: 17)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .right
        
        title.frame = CGRect(x: UIScreen.main.bounds.size.width - 215, y: 195, width: 200, height: 30)
        
        return title
    }()
    
    
    lazy var tab1: UILabel = {
        let title = UILabel()
        title.text = defaultLocalizer.stringForKey(key: "Available")
        title.numberOfLines = 0
        title.textColor = colorBlackWhite
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.systemFont(ofSize: 17)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .center
        //title.frame = CGRect(x: 0, y: 550, width: UIScreen.main.bounds.size.width / 2, height: 50)
        return title
    }()
    
    lazy var tab1Line: UILabel = {
        let title = UILabel()
        //title.frame = CGRect(x: 20, y: 600, width: UIScreen.main.bounds.size.width / 2 - 20, height: 3)
        title.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 0.00, alpha: 1.00)
        return title
    }()
    
    lazy var tab2: UILabel = {
        let title = UILabel()
        title.text = defaultLocalizer.stringForKey(key: "Set_plan")
        title.numberOfLines = 0
        title.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        title.font = UIFont.preferredFont(forTextStyle: .subheadline)
        title.font = UIFont.systemFont(ofSize: 17)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .center
        title.isHidden = true
        //title.frame = CGRect(x: UIScreen.main.bounds.size.width / 2 - 20, y: 550, width: UIScreen.main.bounds.size.width / 2 - 20, height: 50)
            
        return title
    }()
    
    lazy var tab2Line: UILabel = {
        let title = UILabel()
        //title.frame = CGRect(x: UIScreen.main.bounds.size.width / 2, y: 600, width: UIScreen.main.bounds.size.width / 2, height: 10)
        title.backgroundColor = .clear
        title.isHidden = true
        return title
    }()
    
    lazy var unlimits: UIImageView = {
        let zetImage = UIImageView()
        zetImage.image = nil
        zetImage.image = UIImage(named: "VK_black")
        zetImage.frame = CGRect(x: 20, y: 400, width: 30, height: 30)
        
        //let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(zetClick))
        zetImage.isUserInteractionEnabled = true
        //zetImage.addGestureRecognizer(tapGestureRecognizer)
        
        return zetImage
    }()
    
    var white_view_back = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        
    }
    
    private func setupView() {
        backgroundColor = toolbarColor
       
        white_view_back = UIView(frame: CGRect(x: 0, y: 180, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        white_view_back.backgroundColor = contentColor
        
        self.addSubview(white_view_back)
        self.sendSubviewToBack(white_view_back)
        
        self.addSubview(zetImage)
        self.addSubview(welcome)
        self.addSubview(user_name)
        self.addSubview(titleOne)
        self.addSubview(tab1)
        self.addSubview(tab2)
        self.addSubview(tab1Line)
        self.addSubview(tab2Line)
        
        
        self.addSubview(titleOneRes)
    }
}

