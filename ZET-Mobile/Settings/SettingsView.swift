//
//  SettingsView.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 1/9/22.
//

import UIKit
import iOSDropDown

class SettingsView: UIView {

    lazy var appearanceTitle: UILabel = {
        let appearanceTitle = UILabel()
        appearanceTitle.text = defaultLocalizer.stringForKey(key: "APPEARANCE")
        appearanceTitle.numberOfLines = 0
        appearanceTitle.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
        appearanceTitle.font = UIFont.systemFont(ofSize: 18)
        appearanceTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
        appearanceTitle.textAlignment = .left
        appearanceTitle.autoresizesSubviews = true
        appearanceTitle.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return appearanceTitle
    }()
    
    lazy var languageTitle: UILabel = {
        let languageTitle = UILabel()
        languageTitle.text = defaultLocalizer.stringForKey(key: "LANGUAGE")
        languageTitle.numberOfLines = 0
        languageTitle.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
        languageTitle.font = UIFont.systemFont(ofSize: 16)
        languageTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
        languageTitle.textAlignment = .left
        languageTitle.autoresizesSubviews = true
        languageTitle.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return languageTitle
    }()
    
    lazy var chooseLang: DropDown = {
        let chooseLang = DropDown()
        chooseLang.layer.cornerRadius = 16
        chooseLang.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        chooseLang.layer.borderWidth = 1
        chooseLang.setView(.right, image: UIImage(named: "drop_icon")).isUserInteractionEnabled = false
        return chooseLang
    }()
    
    lazy var themeTitle: UILabel = {
        let themeTitle = UILabel()
        themeTitle.text = defaultLocalizer.stringForKey(key: "APP_THEME")
        themeTitle.numberOfLines = 0
        themeTitle.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
        themeTitle.font = UIFont.systemFont(ofSize: 16)
        themeTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
        themeTitle.textAlignment = .left
        themeTitle.autoresizesSubviews = true
        themeTitle.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return themeTitle
    }()
    
    lazy var chooseTheme: DropDown = {
        let chooseTheme = DropDown()
        chooseTheme.layer.cornerRadius = 16
        chooseTheme.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        chooseTheme.layer.borderWidth = 1
        chooseTheme.setView(.right, image: UIImage(named: "drop_icon")).isUserInteractionEnabled = false
        return chooseTheme
    }()
    
    lazy var notificationTitle: UILabel = {
        let notificationTitle = UILabel()
        notificationTitle.text = defaultLocalizer.stringForKey(key: "NOTIFICATIONS")
        notificationTitle.numberOfLines = 0
        notificationTitle.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
        notificationTitle.font = UIFont.systemFont(ofSize: 18)
        notificationTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
        notificationTitle.textAlignment = .left
        notificationTitle.autoresizesSubviews = true
        notificationTitle.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return notificationTitle
    }()
    
    lazy var pushSwitch: UISwitch = {
        let pushSwitch = UISwitch()
        pushSwitch.onTintColor = .orange
        pushSwitch.setFrame(width: 50, height: 27)
        return pushSwitch
    }()
    
    lazy var pushSwitchTitle: UILabel = {
        let pushSwitchTitle = UILabel()
        pushSwitchTitle.text = defaultLocalizer.stringForKey(key: "PUSH_NOTIFICATIONS")
        pushSwitchTitle.numberOfLines = 0
        pushSwitchTitle.textColor = colorBlackWhite
        pushSwitchTitle.font = UIFont.systemFont(ofSize: 18)
        pushSwitchTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
        pushSwitchTitle.textAlignment = .left
        pushSwitchTitle.autoresizesSubviews = true
        pushSwitchTitle.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return pushSwitchTitle
    }()
    
    lazy var promotionsSwitch: UISwitch = {
        let promotionsSwitch = UISwitch()
        promotionsSwitch.onTintColor = .orange
        promotionsSwitch.setFrame(width: 50, height: 27)
        return promotionsSwitch
    }()
    
    lazy var promotionsTitle: UILabel = {
        let promotionsTitle = UILabel()
        promotionsTitle.text = defaultLocalizer.stringForKey(key: "PROMOTIONS")
        promotionsTitle.numberOfLines = 0
        promotionsTitle.textColor = colorBlackWhite
        promotionsTitle.font = UIFont.systemFont(ofSize: 18)
        promotionsTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
        promotionsTitle.textAlignment = .left
        promotionsTitle.autoresizesSubviews = true
        promotionsTitle.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return promotionsTitle
    }()


