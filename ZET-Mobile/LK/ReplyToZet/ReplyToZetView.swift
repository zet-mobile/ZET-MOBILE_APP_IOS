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
    
    lazy var emailLabel: UILabel = {
        let titleOne = UILabel()
        titleOne.text = defaultLocalizer.stringForKey(key: "E-mail_support")
        titleOne.numberOfLines = 0
        titleOne.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
        titleOne.font = UIFont.systemFont(ofSize: 16)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
      //  titleOne.frame = CGRect(x: 20, y: 0, width: 300, height: 20)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
       
        return titleOne
    }()
    
    lazy var email: UITextField = {
        let textfield = UITextField()
     //   textfield.frame = CGRect(x: 20, y: 30, width: UIScreen.main.bounds.size.width - 40, height: 50)
        textfield.layer.cornerRadius = 16
        textfield.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        textfield.layer.borderWidth = 1
        textfield.text = "info@zet-mobile.com"
        textfield.isUserInteractionEnabled = false
        textfield.backgroundColor = colorLine
        textfield.textColor = colorBlackWhite
        return textfield
    }()
    
    lazy var topicLabel: UILabel = {
        let titleOne = UILabel()
        titleOne.text = defaultLocalizer.stringForKey(key: "Message_subject")
        titleOne.numberOfLines = 0
        titleOne.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
        titleOne.font = UIFont.systemFont(ofSize: 16)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
     //   titleOne.frame = CGRect(x: 20, y: 100, width: 300, height: 20)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleOne
    }()
    
    lazy var messageTopic: DropDown = {
        let textfield = DropDown()
       // textfield.frame = CGRect(x: 20, y: 130, width: UIScreen.main.bounds.size.width - 40, height: 50)
        textfield.layer.cornerRadius = 16
        textfield.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        textfield.textColor = colorBlackWhite
        textfield.layer.borderWidth = 1
        textfield.setView(.right, image: UIImage(named: "drop_icon")).isUserInteractionEnabled = false
        return textfield
    }()
    
    //contact number
    
    lazy var titleContactNumber: UILabel = {
        let titleContactNumber = UILabel()
        titleContactNumber.text = defaultLocalizer.stringForKey(key: "FeedbackContactNumber")
        titleContactNumber.numberOfLines = 0
        titleContactNumber.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
        titleContactNumber.font = UIFont.systemFont(ofSize: 16)
        titleContactNumber.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleContactNumber.textAlignment = .left
       // titleContactNumber.frame = CGRect(x: 20, y: 200, width: 300, height: 20)
        titleContactNumber.autoresizesSubviews = true
        titleContactNumber.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleContactNumber
    }()
    
    let contactNumberView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CollectionPrizeViewCell.self, forCellWithReuseIdentifier: cellID3)
        cv.showsHorizontalScrollIndicator = false
      //  cv.frame = CGRect(x: 20, y: 230, width: UIScreen.main.bounds.size.width - 40, height: 50)
        cv.layer.cornerRadius = 16
        cv.layer.borderWidth = 1
        cv.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        cv.backgroundColor = .clear
        return cv
    }()
    
    lazy var contactNumberField: UITextField = {
        let textfield = UITextField()
       // textfield.frame = CGRect(x: prefixContactNumber.text!.count * 10 + 15, y: 230, width: 300, height: 50)
       // textfield.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        textfield.keyboardType = .numberPad
        //textfield.layer.cornerRadius = 16
        //textfield.layer.borderWidth = 1
        textfield.placeholder = "800800800"
       // textfield.text = "+992 "
        textfield.textAlignment = .left
        textfield.tag = 1
        textfield.font = UIFont.systemFont(ofSize: 16)
        textfield.textColor = colorBlackWhite
        textfield.backgroundColor = .clear
        return textfield
    }()
    
    lazy var prefixContactNumber: UILabel = {
        let prefixContactNumber = UILabel()
      //
     //   prefixContactNumber.frame = CGRect(x: 35, y: 230, width: UIScreen.main.bounds.size.width - 40, height: 50)
        prefixContactNumber.text = "+992 "
        prefixContactNumber.numberOfLines = 0
        prefixContactNumber.textColor = colorBlackWhite
        prefixContactNumber.font = UIFont.systemFont(ofSize: 16)
        prefixContactNumber.lineBreakMode = NSLineBreakMode.byWordWrapping
        prefixContactNumber.textAlignment = .left
        prefixContactNumber.autoresizesSubviews = true
        prefixContactNumber.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        prefixContactNumber.backgroundColor = .clear
        return prefixContactNumber
    }()
    
    
    lazy var messageLabel: UILabel = {
        let titleOne = UILabel()
        titleOne.text = defaultLocalizer.stringForKey(key: "your_message")
        titleOne.numberOfLines = 0
        titleOne.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
        titleOne.font = UIFont.systemFont(ofSize: 16)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
     //   titleOne.frame = CGRect(x: 20, y: 300, width: 300, height: 20)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleOne
    }()
    
    lazy var textOfMessage: UITextView = {
        let textfield = UITextView()
      //  textfield.frame = CGRect(x: 20, y: 330, width: UIScreen.main.bounds.size.width - 40, height: 150)
        textfield.layer.cornerRadius = 16
        textfield.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        textfield.layer.borderWidth = 1
        textfield.text = defaultLocalizer.stringForKey(key: "problem_detail")
        textfield.font = UIFont.systemFont(ofSize: 16)
        textfield.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        textfield.backgroundColor = .clear
        return textfield
    }()
    
    lazy var errorInfo: UILabel = {
        let titleRed = UILabel()
        titleRed.text = defaultLocalizer.stringForKey(key: "fill_problem")
        titleRed.numberOfLines = 0
        titleRed.textColor = .red
        titleRed.font = UIFont.systemFont(ofSize: 14)
        titleRed.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleRed.textAlignment = .left
      //  titleRed.frame = CGRect(x: 20, y: 490, width: UIScreen.main.bounds.size.width - 40, height: 20)
        titleRed.autoresizesSubviews = true
        titleRed.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        titleRed.isHidden = true
        return titleRed
    }()

    lazy var buttonAddScreen: UIButton = {
        let buttonAddScreen = UIButton(frame: CGRect(x: 40, y: 500, width: Int(UIScreen.main.bounds.size.width) - 80, height: 40))
        buttonAddScreen.backgroundColor = .clear
        buttonAddScreen.setTitle(defaultLocalizer.stringForKey(key: "Upload_Screenshot") + " ", for: .normal)
        buttonAddScreen.setTitleColor(.orange, for: .normal)
        buttonAddScreen.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        buttonAddScreen.layer.borderColor = UIColor.orange.cgColor
        buttonAddScreen.layer.borderWidth = 1
        buttonAddScreen.layer.cornerRadius = buttonAddScreen.frame.height / 2
        
        return buttonAddScreen
    }()

    lazy var button_send: UIButton = {
        let button = UIButton(frame: CGRect(x: 40, y: 560, width: Int(UIScreen.main.bounds.size.width) - 80, height: 40))
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
        
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        emailLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        emailLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        //+10
        
        email.translatesAutoresizingMaskIntoConstraints = false
        email.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        email.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10).isActive = true
        email.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        email.heightAnchor.constraint(equalToConstant: 50).isActive = true
          
        topicLabel.translatesAutoresizingMaskIntoConstraints = false
        topicLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        topicLabel.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 20).isActive = true
        topicLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        messageTopic.translatesAutoresizingMaskIntoConstraints = false
        messageTopic.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        messageTopic.topAnchor.constraint(equalTo: topicLabel.bottomAnchor, constant: 10).isActive = true
        messageTopic.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        messageTopic.heightAnchor.constraint(equalToConstant: 50).isActive = true
            

        titleContactNumber.translatesAutoresizingMaskIntoConstraints = false
        titleContactNumber.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        titleContactNumber.topAnchor.constraint(equalTo: messageTopic.bottomAnchor, constant: 20).isActive = true
        titleContactNumber.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
          
        contactNumberView.translatesAutoresizingMaskIntoConstraints = false
        contactNumberView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        contactNumberView.topAnchor.constraint(equalTo: titleContactNumber.bottomAnchor, constant: 10).isActive = true
        contactNumberView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        contactNumberView.heightAnchor.constraint(equalToConstant: 50).isActive = true
          
            
        prefixContactNumber.translatesAutoresizingMaskIntoConstraints = false
        prefixContactNumber.centerYAnchor.constraint(equalTo: contactNumberView.centerYAnchor).isActive = true
        prefixContactNumber.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 35).isActive = true
        prefixContactNumber.topAnchor.constraint(equalTo: titleContactNumber.bottomAnchor, constant: 10).isActive = true
           
        contactNumberField.translatesAutoresizingMaskIntoConstraints = false
        contactNumberField.centerYAnchor.constraint(equalTo: contactNumberView.centerYAnchor).isActive = true
        contactNumberField.centerYAnchor.constraint(equalTo: contactNumberView.centerYAnchor).isActive = true
        contactNumberField.leadingAnchor.constraint(equalTo: prefixContactNumber.trailingAnchor, constant: 1).isActive = true
        contactNumberField.topAnchor.constraint(equalTo: titleContactNumber.bottomAnchor, constant: 10).isActive = true
          
      
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        messageLabel.topAnchor.constraint(equalTo: contactNumberField.bottomAnchor, constant: 20).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        textOfMessage.translatesAutoresizingMaskIntoConstraints = false
        textOfMessage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        textOfMessage.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10).isActive = true
        textOfMessage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        textOfMessage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        errorInfo.translatesAutoresizingMaskIntoConstraints = false
        errorInfo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        errorInfo.topAnchor.constraint(equalTo: textOfMessage.bottomAnchor, constant: 10).isActive = true
        errorInfo.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        buttonAddScreen.translatesAutoresizingMaskIntoConstraints = false
        buttonAddScreen.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40).isActive = true
        buttonAddScreen.topAnchor.constraint(equalTo: textOfMessage.bottomAnchor, constant: 10).isActive = true
        buttonAddScreen.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40).isActive = true
        buttonAddScreen.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
        button_send.translatesAutoresizingMaskIntoConstraints = false
        button_send.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40).isActive = true
        button_send.topAnchor.constraint(equalTo: buttonAddScreen.bottomAnchor, constant: 20).isActive = true
        button_send.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40).isActive = true
        button_send.heightAnchor.constraint(equalToConstant: 40).isActive = true



         
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
        
        messageTopic.isSearchEnable = false
        messageTopic.selectedRowColor = .lightGray
        
        let paddingView2: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        messageTopic.leftView = paddingView2
        messageTopic.leftViewMode = .always
        
       // let paddingView3: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
       // contactNumberField.leftView = paddingView3
        contactNumberField.leftViewMode = .always
        
        contactNumberField.attributedPlaceholder = NSAttributedString(
            string: "800800800",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)])
        
        textOfMessage.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 4, right: 4)
        
        let icon = UIImage(named: "Img_box_light")!
        buttonAddScreen.setImage(icon, for: .normal)
        buttonAddScreen.imageView?.contentMode = .scaleAspectFit
        buttonAddScreen.semanticContentAttribute = .forceRightToLeft
        buttonAddScreen.layer.cornerRadius = buttonAddScreen.frame.height / 2
        
        self.addSubview(emailLabel)
        self.addSubview(topicLabel)
        
        self.addSubview(titleContactNumber)
        self.addSubview(contactNumberView)
        self.addSubview(prefixContactNumber)
        self.addSubview(contactNumberField)
      
    
        self.addSubview(messageLabel)
        self.addSubview(email)
        self.addSubview(messageTopic)
        self.addSubview(textOfMessage)
        self.addSubview(errorInfo)
        self.addSubview(buttonAddScreen)
        self.addSubview(button_send)

    }
    

    
}
