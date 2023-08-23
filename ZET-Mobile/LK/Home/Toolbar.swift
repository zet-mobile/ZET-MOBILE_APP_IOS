//
//  Toolbar.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/2/21.
//

import Foundation
import UIKit

class Toolbar: UIView {
    
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
   
    lazy var welcome: UILabel = {
        let welcome = UILabel()
        welcome.text = defaultLocalizer.stringForKey(key: "GoodDay")
        welcome.numberOfLines = 0
        welcome.textColor = darkGrayLight
        welcome.font = UIFont(name: "", size: 12)
        welcome.lineBreakMode = NSLineBreakMode.byWordWrapping
        welcome.textAlignment = .left
        welcome.frame = CGRect(x: 20, y: 10, width: 300, height: 20)
        
        return welcome
    }()
    
    lazy var user_name: UILabel = {
        let user_name = UILabel()
        user_name.text = ""
        user_name.numberOfLines = 2
        user_name.textColor = colorBlackWhite
        user_name.font = UIFont.preferredFont(forTextStyle: .subheadline)
        user_name.font = UIFont.boldSystemFont(ofSize: (UIScreen.main.bounds.size.width * 18) / 390)
        user_name.lineBreakMode = NSLineBreakMode.byWordWrapping
        user_name.textAlignment = .left
        user_name.frame = CGRect(x: 20, y: 25, width: UIScreen.main.bounds.size.width - 60, height: 35)
        return user_name
    }()
    
    
    lazy var icon_more: UIButton = {
        let icon_more = UIButton()
        icon_more.setImage(#imageLiteral(resourceName: "more"), for: UIControl.State.normal)
        
        icon_more.frame = CGRect(x: 190, y: 38, width: 11, height: 6)
        icon_more.isUserInteractionEnabled = true
        icon_more.isEnabled = false
        icon_more.isHidden = true
        //openmenu.addTarget(self, action: #selector(goback), for: UIControl.Event.touchUpInside)
        return icon_more
    }()
    
    
    lazy var notificationRing: UIButton = {
        let notificationRing = UIButton()
        notificationRing.setImage((UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? #imageLiteral(resourceName: "Notification-1") : #imageLiteral(resourceName: "Notification")), for: UIControl.State.normal)
        notificationRing.frame = CGRect(x: 0, y: 21, width: 20, height: 20)
        notificationRing.isUserInteractionEnabled = true
        //openmenu.addTarget(self, action: #selector(goback), for: UIControl.Event.touchUpInside)
        return notificationRing
    }()
    
    lazy var icon_push: UIButton = {
        let icon_more = UIButton()
       // icon_more.setImage(#imageLiteral(resourceName: "push_count"), for: UIControl.State.normal)
        icon_more.setBackgroundImage(UIImage(named: "push_count"), for: .normal)
        icon_more.setTitle("40", for: .normal)
        icon_more.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        icon_more.setTitleColor(.black, for: .normal)
        icon_more.titleLabel?.textAlignment = .center
        icon_more.frame = CGRect(x: -6, y: 13, width: 22, height: 18)
        icon_more.isUserInteractionEnabled = true
        //icon_more.isEnabled = false
       // icon_more.isHidden = true
        //openmenu.addTarget(self, action: #selector(goback), for: UIControl.Event.touchUpInside)
        return icon_more
    }()
    
    lazy var openmenu: UIButton = {
        let openmenu = UIButton()
        openmenu.setImage((UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? #imageLiteral(resourceName: "menu_white") : #imageLiteral(resourceName: "menu")), for: UIControl.State.normal)
        
        openmenu.frame = CGRect(x: 20, y: 25, width: 20, height: 14)
        //openmenu.addTarget(self, action: #selector(goback), for: UIControl.Event.touchUpInside)
        return openmenu
    }()
    
    var view_menu = UIView()
    var view_notification = UIView()

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
       
        view_menu = UIView(frame: CGRect(x: UIScreen.main.bounds.size.width - 60, y: 0, width: UIScreen.main.bounds.size.width - (UIScreen.main.bounds.size.width - 60), height: frame.height))
        view_menu.backgroundColor = .clear
        
        view_notification = UIView(frame: CGRect(x: UIScreen.main.bounds.size.width - 75, y: 0, width: UIScreen.main.bounds.size.width - (UIScreen.main.bounds.size.width - 75), height: frame.height))
        view_notification.backgroundColor = .clear
        
        view_notification.addSubview(notificationRing)
        view_menu.addSubview(openmenu)
        view_menu.addSubview(icon_push)
        
        
        self.addSubview(view_notification)
        self.addSubview(view_menu)
   
        self.addSubview(welcome)
        self.addSubview(user_name)
        self.addSubview(icon_more)
       
       // self.addSubview(openmenu)
    }

}

