//
//  ReplyToZetView.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 1/9/22.
//

import UIKit
import iOSDropDown

class ReplyToZetView: UIView {

    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    lazy var titleOne: UILabel = {
        let titleOne = UILabel()
        titleOne.text = defaultLocalizer.stringForKey(key: "E-mail_support")
        titleOne.numberOfLines = 0
        titleOne.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
        titleOne.font = UIFont.systemFont(ofSize: 16)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 20, y: 0, width: 300, height: 20)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
       
        return titleOne
    }()
    
    lazy var email: UITextField = {
        let textfield = UITextField()
        textfield.frame = CGRect(x: 20, y: 30, width: UIScreen.main.bounds.size.width - 40, height: 50)
        textfield.layer.cornerRadius = 16
        textfield.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        textfield.layer.borderWidth = 1
        textfield.text = "info@zet-mobile.com"
        textfield.isUserInteractionEnabled = false
        textfield.backgroundColor = colorLine
        
        return textfield
    }()
    
    lazy var titleTwo: UILabel = {
        let titleOne = UILabel()
        titleOne.text = defaultLocalizer.stringForKey(key: "Message_subject")
        titleOne.numberOfLines = 0
        titleOne.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
        titleOne.font = UIFont.systemFont(ofSize: 16)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 20, y: 100, width: 300, height: 20)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleOne
    }()
    
    lazy var type_message: DropDown = {
        let textfield = DropDown()
        textfield.frame = CGRect(x: 20, y: 130, width: UIScreen.main.bounds.size.width - 40, height: 50)
        textfield.layer.cornerRadius = 16
        textfield.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        textfield.layer.borderWidth = 1
        textfield.setView(.right, image: UIImage(named: "drop_icon")).isUserInteractionEnabled = false
        return textfield
    }()

    lazy var titleThree: UILabel = {
        let titleOne = UILabel()
        titleOne.text = defaultLocalizer.stringForKey(key: "your_message")
        titleOne.numberOfLines = 0
        titleOne.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
        titleOne.font = UIFont.systemFont(ofSize: 16)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 20, y: 200, width: 300, height: 20)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleOne
    }()
    
    lazy var text_message: UITextView = {
        let textfield = UITextView()
        textfield.frame = CGRect(x: 20, y: 230, width: UIScreen.main.bounds.size.width - 40, height: 150)
        textfield.layer.cornerRadius = 16
        textfield.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        textfield.layer.borderWidth = 1
        textfield.text = "Опишите проблему"
        textfield.font = UIFont.systemFont(ofSize: 16)
        textfield.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        textfield.backgroundColor = .clear
        return textfield
    }()
    
    lazy var button: UIButton = {
        let button = UIButton(frame: CGRect(x: 40, y: 400, width: Int(UIScreen.main.bounds.size.width) - 80, height: 40))
        button.backgroundColor = .clear
        button.setTitle(defaultLocalizer.stringForKey(key: "Upload_Screenshot"), for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.layer.borderColor = UIColor.orange.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = button.frame.height / 2
        
        return button
    }()

    lazy var button_send: UIButton = {
        let button = UIButton(frame: CGRect(x: 40, y: 460, width: Int(UIScreen.main.bounds.size.width) - 80, height: 40))
        button.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
        button.setTitle(defaultLocalizer.stringForKey(key: "Send"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.layer.cornerRadius = button.frame.height / 2
        
        return button
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
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        email.leftView = paddingView
        email.leftViewMode = .always
        
        type_message.isSearchEnable = false
        type_message.selectedRowColor = .lightGray
        let paddingView2: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        type_message.leftView = paddingView2
        type_message.leftViewMode = .always
        
        
        self.addSubview(titleOne)
        self.addSubview(titleTwo)
        self.addSubview(titleThree)
        self.addSubview(email)
        self.addSubview(type_message)
        self.addSubview(text_message)
        
        self.addSubview(button)
        self.addSubview(button_send)

    }
    
}
