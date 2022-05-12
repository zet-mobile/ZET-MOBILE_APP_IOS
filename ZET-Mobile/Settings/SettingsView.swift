//
//  SettingsView.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 1/9/22.
//

import UIKit
import iOSDropDown

class SettingsView: UIView {

    lazy var title: UILabel = {
        let titleOne = UILabel()
        titleOne.text = "Внешний вид"
        titleOne.numberOfLines = 0
        titleOne.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
        titleOne.font = UIFont.systemFont(ofSize: 18)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 20, y: 5, width: 300, height: 20)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleOne
    }()
    
    lazy var titleOne: UILabel = {
        let titleOne = UILabel()
        titleOne.text = "Язык"
        titleOne.numberOfLines = 0
        titleOne.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
        titleOne.font = UIFont.systemFont(ofSize: 16)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 20, y: 50, width: 300, height: 20)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleOne
    }()
    
    lazy var lang: DropDown = {
        let textfield = DropDown()
        textfield.frame = CGRect(x: 20, y: 80, width: UIScreen.main.bounds.size.width - 40, height: 50)
        textfield.layer.cornerRadius = 16
        textfield.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        textfield.layer.borderWidth = 1
        textfield.setView(.right, image: UIImage(named: "drop_icon"))
        return textfield
    }()
    
    lazy var titleTwo: UILabel = {
        let titleOne = UILabel()
        titleOne.text = "Тема приложения"
        titleOne.numberOfLines = 0
        titleOne.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
        titleOne.font = UIFont.systemFont(ofSize: 16)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 20, y: 170, width: 300, height: 20)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleOne
    }()
    
    lazy var app_theme: DropDown = {
        let textfield = DropDown()
        textfield.frame = CGRect(x: 20, y: 200, width: UIScreen.main.bounds.size.width - 40, height: 50)
        textfield.layer.cornerRadius = 16
        textfield.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        textfield.layer.borderWidth = 1
        textfield.setView(.right, image: UIImage(named: "drop_icon"))
        return textfield
    }()
    
    lazy var title_push: UILabel = {
        let titleOne = UILabel()
        titleOne.text = "Уведомления"
        titleOne.numberOfLines = 0
        titleOne.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
        titleOne.font = UIFont.systemFont(ofSize: 18)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 20, y: 300, width: 300, height: 20)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleOne
    }()
    
    lazy var switch_push: UISwitch = {
        let switch_ = UISwitch()
        switch_.onTintColor = .orange
        switch_.frame = CGRect(x: 20, y: 350, width: 0, height: 0)
        switch_.setFrame(width: 50, height: 27)
        return switch_
    }()
    
    lazy var push_t: UILabel = {
        let titleOne = UILabel()
        titleOne.text = "Push-уведомления"
        titleOne.numberOfLines = 0
        titleOne.textColor = colorBlackWhite
        titleOne.font = UIFont.systemFont(ofSize: 18)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 90, y: 350, width: 300, height: 30)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleOne
    }()
    
    lazy var switch_sales: UISwitch = {
        let switch_ = UISwitch()
        switch_.onTintColor = .orange
        switch_.frame = CGRect(x: 20, y: 400, width: 0, height: 0)
        switch_.setFrame(width: 50, height: 27)
        return switch_
    }()
    
    lazy var sales_t: UILabel = {
        let titleOne = UILabel()
        titleOne.text = "Акции, предложения"
        titleOne.numberOfLines = 0
        titleOne.textColor = colorBlackWhite
        titleOne.font = UIFont.systemFont(ofSize: 18)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 90, y: 400, width: 300, height: 30)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleOne
    }()

    lazy var switch_email: UISwitch = {
        let switch_ = UISwitch()
        switch_.onTintColor = .orange
        switch_.frame = CGRect(x: 20, y: 450, width: 0, height: 0)
        switch_.setFrame(width: 50, height: 27)
        return switch_
    }()
    
    lazy var email_t: UILabel = {
        let titleOne = UILabel()
        titleOne.text = "E-mail рассылка"
        titleOne.numberOfLines = 0
        titleOne.textColor = colorBlackWhite
        titleOne.font = UIFont.systemFont(ofSize: 18)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 90, y: 450, width: 300, height: 30)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleOne
    }()
    
    lazy var switch_sms: UISwitch = {
        let switch_ = UISwitch()
        switch_.onTintColor = .orange
        switch_.frame = CGRect(x: 20, y: 500, width: 0, height: 0)
        switch_.setFrame(width: 50, height: 27)
        return switch_
    }()
    
    lazy var sms_t: UILabel = {
        let titleOne = UILabel()
        titleOne.text = "SMS уведомления"
        titleOne.numberOfLines = 0
        titleOne.textColor = colorBlackWhite
        titleOne.font = UIFont.systemFont(ofSize: 18)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 90, y: 500, width: 300, height: 30)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleOne
    }()
    
    lazy var title_code: UILabel = {
        let titleOne = UILabel()
        titleOne.text = "Безопасность"
        titleOne.numberOfLines = 0
        titleOne.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
        titleOne.font = UIFont.systemFont(ofSize: 18)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 20, y: 570, width: 300, height: 20)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleOne
    }()
    
    lazy var code_change_t: UILabel = {
        let titleOne = UILabel()
        titleOne.text = "Изменить пароль"
        titleOne.numberOfLines = 0
        titleOne.textColor = colorBlackWhite
        titleOne.font = UIFont.systemFont(ofSize: 18)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 20, y: 620, width: 300, height: 30)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        titleOne.isUserInteractionEnabled = true
        return titleOne
    }()
    
    lazy var icon_but: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: UIScreen.main.bounds.size.width - 50, y: 620, width: 30, height: 30)
        button.setImage(#imageLiteral(resourceName: "next_arrow"), for: UIControl.State.normal)
        return button
    }()
    
    lazy var switch_enter: UISwitch = {
        let switch_ = UISwitch()
        switch_.isOn = true
        switch_.onTintColor = .orange
        switch_.frame = CGRect(x: 20, y: 670, width: 0, height: 0)
        switch_.setFrame(width: 50, height: 27)
        return switch_
    }()
    
    lazy var enter_t: UILabel = {
        let titleOne = UILabel()
        titleOne.text = "Вход по биометрии"
        titleOne.numberOfLines = 0
        titleOne.textColor = colorBlackWhite
        titleOne.font = UIFont.systemFont(ofSize: 18)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 90, y: 670, width: 300, height: 30)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleOne
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
        backgroundColor = contentColor
        
        self.addSubview(title)
        self.addSubview(titleOne)
        self.addSubview(titleTwo)
        self.addSubview(lang)
        self.addSubview(app_theme)
        
        self.addSubview(title_push)
        self.addSubview(switch_push)
        self.addSubview(push_t)
        self.addSubview(switch_sales)
        self.addSubview(sales_t)
        self.addSubview(switch_email)
        self.addSubview(email_t)
        self.addSubview(switch_sms)
        self.addSubview(sms_t)
        
        self.addSubview(title_code)
        self.addSubview(code_change_t)
        self.addSubview(icon_but)
        self.addSubview(enter_t)
        self.addSubview(switch_enter)
        
    }
}
