//
//  AuthorizationView.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 2/20/22.
//

import UIKit

class AuthorizationView: UIView {

    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    lazy var zet_image_top: UIImageView = {
        let image = UIImageView()
        image.image = nil
        image.image = UIImage(named: "zet_auth")
        image.frame = CGRect(x: (UIScreen.main.bounds.size.width / 2) - ((UIScreen.main.bounds.size.width * 150) / 428) / 2, y: (UIScreen.main.bounds.size.height * 90) / 926, width: (UIScreen.main.bounds.size.width * 170) / 428, height: (UIScreen.main.bounds.size.height * 130) / 926)
        
        return image
    }()
    
    lazy var image_top: UIImageView = {
        let image = UIImageView()
        image.image = nil
        image.image = UIImage(named: "top_auth_img")
        image.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: (UIScreen.main.bounds.size.height * 300) / 926)
        
        return image
    }()

    lazy var numberField: UITextField = {
        let textfield = UITextField()
        textfield.frame = CGRect(x: 20, y: (UIScreen.main.bounds.size.height * 360) / 926, width: UIScreen.main.bounds.size.width - 40, height: 50)
        textfield.borderStyle = .none
        textfield.backgroundColor = colorLightDarkGray
        textfield.keyboardType = .numberPad
        textfield.layer.cornerRadius = 16
        textfield.layer.borderColor = colorLightDarkGray.cgColor
        textfield.layer.borderWidth = 1
        /*textfield.placeholder = "Введите номер телефона"
        textfield.font = UIFont.systemFont(ofSize: 15)*/
        return textfield
    }()
    
    lazy var title_number_info: UILabel = {
        let title = UILabel()
        title.text = defaultLocalizer.stringForKey(key: "Incorrect_number")
        title.numberOfLines = 1
        title.textColor = .red
        title.font = UIFont.systemFont(ofSize: 14)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 25, y: (UIScreen.main.bounds.size.height * 420) / 926, width: 200, height: 20)
        title.autoresizesSubviews = true
        title.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        title.isHidden = true
        return title
    }()
    
    lazy var title_info: UILabel = {
        let title = UILabel()
        title.text = defaultLocalizer.stringForKey(key: "receive_SMS")
        title.numberOfLines = 2
        title.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
        title.font = UIFont.systemFont(ofSize: 14)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .center
        title.frame = CGRect(x: 10, y: (UIScreen.main.bounds.size.height * 410) / 926, width: UIScreen.main.bounds.size.width - 20, height: 50)
        title.autoresizesSubviews = true
        title.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        title.isHidden = false
        return title
    }()
    
    lazy var check_condition: UIButton = {
        let button = UIButton(frame: CGRect(x: 30, y: (UIScreen.main.bounds.size.height * 470) / 926, width: 23, height: 23))
        button.backgroundColor = .clear
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.titleLabel?.textAlignment = .center
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        button.layer.cornerRadius = 5
        button.showsTouchWhenHighlighted = true
        button.isHidden = false
        return button
    }()
    
    lazy var get_sms: UIButton = {
        let button = UIButton(frame: CGRect(x: 20, y: (UIScreen.main.bounds.size.height * 520) / 926, width: UIScreen.main.bounds.size.width - 40, height: 50))
        button.setTitle(defaultLocalizer.stringForKey(key: "Get_sms"), for: .normal)
        //button.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = button.frame.height / 2
        button.isEnabled = false
        button.backgroundColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        return button
    }()
    
    lazy var lang_set: UIButton = {
        let button = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width - 100, y: UIScreen.main.bounds.size.height - (UIScreen.main.bounds.size.height * 70) / 926, width: 80, height: (UIScreen.main.bounds.size.height * 50) / 926))
        button.setTitle("RU 🇷🇺", for: .normal)
        button.backgroundColor = colorLightDarkGray
        button.setTitleColor(colorBlackWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 10
        return button
    }()
    
    lazy var title_condition: UILabel = {
        let title = UILabel()
        return title
    }()
    
    lazy var code_field: UITextField = {
        let textfield = UITextField()
        textfield.frame = CGRect(x: 20, y: (UIScreen.main.bounds.size.height * 430) / 926, width: 150, height: 50)
        textfield.borderStyle = .none
        textfield.backgroundColor = colorLightDarkGray
        textfield.layer.cornerRadius = 10
        textfield.placeholder = defaultLocalizer.stringForKey(key: "Enter_SMS")
        textfield.font = UIFont.systemFont(ofSize: 15)
        textfield.isHidden = true
        textfield.keyboardType = .numberPad
        textfield.layer.cornerRadius = 16
        textfield.layer.borderColor = colorLightDarkGray.cgColor
        textfield.layer.borderWidth = 1
        return textfield
    }()
    
    lazy var title_code_info: UILabel = {
        let title = UILabel()
        title.text = defaultLocalizer.stringForKey(key: "Incorrect_code")
        title.numberOfLines = 1
        title.textColor = .red
        title.font = UIFont.systemFont(ofSize: 14)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 25, y: (UIScreen.main.bounds.size.height * 490) / 926, width: 200, height: 20)
        title.autoresizesSubviews = true
        title.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        title.isHidden = true
        return title
    }()
    
    lazy var time_symbol: UIImageView = {
        let im = UIImageView()
        im.image = UIImage(named: "clock.png")
        im.frame = CGRect(x: 185, y: (UIScreen.main.bounds.size.height * 435) / 926, width: 20, height: 20)
        im.isHidden = true
        return im
    }()
    
    lazy var timer_label: UILabel = {
        let title = UILabel()
        title.text = "01:59"
        title.numberOfLines = 1
        title.textColor = colorBlackWhite
        title.font = UIFont.systemFont(ofSize: 14)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 210, y: (UIScreen.main.bounds.size.height * 435) / 926, width: 150, height: 20)
        title.autoresizesSubviews = true
        title.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        title.isHidden = true
        return title
    }()
    
    lazy var symbol_label: UILabel = {
        let title = UILabel()
        title.text = ""
        title.numberOfLines = 1
        title.textColor = colorBlackWhite
        title.font = UIFont.systemFont(ofSize: 14)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .center
        title.frame = CGRect(x: 230, y: (UIScreen.main.bounds.size.height * 435) / 926, width: 5, height: 20)
        title.autoresizesSubviews = true
        title.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        title.isHidden = true
        return title
    }()
    
    lazy var second_label: UILabel = {
        let title = UILabel()
        title.text = ""
        title.numberOfLines = 1
        title.textColor = colorBlackWhite
        title.font = UIFont.systemFont(ofSize: 14)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .center
        title.frame = CGRect(x: 235, y: (UIScreen.main.bounds.size.height * 435) / 926, width: 20, height: 20)
        title.autoresizesSubviews = true
        title.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        title.isHidden = true
        return title
    }()
    
    lazy var send_again: UILabel = {
        let title = UILabel()
        title.text = defaultLocalizer.stringForKey(key: "Отправить ещё раз")
        title.numberOfLines = 1
        title.textColor = .orange
        title.font = UIFont.systemFont(ofSize: 15)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 185, y: (UIScreen.main.bounds.size.height * 459) / 926, width: (UIScreen.main.bounds.size.width * 200) / 428, height: 20)
        title.autoresizesSubviews = true
        title.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        title.isHidden = true
        return title
    }()
    
    //language menu
    
    lazy var ru_button: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: (UIScreen.main.bounds.size.height * 50) / 926))
        button.setTitle("RU 🇷🇺", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(colorBlackWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.titleLabel?.textAlignment = .left
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    lazy var eng_but: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: (UIScreen.main.bounds.size.height * 50) / 926, width: 80, height: (UIScreen.main.bounds.size.height * 50) / 926))
        button.setTitle("ENG 🇺🇸", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(colorBlackWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.titleLabel?.textAlignment = .left
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    lazy var tj_but: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: (UIScreen.main.bounds.size.height * 100) / 926, width: 80, height: (UIScreen.main.bounds.size.height * 50) / 926))
        button.setTitle("TJK 🇹🇯", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(colorBlackWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.titleLabel?.textAlignment = .left
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    lazy var uz_but: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: (UIScreen.main.bounds.size.height * 150) / 926, width: 80, height: (UIScreen.main.bounds.size.height * 50) / 926))
        button.setTitle("UZB 🇺🇿", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(colorBlackWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.titleLabel?.textAlignment = .left
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    var view_lang = UIView()
    
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
       
        title_condition.frame = CGRect(x: 65, y: (UIScreen.main.bounds.size.height * 470) / 926, width: UIScreen.main.bounds.size.width - 70, height: 23)
        let cost: NSString = defaultLocalizer.stringForKey(key: "Agree_with") as NSString
        let range = (cost).range(of: cost as String)
        let costString = NSMutableAttributedString.init(string: cost as String)
        costString.addAttribute(NSAttributedString.Key.foregroundColor, value: colorBlackWhite, range: range)
        costString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: range)
        
        let title_cost = " \(defaultLocalizer.stringForKey(key: "agree_conditions"))" as NSString
        let titleString = NSMutableAttributedString.init(string: title_cost as String)
        let range2 = (title_cost).range(of: title_cost as String)
        titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange , range: range2)
        titleString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: range2)
        
        costString.append(titleString)
        title_condition.attributedText = costString
        title_condition.textAlignment = .left
        title_condition.isHidden = false
        title_condition.frame.size.width = CGFloat(title_condition.text?.count ?? 0) * 10
        
        let code_number: NSString = "+992" as NSString
        let range3 = (code_number).range(of: code_number as String)
        let code_numberString = NSMutableAttributedString.init(string: code_number as String)
        code_numberString.addAttribute(NSAttributedString.Key.foregroundColor, value: colorBlackWhite , range: range3)
        code_numberString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: range3)
        
        let title_number = " \(defaultLocalizer.stringForKey(key: "Enter_phone"))" as NSString
        let title_numberString = NSMutableAttributedString.init(string: title_number as String)
        let range4 = (title_number).range(of: title_number as String)
        title_numberString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.gray , range: range4)
        title_numberString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: range4)
        
        code_numberString.append(title_numberString)
        
        numberField.attributedText = code_numberString
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        numberField.leftView = paddingView
        numberField.leftViewMode = .always
        
        let paddingView2: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        code_field.leftView = paddingView2
        code_field.leftViewMode = .always
        
        view_lang = UIView(frame: CGRect(x: UIScreen.main.bounds.size.width - 100, y: UIScreen.main.bounds.size.height - (UIScreen.main.bounds.size.height * 270) / 926, width: 70, height: (UIScreen.main.bounds.size.height * 200) / 926))
        view_lang.backgroundColor = .clear
        view_lang.isHidden = true
    
        
        self.addSubview(zet_image_top)
        self.addSubview(image_top)
        self.sendSubviewToBack(image_top)
        self.addSubview(numberField)
        self.addSubview(title_info)
        self.addSubview(check_condition)
        self.addSubview(title_condition)
        self.addSubview(get_sms)
        self.addSubview(lang_set)
        
        self.addSubview(code_field)
        self.addSubview(title_number_info)
        self.addSubview(title_code_info)
        self.addSubview(send_again)
        self.addSubview(timer_label)
        self.addSubview(time_symbol)
       // self.addSubview(second_label)
        //self.addSubview(symbol_label)
        
        view_lang.addSubview(ru_button)
        view_lang.addSubview(eng_but)
        view_lang.addSubview(tj_but)
        view_lang.addSubview(uz_but)
        self.addSubview(view_lang)
    }
}
