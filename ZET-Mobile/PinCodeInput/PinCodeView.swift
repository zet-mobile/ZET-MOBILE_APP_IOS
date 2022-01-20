//
//  PinCodeView.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 1/9/22.
//

import UIKit

class PinCodeView: UIView {

    lazy var titleOne: UILabel = {
        let titleOne = UILabel()
        titleOne.text = "введите пин-код"
        titleOne.numberOfLines = 0
        titleOne.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
        titleOne.font = UIFont.systemFont(ofSize: 16)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .center
        titleOne.frame = CGRect(x: 20, y: 80, width: UIScreen.main.bounds.size.width - 40, height: 20)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleOne
    }()
    
    lazy var number1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
        view.frame = CGRect(x: (UIScreen.main.bounds.size.width / 2) - 85, y: 120, width: 20, height: 20)
        view.layer.cornerRadius = view.frame.size.height / 2
        return view
    }()
    
    lazy var number2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
        view.frame = CGRect(x: (UIScreen.main.bounds.size.width / 2) - 35, y: 120, width: 20, height: 20)
        view.layer.cornerRadius = view.frame.size.height / 2
        return view
    }()
    
    lazy var number3: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
        view.frame = CGRect(x: (UIScreen.main.bounds.size.width / 2) + 15, y: 120, width: 20, height: 20)
        view.layer.cornerRadius = view.frame.size.height / 2
        return view
    }()
    
    lazy var number4: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
        view.frame = CGRect(x: (UIScreen.main.bounds.size.width / 2) + 65, y: 120, width: 20, height: 20)
        view.layer.cornerRadius = view.frame.size.height / 2
        return view
    }()
    
    lazy var button1: UIButton = {
        let button = UIButton(frame: CGRect(x: (UIScreen.main.bounds.size.width / 2) - 160, y: 250, width: 80, height: 80))
        button.backgroundColor = .clear
        button.setTitle("1", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 36)
        button.titleLabel?.textAlignment = .center
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        button.layer.cornerRadius = button.frame.height / 2
        button.showsTouchWhenHighlighted = true
      
        return button
    }()

    lazy var button2: UIButton = {
        let button = UIButton(frame: CGRect(x: (UIScreen.main.bounds.size.width / 2) - 40, y: 250, width: 80, height: 80))
        button.backgroundColor = .clear
        button.setTitle("2", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 36)
        button.titleLabel?.textAlignment = .center
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        button.layer.cornerRadius = button.frame.height / 2
        button.showsTouchWhenHighlighted = true
        return button
    }()
    
    lazy var button3: UIButton = {
        let button = UIButton(frame: CGRect(x: (UIScreen.main.bounds.size.width / 2) + 80, y: 250, width: 80, height: 80))
        button.backgroundColor = .clear
        button.setTitle("3", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 36)
        button.titleLabel?.textAlignment = .center
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        button.layer.cornerRadius = button.frame.height / 2
        button.showsTouchWhenHighlighted = true
        return button
    }()
    
    lazy var button4: UIButton = {
        let button = UIButton(frame: CGRect(x: (UIScreen.main.bounds.size.width / 2) - 160, y: 380, width: 80, height: 80))
        button.backgroundColor = .clear
        button.setTitle("4", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 36)
        button.titleLabel?.textAlignment = .center
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        button.layer.cornerRadius = button.frame.height / 2
        button.showsTouchWhenHighlighted = true
        return button
    }()
    
    lazy var button5: UIButton = {
        let button = UIButton(frame: CGRect(x: (UIScreen.main.bounds.size.width / 2) - 40, y: 380, width: 80, height: 80))
        button.backgroundColor = .clear
        button.setTitle("5", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 36)
        button.titleLabel?.textAlignment = .center
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        button.layer.cornerRadius = button.frame.height / 2
        button.showsTouchWhenHighlighted = true
        return button
    }()
    
    lazy var button6: UIButton = {
        let button = UIButton(frame: CGRect(x: (UIScreen.main.bounds.size.width / 2) + 80, y: 380, width: 80, height: 80))
        button.backgroundColor = .clear
        button.setTitle("6", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 36)
        button.titleLabel?.textAlignment = .center
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        button.layer.cornerRadius = button.frame.height / 2
        button.showsTouchWhenHighlighted = true
        return button
    }()
    
    lazy var button7: UIButton = {
        let button = UIButton(frame: CGRect(x: (UIScreen.main.bounds.size.width / 2) - 160, y: 510, width: 80, height: 80))
        button.backgroundColor = .clear
        button.setTitle("7", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 36)
        button.titleLabel?.textAlignment = .center
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        button.layer.cornerRadius = button.frame.height / 2
        button.showsTouchWhenHighlighted = true
        return button
    }()
    
    lazy var button8: UIButton = {
        let button = UIButton(frame: CGRect(x: (UIScreen.main.bounds.size.width / 2) - 40, y: 510, width: 80, height: 80))
        button.backgroundColor = .clear
        button.setTitle("8", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 36)
        button.titleLabel?.textAlignment = .center
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        button.layer.cornerRadius = button.frame.height / 2
        button.showsTouchWhenHighlighted = true
        return button
    }()
    
    lazy var button9: UIButton = {
        let button = UIButton(frame: CGRect(x: (UIScreen.main.bounds.size.width / 2) + 80, y: 510, width: 80, height: 80))
        button.backgroundColor = .clear
        button.setTitle("9", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 36)
        button.titleLabel?.textAlignment = .center
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        button.layer.cornerRadius = button.frame.height / 2
        button.showsTouchWhenHighlighted = true
        return button
    }()
    
    lazy var button0: UIButton = {
        let button = UIButton(frame: CGRect(x: (UIScreen.main.bounds.size.width / 2) - 40, y: 640, width: 80, height: 80))
        button.backgroundColor = .clear
        button.setTitle("0", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 36)
        button.titleLabel?.textAlignment = .center
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        button.layer.cornerRadius = button.frame.height / 2
        button.showsTouchWhenHighlighted = true
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
        
        let back = UIView(frame: CGRect(x: 20, y: 100, width: UIScreen.main.bounds.size.width - 40, height: 50))
        back.backgroundColor = .clear
        
       // self.addSubview(back)
        
        self.addSubview(titleOne)
        self.addSubview(number1)
        self.addSubview(number2)
        self.addSubview(number3)
        self.addSubview(number4)

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
    }
}
