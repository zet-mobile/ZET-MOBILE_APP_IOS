//
//  AskFriendView.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 17/05/22.
//

import UIKit

class AskFriendView: UIView {

    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    lazy var image_banner: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "exchannge_mini")
        image.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 160)
        return image
    }()
    
    lazy var titleOne: UILabel = {
        let titleOne = UILabel()
        titleOne.text = defaultLocalizer.stringForKey(key: "Balance_and_packages")
        titleOne.numberOfLines = 0
        titleOne.textColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1)
        titleOne.font = UIFont(name: "", size: 10)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 20, y: 170, width: 300, height: 28)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleOne
    }()
    
    lazy var balance: UILabel = {
        let user_name = UILabel()
        user_name.text = "m mm"
        user_name.numberOfLines = 0
        user_name.textColor = colorBlackWhite
        user_name.font = UIFont.boldSystemFont(ofSize: 24)
        user_name.lineBreakMode = NSLineBreakMode.byWordWrapping
        user_name.textAlignment = .right
        user_name.frame = CGRect(x: 20, y: 170, width: 200, height: 28)
        
        return user_name
    }()
    
    lazy var titleNum: UILabel = {
        let titleOne = UILabel()
        titleOne.text = defaultLocalizer.stringForKey(key: "Friend's number")
        titleOne.numberOfLines = 0
        titleOne.textColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1)
        titleOne.font = UIFont(name: "", size: 10)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 20, y: 220, width: 300, height: 20)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleOne
    }()
    
    lazy var user_to_number: UITextField = {
        let user_to_number = UITextField()
        user_to_number.frame = CGRect(x: 20, y: 250, width: UIScreen.main.bounds.size.width - 40, height: 50)
        user_to_number.layer.cornerRadius = 16
        user_to_number.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        user_to_number.layer.borderWidth = 1
        user_to_number.textColor = colorBlackWhite
        user_to_number.text = "+992 "
        user_to_number.tag = 1
        
        return user_to_number
    }()
    
    lazy var titleRed: UILabel = {
        let titleRed = UILabel()
        titleRed.text = defaultLocalizer.stringForKey(key: "Invalid_recipient_number")
        titleRed.numberOfLines = 0
        titleRed.textColor = .red
        titleRed.font = UIFont(name: "", size: 9)
        titleRed.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleRed.textAlignment = .left
        titleRed.frame = CGRect(x: 20, y: 310, width: 300, height: 20)
        titleRed.autoresizesSubviews = true
        titleRed.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        titleRed.isHidden = true
        return titleRed
    }()
    
    lazy var titleCount: UILabel = {
        let titleTwo = UILabel()
        titleTwo.text = defaultLocalizer.stringForKey(key: "Translation_Amount")
        titleTwo.numberOfLines = 0
        titleTwo.textColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1)
        titleTwo.font = UIFont(name: "", size: 10)
        titleTwo.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleTwo.textAlignment = .left
        titleTwo.frame = CGRect(x: 20, y: 350, width: 300, height: 20)
        titleTwo.autoresizesSubviews = true
        titleTwo.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleTwo
    }()
    
    lazy var count_transfer: UITextField = {
        let count_transfer = UITextField()
        count_transfer.frame = CGRect(x: 20, y: 380, width: UIScreen.main.bounds.size.width - 40, height: 50)
        count_transfer.layer.cornerRadius = 16
        count_transfer.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        count_transfer.layer.borderWidth = 1
        count_transfer.tag = 2
        count_transfer.textColor = colorBlackWhite
        
        return count_transfer
    }()
   
    lazy var titleRed2: UILabel = {
        let titleRed = UILabel()
        titleRed.text = defaultLocalizer.stringForKey(key: "Input cost")
        titleRed.numberOfLines = 0
        titleRed.textColor = .red
        titleRed.font = UIFont(name: "", size: 9)
        titleRed.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleRed.textAlignment = .left
        titleRed.frame = CGRect(x: 20, y: 440, width: 300, height: 20)
        titleRed.autoresizesSubviews = true
        titleRed.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        titleRed.isHidden = false
        return titleRed
    }()

    lazy var sendButton: UIButton = {
        let sendButton = UIButton()
        sendButton.frame = CGRect(x: 20, y: Int(UIScreen.main.bounds.size.height) - Int(ContainerViewController().tabBar.frame.size.height) - 200, width: Int(UIScreen.main.bounds.size.width) - 40, height: 45)
        sendButton.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
        sendButton.setTitle(defaultLocalizer.stringForKey(key: "Transfer"), for: .normal)
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        sendButton.layer.cornerRadius = sendButton.frame.height / 2
        return sendButton
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
        backgroundColor = .clear
       
        let white_view_back2 = UIView(frame: CGRect(x: 0, y: 210, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - ContainerViewController().tabBar.frame.size.height - 330))
    
        white_view_back2.backgroundColor = contentColor
        self.addSubview(white_view_back2)
        self.sendSubviewToBack(white_view_back2)
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        user_to_number.leftView = paddingView
        user_to_number.leftViewMode = .always
        
        let paddingView2: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        count_transfer.leftView = paddingView2
        count_transfer.leftViewMode = .always
        
        self.addSubview(image_banner)
        self.addSubview(titleOne)
        self.addSubview(balance)
        self.addSubview(titleNum)
        self.addSubview(user_to_number)
        self.addSubview(titleCount)
        self.addSubview(titleRed)
        self.addSubview(titleRed2)
        self.addSubview(count_transfer)
        self.addSubview(sendButton)
    }

}

