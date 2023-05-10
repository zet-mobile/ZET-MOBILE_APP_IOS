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
        titleOne.text = ""
        titleOne.numberOfLines = 0
        titleOne.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
        titleOne.font = UIFont.systemFont(ofSize: 16)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 20, y: 0, width: 300, height: 20)
        return titleOne
    }()
    
    lazy var old_code: UITextField = {
        let textfield = UITextField()
        textfield.keyboardType = .numberPad
        textfield.frame = CGRect(x: 20, y: 30, width: UIScreen.main.bounds.size.width - 40, height: 50)
        textfield.textColor = colorBlackWhite
        textfield.layer.cornerRadius = 16
        textfield.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        textfield.layer.borderWidth = 1
        textfield.isSecureTextEntry = true
        return textfield
    }()
    
    lazy var titleTwo: UILabel = {
        let titleOne = UILabel()
        titleOne.text = ""
        titleOne.numberOfLines = 0
        titleOne.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
        titleOne.font = UIFont.systemFont(ofSize: 16)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 20, y: 120, width: 300, height: 20)
        return titleOne
    }()
    
    lazy var new_code: UITextField = {
        let textfield = UITextField()
        textfield.frame = CGRect(x: 20, y: 150, width: UIScreen.main.bounds.size.width - 40, height: 50)
        textfield.keyboardType = .numberPad
        textfield.textColor = colorBlackWhite
        textfield.layer.cornerRadius = 16
        textfield.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        textfield.layer.borderWidth = 1
        textfield.isSecureTextEntry = true
        textfield.clearsOnBeginEditing = false
        return textfield
    }()
    
    lazy var titleThree: UILabel = {
        let titleOne = UILabel()
        titleOne.text = ""
        titleOne.numberOfLines = 0
        titleOne.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
        titleOne.font = UIFont.systemFont(ofSize: 16)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 20, y: 220, width: 300, height: 20)
        return titleOne
    }()
    
    lazy var confirm_code: UITextField = {
        let textfield = UITextField()
        textfield.frame = CGRect(x: 20, y: 260, width: UIScreen.main.bounds.size.width - 40, height: 50)
        textfield.keyboardType = .numberPad
        textfield.layer.cornerRadius = 16
        textfield.textColor = colorBlackWhite
        textfield.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        textfield.layer.borderWidth = 1
        textfield.isSecureTextEntry = true
        textfield.clearsOnBeginEditing = false
        return textfield
    }()
    
    lazy var title1: UILabel = {
        let titleOne = UILabel()
        titleOne.text = defaultLocalizer.stringForKey(key: "4_numbers")
        titleOne.numberOfLines = 0
        titleOne.textColor = colorBlackWhite
        titleOne.font = UIFont.systemFont(ofSize: 16)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 30, y: 20, width: 300, height: 20)
        return titleOne
    }()
    
     var title2: UILabel = {
        let titleOne = UILabel()
        titleOne.text = ""
        titleOne.numberOfLines = 2
        titleOne.textColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00)
        titleOne.font = UIFont.systemFont(ofSize: 16)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 20, y: 40, width: 300, height: 50)
        return titleOne
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 20, y: 0, width: CGFloat(Int(UIScreen.main.bounds.size.width) - 40), height: 50)
        button.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
        button.setTitle("", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.layer.cornerRadius = button.frame.height / 2
        
        return button
    }()
    
    var gray_back = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        
    }
    
    private func setupView() {
        //backgroundColor = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? colorFrom1 : colorTo1)
        
        gray_back = UIView(frame: CGRect(x: 20, y: 360, width: UIScreen.main.bounds.size.width - 40, height: 100))
        gray_back.backgroundColor = colorLightDarkGray
        gray_back.layer.cornerRadius = 20
        gray_back.addSubview(title1)
        gray_back.addSubview(title2)
        self.addSubview(gray_back)
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        old_code.leftView = paddingView
        old_code.leftViewMode = .always
        
        let paddingView2: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        new_code.leftView = paddingView2
        new_code.leftViewMode = .always
        
        let paddingView3: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        confirm_code.leftView = paddingView3
        confirm_code.leftViewMode = .always
        
        self.addSubview(titleOne)
        self.addSubview(titleTwo)
        self.addSubview(titleThree)
        self.addSubview(old_code)
        self.addSubview(new_code)
        self.addSubview(confirm_code)
        self.addSubview(button)
        
    }
}