    lazy var smsSwitch: UISwitch = {
        let smsSwitch = UISwitch()
        smsSwitch.onTintColor = .orange
        smsSwitch.setFrame(width: 50, height: 27)
        return smsSwitch
    }()
    
    lazy var smsTitle: UILabel = {
        let smsTitle = UILabel()
        smsTitle.text = defaultLocalizer.stringForKey(key: "SMS_NOTIFICATIONS")
        smsTitle.numberOfLines = 0
        smsTitle.textColor = colorBlackWhite
        smsTitle.font = UIFont.systemFont(ofSize: 18)
        smsTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
        smsTitle.textAlignment = .left
        smsTitle.autoresizesSubviews = true
        smsTitle.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return smsTitle
    }()
    
    lazy var securityTitle: UILabel = {
        let securityTitle = UILabel()
        securityTitle.text = defaultLocalizer.stringForKey(key: "SECURITY")
        securityTitle.numberOfLines = 0
        securityTitle.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
        securityTitle.font = UIFont.systemFont(ofSize: 18)
        securityTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
        securityTitle.textAlignment = .left
        securityTitle.autoresizesSubviews = true
        securityTitle.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return securityTitle
    }()
    
    lazy var changePinTitle: UILabel = {
        let changePinTitle = UILabel()
        changePinTitle.text = defaultLocalizer.stringForKey(key: "CHANGE_PIN")
        changePinTitle.numberOfLines = 0
        changePinTitle.textColor = colorBlackWhite
        changePinTitle.font = UIFont.systemFont(ofSize: 18)
        changePinTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
        changePinTitle.textAlignment = .left
        changePinTitle.autoresizesSubviews = true
        changePinTitle.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        changePinTitle.isUserInteractionEnabled = true
        return changePinTitle
    }()
    
