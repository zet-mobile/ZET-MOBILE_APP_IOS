//
//  ChangeView.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 1/15/22.
//

import UIKit

class ChangeView: UIView {

    lazy var titleOne: UILabel = {
        let titleOne = UILabel()
        titleOne.text = "Введите старый пароль"
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
    
    lazy var old_code: UITextField = {
        let textfield = UITextField()
        textfield.frame = CGRect(x: 20, y: 30, width: UIScreen.main.bounds.size.width - 40, height: 50)
        textfield.layer.cornerRadius = 16
        textfield.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        textfield.layer.borderWidth = 1
        textfield.isSecureTextEntry = true
        return textfield
    }()
    
    lazy var titleTwo: UILabel = {
        let titleOne = UILabel()
        titleOne.text = "Новый пароль"
        titleOne.numberOfLines = 0
        titleOne.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
        titleOne.font = UIFont.systemFont(ofSize: 16)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 20, y: 120, width: 300, height: 20)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleOne
    }()
    
    lazy var new_code: UITextField = {
        let textfield = UITextField()
        textfield.frame = CGRect(x: 20, y: 150, width: UIScreen.main.bounds.size.width - 40, height: 50)
        textfield.layer.cornerRadius = 16
        textfield.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        textfield.layer.borderWidth = 1
        textfield.isSecureTextEntry = true
        return textfield
    }()
    
    lazy var titleThree: UILabel = {
        let titleOne = UILabel()
        titleOne.text = "Повторите новый пароль"
        titleOne.numberOfLines = 0
        titleOne.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
        titleOne.font = UIFont.systemFont(ofSize: 16)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 20, y: 240, width: 300, height: 20)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleOne
    }()
    
    lazy var confirm_code: UITextField = {
        let textfield = UITextField()
        textfield.frame = CGRect(x: 20, y: 270, width: UIScreen.main.bounds.size.width - 40, height: 50)
        textfield.layer.cornerRadius = 16
        textfield.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        textfield.layer.borderWidth = 1
        textfield.isSecureTextEntry = true
        return textfield
    }()
    
    lazy var title1: UILabel = {
        let titleOne = UILabel()
        titleOne.text = "Не менее 8 символов"
        titleOne.numberOfLines = 0
        titleOne.textColor = .green
        titleOne.font = UIFont.systemFont(ofSize: 16)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 20, y: 10, width: 300, height: 20)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleOne
    }()
    
    lazy var title2: UILabel = {
        let titleOne = UILabel()
        titleOne.text = "Латинские буквы и цифры"
        titleOne.numberOfLines = 0
        titleOne.textColor = .black
        titleOne.font = UIFont.systemFont(ofSize: 16)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 20, y: 50, width: 300, height: 20)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleOne
    }()
    
    lazy var title3: UILabel = {
        let titleOne = UILabel()
        titleOne.text = "Специальные символы"
        titleOne.numberOfLines = 0
        titleOne.textColor = .red
        titleOne.font = UIFont.systemFont(ofSize: 16)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 20, y: 90, width: 300, height: 20)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleOne
    }()
    
    lazy var button: UIButton = {
        let button = UIButton(frame: CGRect(x: 20, y: Int(UIScreen.main.bounds.size.height) - 250, width: Int(UIScreen.main.bounds.size.width) - 40, height: 50))
        button.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
        button.setTitle("Изменить пароль", for: .normal)
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
        backgroundColor = .white
        
        let gray_back = UIView(frame: CGRect(x: 20, y: 360, width: UIScreen.main.bounds.size.width - 40, height: 120))
        gray_back.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
        gray_back.layer.cornerRadius = 20
        self.addSubview(gray_back)
        gray_back.addSubview(title1)
        gray_back.addSubview(title2)
        gray_back.addSubview(title3)
        
        self.addSubview(titleOne)
        self.addSubview(titleTwo)
        self.addSubview(titleThree)
        self.addSubview(old_code)
        self.addSubview(new_code)
        self.addSubview(confirm_code)
        self.addSubview(button)
        
    }
}
