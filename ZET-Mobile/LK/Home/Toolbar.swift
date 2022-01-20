//
//  Toolbar.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/2/21.
//

import Foundation
import UIKit

class Toolbar: UIView {
    
    lazy var zetImage: UIImageView = {
        let zetImage = UIImageView()
        zetImage.image = nil
        zetImage.image = UIImage(named: "image_user")
        zetImage.frame = CGRect(x: 20, y: 5, width: 48, height: 48)
        
        //let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(zetClick))
        zetImage.isUserInteractionEnabled = true
        //zetImage.addGestureRecognizer(tapGestureRecognizer)
        
        return zetImage
    }()
    
    lazy var welcome: UILabel = {
        let welcome = UILabel()
        welcome.text = "Добрый день"
        welcome.numberOfLines = 0
        welcome.textColor = .darkGray
        welcome.font = UIFont(name: "", size: 12)
        welcome.lineBreakMode = NSLineBreakMode.byWordWrapping
        welcome.textAlignment = .left
        welcome.frame = CGRect(x: 80, y: 5, width: 300, height: 20)
        
        return welcome
    }()
    
    lazy var user_name: UILabel = {
        let user_name = UILabel()
        user_name.text = "Mehrangez"
        user_name.numberOfLines = 0
        user_name.textColor = .black
        user_name.font = UIFont.preferredFont(forTextStyle: .subheadline)
        user_name.font = UIFont.boldSystemFont(ofSize: 20)
        user_name.lineBreakMode = NSLineBreakMode.byWordWrapping
        user_name.textAlignment = .left
        user_name.frame = CGRect(x: 80, y: 25, width: 200, height: 28)
        
        return user_name
    }()
    
    
    lazy var icon_more: UIButton = {
        let icon_more = UIButton()
        icon_more.setImage(#imageLiteral(resourceName: "more"), for: UIControl.State.normal)
        
        icon_more.frame = CGRect(x: 210, y: 38, width: 11, height: 6)
        //openmenu.addTarget(self, action: #selector(goback), for: UIControl.Event.touchUpInside)
        return icon_more
    }()
    
    lazy var openmenu: UIButton = {
        let openmenu = UIButton()
        openmenu.setImage(#imageLiteral(resourceName: "menu"), for: UIControl.State.normal)
        
        openmenu.frame = CGRect(x: UIScreen.main.bounds.size.width - 40, y: 25, width: 20, height: 14)
        //openmenu.addTarget(self, action: #selector(goback), for: UIControl.Event.touchUpInside)
        return openmenu
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        
    }
    
    private func setupView() {
        backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
       
        self.addSubview(zetImage)
        self.addSubview(welcome)
        self.addSubview(user_name)
        self.addSubview(icon_more)
        self.addSubview(openmenu)
    }
}