    lazy var changePinButton: UIButton = {
        let changePinButton = UIButton()
        changePinButton.setImage(#imageLiteral(resourceName: "next_arrow"), for: UIControl.State.normal)
        return changePinButton
    }()
    
    lazy var bioSwitch: UISwitch = {
        let bioSwitch = UISwitch()
        bioSwitch.onTintColor = .orange
        bioSwitch.setFrame(width: 50, height: 27)
        return bioSwitch
    }()
    
    lazy var bioSwitchTitle: UILabel = {
        let bioSwitchTitle = UILabel()
        bioSwitchTitle.text = defaultLocalizer.stringForKey(key: "BIOMETRIC_LOGIN")
        bioSwitchTitle.numberOfLines = 0
        bioSwitchTitle.textColor = colorBlackWhite
        bioSwitchTitle.font = UIFont.systemFont(ofSize: 18)
        bioSwitchTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
        bioSwitchTitle.textAlignment = .left
        bioSwitchTitle.autoresizesSubviews = true
        bioSwitchTitle.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return bioSwitchTitle
    }()
  
    
    lazy var lineSeparator: UIView = {
        let lineSeparator = UIView()
        lineSeparator.backgroundColor = colorLightDarkGray
    
      return lineSeparator
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
        self.addSubview(appearanceTitle)
        self.addSubview(languageTitle)
        self.addSubview(themeTitle)
        self.addSubview(chooseLang)
        self.addSubview(chooseTheme)
        self.addSubview(notificationTitle)
        self.addSubview(pushSwitch)
        self.addSubview(pushSwitchTitle)
        self.addSubview(promotionsSwitch)
        self.addSubview(promotionsTitle)
        self.addSubview(smsSwitch)
        self.addSubview(smsTitle)
        self.addSubview(securityTitle)
        self.addSubview(changePinTitle)
        self.addSubview(changePinButton)
        self.addSubview(bioSwitchTitle)
        self.addSubview(bioSwitch)
        self.addSubview(lineSeparator)
        

        
        appearanceTitle.translatesAutoresizingMaskIntoConstraints = false
        languageTitle.translatesAutoresizingMaskIntoConstraints = false
        chooseLang.translatesAutoresizingMaskIntoConstraints = false
        themeTitle.translatesAutoresizingMaskIntoConstraints = false
        chooseTheme.translatesAutoresizingMaskIntoConstraints = false
        notificationTitle.translatesAutoresizingMaskIntoConstraints = false
        pushSwitch.translatesAutoresizingMaskIntoConstraints = false
        pushSwitchTitle.translatesAutoresizingMaskIntoConstraints = false
        promotionsSwitch.translatesAutoresizingMaskIntoConstraints = false
        promotionsTitle.translatesAutoresizingMaskIntoConstraints = false
        smsSwitch.translatesAutoresizingMaskIntoConstraints = false
        smsTitle.translatesAutoresizingMaskIntoConstraints = false
        securityTitle.translatesAutoresizingMaskIntoConstraints = false
        changePinTitle.translatesAutoresizingMaskIntoConstraints = false
        changePinButton.translatesAutoresizingMaskIntoConstraints = false
        lineSeparator.translatesAutoresizingMaskIntoConstraints = false
        bioSwitchTitle.translatesAutoresizingMaskIntoConstraints = false
        bioSwitch.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([appearanceTitle.topAnchor.constraint(equalTo: topAnchor, constant: 5),
                                     appearanceTitle.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 20),
                                   
                                     languageTitle.topAnchor.constraint(equalTo: appearanceTitle.bottomAnchor, constant: 16),
                                     languageTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                                     
                                     chooseLang.topAnchor.constraint(equalTo: languageTitle.bottomAnchor, constant: 4),
                                     chooseLang.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                                     chooseLang.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                                     chooseLang.heightAnchor.constraint(equalToConstant: 48),
                                     
                                     themeTitle.topAnchor.constraint(equalTo: chooseLang.bottomAnchor, constant: 33),
                                     themeTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                                     
                                    chooseTheme.topAnchor.constraint(equalTo: themeTitle.bottomAnchor, constant: 4),
                                    chooseTheme.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                                    chooseTheme.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                                    chooseTheme.heightAnchor.constraint(equalToConstant: 48),
                                     
                                     notificationTitle.topAnchor.constraint(equalTo: chooseTheme.bottomAnchor, constant: 32),
                                     notificationTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                                     
                                     pushSwitch.topAnchor.constraint(equalTo: notificationTitle.bottomAnchor, constant: 23),
                                     pushSwitch.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22),
                                     
                                     pushSwitchTitle.centerYAnchor.constraint(equalTo: pushSwitch.centerYAnchor),
                                     pushSwitchTitle.leadingAnchor.constraint(equalTo: pushSwitch.trailingAnchor, constant: 12),
                                     
                                     promotionsSwitch.topAnchor.constraint(equalTo: pushSwitch.bottomAnchor,  constant: 29),
                                     promotionsSwitch.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22),
                                     
                                     promotionsTitle.centerYAnchor.constraint(equalTo: promotionsSwitch.centerYAnchor),
                                     promotionsTitle.leadingAnchor.constraint(equalTo: promotionsSwitch.trailingAnchor, constant: 12),
                                     
                                     smsSwitch.topAnchor.constraint(equalTo: promotionsSwitch.bottomAnchor,  constant: 29),
                                     smsSwitch.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22),
                                     
                                     smsTitle.centerYAnchor.constraint(equalTo: smsSwitch.centerYAnchor),
                                     smsTitle.leadingAnchor.constraint(equalTo: promotionsSwitch.trailingAnchor, constant: 12),
                                     
                                     securityTitle.topAnchor.constraint(equalTo: smsSwitch.bottomAnchor, constant: 38),
                                     securityTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                                     
                                     changePinTitle.topAnchor.constraint(equalTo: securityTitle.bottomAnchor, constant: 33),
                                     changePinTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22),
                                     
                                     changePinButton.centerYAnchor.constraint(equalTo: changePinTitle.centerYAnchor),
                                     changePinButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

                                     lineSeparator.heightAnchor.constraint(equalToConstant: 1.5),
                                     lineSeparator.topAnchor.constraint(equalTo: changePinTitle.bottomAnchor, constant: 31),
                                     lineSeparator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                                     lineSeparator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                                     
                                     bioSwitch.topAnchor.constraint(equalTo: lineSeparator.bottomAnchor, constant: 19),
                                     bioSwitch.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                                     
                                     bioSwitchTitle.centerYAnchor.constraint(equalTo: bioSwitch.centerYAnchor),
                                     bioSwitchTitle.leadingAnchor.constraint(equalTo: bioSwitch.trailingAnchor,constant: 20)
                                     
                                    ])
        
    }
}
