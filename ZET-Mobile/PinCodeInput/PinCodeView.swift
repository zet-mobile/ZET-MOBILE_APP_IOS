//
//  PinCodeView.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 1/9/22.
//

import UIKit

class PinCodeView: UIView {

    lazy var image: UIImageView = {
        let image = UIImageView()
        image.image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIImage(named: "Frame 150 1") : UIImage(named: "zet 1-2"))
        image.frame = CGRect(x: UIScreen.main.bounds.size.width / 2 - 80, y: 40, width: 160, height: 25)
        return image
    }()
    
    lazy var titleOne: UILabel = {
        let titleOne = UILabel()
        titleOne.text = defaultLocalizer.stringForKey(key: "Enter_PIN").uppercased()
        titleOne.numberOfLines = 0
        titleOne.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
        titleOne.font = UIFont.systemFont(ofSize: 18)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .center
        titleOne.frame = CGRect(x: (UIScreen.main.bounds.size.width * 20) / 428, y: (UIScreen.main.bounds.size.height * 100) / 926, width: UIScreen.main.bounds.size.width - (UIScreen.main.bounds.size.width * 40) / 428, height: (UIScreen.main.bounds.size.height * 20) / 926)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleOne
    }()
    
    lazy var titleTryies: UILabel = {
        let titleOne = UILabel()
        titleOne.text = ""
        titleOne.numberOfLines = 2
        titleOne.textColor = UIColor(red: 0.92, green: 0.34, blue: 0.34, alpha: 1.00)
        titleOne.font = UIFont.systemFont(ofSize: 16)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .center
        titleOne.isHidden = true
        titleOne.frame = CGRect(x: (UIScreen.main.bounds.size.width * 20) / 428, y: (UIScreen.main.bounds.size.height * 170) / 926, width: UIScreen.main.bounds.size.width - (UIScreen.main.bounds.size.width * 40) / 428, height: (UIScreen.main.bounds.size.height * 60) / 926)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleOne
    }()

    
    lazy var number1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
        view.frame = CGRect(x: (UIScreen.main.bounds.size.width / 2) - (UIScreen.main.bounds.size.width * 60) / 428, y: (UIScreen.main.bounds.size.height * 150) / 926, width: (UIScreen.main.bounds.size.height * 15) / 926, height: (UIScreen.main.bounds.size.height * 15) / 926)
        view.layer.cornerRadius = view.frame.size.height / 2
        return view
    }()
    
    lazy var number2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
        view.frame = CGRect(x: (UIScreen.main.bounds.size.width / 2) - (UIScreen.main.bounds.size.width * 25) / 428, y: (UIScreen.main.bounds.size.height * 150) / 926, width: (UIScreen.main.bounds.size.height * 15) / 926, height: (UIScreen.main.bounds.size.height * 15) / 926)
        view.layer.cornerRadius = view.frame.size.height / 2
        return view
    }()
    
    lazy var number3: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
        view.frame = CGRect(x: (UIScreen.main.bounds.size.width / 2) + (UIScreen.main.bounds.size.width * 10) / 428, y: (UIScreen.main.bounds.size.height * 150) / 926, width: (UIScreen.main.bounds.size.height * 15) / 926, height: (UIScreen.main.bounds.size.height * 15) / 926)
        view.layer.cornerRadius = view.frame.size.height / 2
        return view
    }()
    
    lazy var number4: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
        view.frame = CGRect(x: (UIScreen.main.bounds.size.width / 2) + (UIScreen.main.bounds.size.width * 45) / 428, y: (UIScreen.main.bounds.size.height * 150) / 926, width: (UIScreen.main.bounds.size.height * 15) / 926, height: (UIScreen.main.bounds.size.height * 15) / 926)
        view.layer.cornerRadius = view.frame.size.height / 2
        return view
    }()
    
    lazy var button1: UIButton = {
        let button = UIButton(frame: CGRect(x: (UIScreen.main.bounds.size.width / 2) - (UIScreen.main.bounds.size.width * 150) / 428, y: (UIScreen.main.bounds.size.height * 250) / 926, width: (UIScreen.main.bounds.size.height * 80) / 926, height: (UIScreen.main.bounds.size.height * 80) / 926))
        button.backgroundColor = .clear
        button.setTitle("1", for: .normal)
        button.setTitleColor(colorBlackWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button.titleLabel?.textAlignment = .center
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        button.layer.cornerRadius = button.frame.height / 2
      
        return button
    }()

    lazy var button2: UIButton = {
        let button = UIButton(frame: CGRect(x: (UIScreen.main.bounds.size.width / 2) - (UIScreen.main.bounds.size.width * 40) / 428, y: (UIScreen.main.bounds.size.height * 250) / 926, width: (UIScreen.main.bounds.size.height * 80) / 926, height: (UIScreen.main.bounds.size.height * 80) / 926))
        button.backgroundColor = .clear
        button.setTitle("2", for: .normal)
        button.setTitleColor(colorBlackWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button.titleLabel?.textAlignment = .center
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        button.layer.cornerRadius = button.frame.height / 2
        
        return button
    }()
    
    lazy var button3: UIButton = {
        let button = UIButton(frame: CGRect(x: (UIScreen.main.bounds.size.width / 2) + (UIScreen.main.bounds.size.width * 70) / 428, y: (UIScreen.main.bounds.size.height * 250) / 926, width: (UIScreen.main.bounds.size.height * 80) / 926, height: (UIScreen.main.bounds.size.height * 80) / 926))
        button.backgroundColor = .clear
        button.setTitle("3", for: .normal)
        button.setTitleColor(colorBlackWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button.titleLabel?.textAlignment = .center
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        button.layer.cornerRadius = button.frame.height / 2
      
        return button
    }()
    
    lazy var button4: UIButton = {
        let button = UIButton(frame: CGRect(x: (UIScreen.main.bounds.size.width / 2) - (UIScreen.main.bounds.size.width * 150) / 428, y: (UIScreen.main.bounds.size.height * 360) / 926, width: (UIScreen.main.bounds.size.height * 80) / 926, height: (UIScreen.main.bounds.size.height * 80) / 926))
        button.backgroundColor = .clear
        button.setTitle("4", for: .normal)
        button.setTitleColor(colorBlackWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button.titleLabel?.textAlignment = .center
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        button.layer.cornerRadius = button.frame.height / 2

        return button
    }()
    
    lazy var button5: UIButton = {
        let button = UIButton(frame: CGRect(x: (UIScreen.main.bounds.size.width / 2) - (UIScreen.main.bounds.size.width * 40) / 428, y: (UIScreen.main.bounds.size.height * 360) / 926, width: (UIScreen.main.bounds.size.height * 80) / 926, height: (UIScreen.main.bounds.size.height * 80) / 926))
        button.backgroundColor = .clear
        button.setTitle("5", for: .normal)
        button.setTitleColor(colorBlackWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button.titleLabel?.textAlignment = .center
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        button.layer.cornerRadius = button.frame.height / 2
       
        return button
    }()
    
    lazy var button6: UIButton = {
        let button = UIButton(frame: CGRect(x: (UIScreen.main.bounds.size.width / 2) + (UIScreen.main.bounds.size.width * 70) / 428, y: (UIScreen.main.bounds.size.height * 360) / 926, width: (UIScreen.main.bounds.size.height * 80) / 926, height: (UIScreen.main.bounds.size.height * 80) / 926))
        button.backgroundColor = .clear
        button.setTitle("6", for: .normal)
        button.setTitleColor(colorBlackWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button.titleLabel?.textAlignment = .center
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        button.layer.cornerRadius = button.frame.height / 2
       
        return button
    }()
    
    lazy var button7: UIButton = {
        let button = UIButton(frame: CGRect(x: (UIScreen.main.bounds.size.width / 2) - (UIScreen.main.bounds.size.width * 150) / 428, y: (UIScreen.main.bounds.size.height * 470) / 926, width: (UIScreen.main.bounds.size.height * 80) / 926, height: (UIScreen.main.bounds.size.height * 80) / 926))
        button.backgroundColor = .clear
        button.setTitle("7", for: .normal)
        button.setTitleColor(colorBlackWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button.titleLabel?.textAlignment = .center
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        button.layer.cornerRadius = button.frame.height / 2
        
        return button
    }()
    
    lazy var button8: UIButton = {
        let button = UIButton(frame: CGRect(x: (UIScreen.main.bounds.size.width / 2) - (UIScreen.main.bounds.size.width * 40) / 428, y: (UIScreen.main.bounds.size.height * 470) / 926, width: (UIScreen.main.bounds.size.height * 80) / 926, height: (UIScreen.main.bounds.size.height * 80) / 926))
        button.backgroundColor = .clear
        button.setTitle("8", for: .normal)
        button.setTitleColor(colorBlackWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button.titleLabel?.textAlignment = .center
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        button.layer.cornerRadius = button.frame.height / 2
     
        return button
    }()
    
    lazy var button9: UIButton = {
        let button = UIButton(frame: CGRect(x: (UIScreen.main.bounds.size.width / 2) + (UIScreen.main.bounds.size.width * 70) / 428, y: (UIScreen.main.bounds.size.height * 470) / 926, width: (UIScreen.main.bounds.size.height * 80) / 926, height: (UIScreen.main.bounds.size.height * 80) / 926))
        button.backgroundColor = .clear
        button.setTitle("9", for: .normal)
        button.setTitleColor(colorBlackWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button.titleLabel?.textAlignment = .center
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        button.layer.cornerRadius = button.frame.height / 2
        
        return button
    }()
    
    lazy var button0: UIButton = {
        let button = UIButton(frame: CGRect(x: (UIScreen.main.bounds.size.width / 2) - (UIScreen.main.bounds.size.width * 40) / 428, y: (UIScreen.main.bounds.size.height * 580) / 926, width: (UIScreen.main.bounds.size.height * 80) / 926, height: (UIScreen.main.bounds.size.height * 80) / 926))
        button.backgroundColor = .clear
        button.setTitle("0", for: .normal)
        button.setTitleColor(colorBlackWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button.titleLabel?.textAlignment = .center
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        button.layer.cornerRadius = button.frame.height / 2
        
        return button
    }()
    
    lazy var forget_but: UIButton = {
        let button = UIButton(frame: CGRect(x: (UIScreen.main.bounds.size.width / 2) - (UIScreen.main.bounds.size.width * 150) / 428, y: (UIScreen.main.bounds.size.height * 580) / 926, width: (UIScreen.main.bounds.size.height * 80) / 926, height: (UIScreen.main.bounds.size.height * 80) / 926))
        button.backgroundColor = .clear
        button.setTitle(defaultLocalizer.stringForKey(key: "FORGOT_PASSWORD?"), for: .normal)
        button.setTitleColor(colorBlackWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: (UIScreen.main.bounds.size.height * 11) / 926)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 4
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        button.layer.cornerRadius = button.frame.height / 2
        button.titleLabel?.lineBreakMode = .byClipping
        return button
    }()
    
//    lazy var delete: UIButton = {
//        let button = UIButton(frame: CGRect(x: (UIScreen.main.bounds.size.width / 2) + (UIScreen.main.bounds.size.width * 70) / 428, y: (UIScreen.main.bounds.size.height * 580) / 926, width: (UIScreen.main.bounds.size.height * 80) / 926, height: (UIScreen.main.bounds.size.height * 80) / 926))
//        button.backgroundColor = .clear
//        button.setTitle("", for: .normal)
//        button.setImage((UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ?
//            #imageLiteral(resourceName: "delete.left.fill") :
//            #imageLiteral(resourceName: "delete.left.fill")), for: UIControl.State.normal)
//        button.setTitleColor(colorBlackWhite, for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
//        button.titleLabel?.textAlignment = .center
//        button.layer.borderWidth = 1
//        button.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
//        button.layer.cornerRadius = button.frame.height / 2
//
//        return button
//    }()
    
    
    lazy var delete: UIButton = {
        let button = UIButton(frame: CGRect(x: (UIScreen.main.bounds.size.width / 2) + (UIScreen.main.bounds.size.width * 70) / 428, y: (UIScreen.main.bounds.size.height * 580) / 926, width: (UIScreen.main.bounds.size.height * 80) / 926, height: (UIScreen.main.bounds.size.height * 80) / 926))
        button.backgroundColor = .clear
        button.setTitle("", for: .normal)
        
        if let image = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? #imageLiteral(resourceName: "delete.left.fill") : #imageLiteral(resourceName: "delete.left.fill")) {
            let templateImage = image.withRenderingMode(.alwaysTemplate)
            button.setImage(templateImage, for: .normal)
            button.tintColor = .black
        }
        
        button.setTitleColor(colorBlackWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button.titleLabel?.textAlignment = .center
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
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
       // backgroundColor = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? colorFrom1 : colorTo1)
        
        let back = UIView(frame: CGRect(x: 20, y: 100, width: UIScreen.main.bounds.size.width - 40, height: 50))
        back.backgroundColor = .clear
        
       // self.addSubview(back)
        
        self.addSubview(image)
        self.addSubview(titleOne)
        self.addSubview(number1)
        self.addSubview(number2)
        self.addSubview(number3)
        self.addSubview(number4)
        self.addSubview(titleTryies)
        
        self.addSubview(button1)
        self.addSubview(button2)
        self.addSubview(button3)
        self.addSubview(button4)
        self.addSubview(button5)
        self.addSubview(button6)
        self.addSubview(button7)
        self.addSubview(button8)
        self.addSubview(button9)
        self.addSubview(button0)
        self.addSubview(forget_but)
        self.addSubview(delete)
    }
}
