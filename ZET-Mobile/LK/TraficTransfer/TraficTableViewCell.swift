//
//  TraficTableViewCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 15/04/22.
//

import UIKit
import MultiSlider
import iOSDropDown

class TraficTableViewCell: UITableViewCell {
    
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    let titleOne = UILabel()
    let user_to_number = UITextField()
    let titleRed = UILabel()
    let titleTwo = UILabel()
    let type_transfer = DropDown()
    let titleThree = UILabel()
    let count_transfer = UITextField()
    let titleRed2 = UILabel()
    let slider = MultiSlider()
    let title_commission = UILabel()
    let title_info = UILabel()
    let icon_more = UIButton()
    let sendButton = UIButton()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "cell_transfer")
        backgroundColor = .clear
        
        contentView.addSubview(titleOne)
        contentView.addSubview(user_to_number)
        contentView.addSubview(titleRed)
        contentView.addSubview(titleTwo)
        contentView.addSubview(type_transfer)
        contentView.addSubview(titleThree)
        contentView.addSubview(count_transfer)
        contentView.addSubview(titleRed2)
        contentView.addSubview(slider)
        contentView.addSubview(title_commission)
        contentView.addSubview(title_info)
        contentView.addSubview(icon_more)
        contentView.addSubview(sendButton)
        
        contentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 750)
        
        titleOne.text = defaultLocalizer.stringForKey(key: "Recipient_number")
        titleOne.numberOfLines = 0
        titleOne.textColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1)
        titleOne.font = UIFont(name: "", size: 10)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 20, y: 20, width: 300, height: 20)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        user_to_number.frame = CGRect(x: 20, y: 50, width: UIScreen.main.bounds.size.width - 40, height: 50)
        user_to_number.layer.cornerRadius = 16
        user_to_number.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        user_to_number.layer.borderWidth = 1
        user_to_number.textColor = colorBlackWhite
        user_to_number.text = "+992 "
        user_to_number.tag = 1
        user_to_number.keyboardType = .numberPad
        user_to_number.setView(.right, image: UIImage(named: "user_field_icon"))
    
        titleRed.text = defaultLocalizer.stringForKey(key: "Invalid_recipient_number")
        titleRed.numberOfLines = 0
        titleRed.textColor = .red
        titleRed.font = UIFont(name: "", size: 9)
        titleRed.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleRed.textAlignment = .left
        titleRed.frame = CGRect(x: 20, y: 110, width: UIScreen.main.bounds.size.width - 40, height: 20)
        titleRed.autoresizesSubviews = true
        titleRed.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        titleRed.isHidden = true
        
        titleTwo.text = defaultLocalizer.stringForKey(key: "Package_type")
        titleTwo.numberOfLines = 0
        titleTwo.textColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1)
        titleTwo.font = UIFont(name: "", size: 10)
        titleTwo.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleTwo.textAlignment = .left
        titleTwo.frame = CGRect(x: 20, y: 150, width: 300, height: 20)
        titleTwo.autoresizesSubviews = true
        titleTwo.autoresizingMask = [.flexibleHeight, .flexibleWidth]
     
        type_transfer.frame = CGRect(x: 20, y: 180, width: UIScreen.main.bounds.size.width - 40, height: 50)
        type_transfer.layer.cornerRadius = 16
        type_transfer.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        type_transfer.layer.borderWidth = 1
        type_transfer.textColor = colorBlackWhite
        type_transfer.checkMarkEnabled = false
        type_transfer.setView(.right, image: UIImage(named: "drop_icon")).isUserInteractionEnabled = false
     
        titleThree.text = defaultLocalizer.stringForKey(key: "Number_of_package_units")
        titleThree.numberOfLines = 0
        titleThree.textColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1)
        titleThree.font = UIFont(name: "", size: 10)
        titleThree.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleThree.textAlignment = .left
        titleThree.frame = CGRect(x: 20, y: 270, width: 300, height: 20)
        titleThree.autoresizesSubviews = true
        titleThree.autoresizingMask = [.flexibleHeight, .flexibleWidth]
 
        count_transfer.frame = CGRect(x: 20, y: 300, width: UIScreen.main.bounds.size.width - 40, height: 50)
        count_transfer.layer.cornerRadius = 16
        count_transfer.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        count_transfer.layer.borderWidth = 1
        count_transfer.tag = 2
        count_transfer.textColor = colorBlackWhite
        count_transfer.keyboardType = .numberPad
    
        titleRed2.text = defaultLocalizer.stringForKey(key: "Invalid_recipient_number")
        titleRed2.numberOfLines = 0
        titleRed2.textColor = .red
        titleRed2.font = UIFont(name: "", size: 9)
        titleRed2.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleRed2.textAlignment = .left
        titleRed2.frame = CGRect(x: 20, y: 360, width: UIScreen.main.bounds.size.width - 40, height: 20)
        titleRed2.autoresizesSubviews = true
        titleRed2.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        titleRed2.isHidden = true
        
        title_commission.text = "Комиссия: 0.2 сомони"
        title_commission.numberOfLines = 0
        title_commission.textColor = .red
        title_commission.font = UIFont(name: "", size: 9)
        title_commission.lineBreakMode = NSLineBreakMode.byWordWrapping
        title_commission.textAlignment = .left
        title_commission.frame = CGRect(x: 20, y: 430, width: 300, height: 20)
        title_commission.autoresizesSubviews = true
        title_commission.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        title_info.text = "Меняйте лишнее на нужное! Услуга «Обмен» позволит Вам обменивать"
        title_info.numberOfLines = 2
        title_info.textColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1)
        title_info.font = UIFont(name: "", size: 10)
        title_info.textAlignment = .left
        title_info.frame = CGRect(x: 20, y: 460, width: UIScreen.main.bounds.size.width - 40, height: 50)
        title_info.autoresizesSubviews = true
        title_info.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        title_info.adjustsFontSizeToFitWidth = false
        title_info.lineBreakMode = .byTruncatingTail
        
        //icon_more.setImage(#imageLiteral(resourceName: "View_all"), for: UIControl.State.normal)
        icon_more.backgroundColor = .clear
        icon_more.frame = CGRect(x: 20, y: 520, width: UIScreen.main.bounds.size.width  - 40, height: 20)
        icon_more.contentHorizontalAlignment = .left
        icon_more.setTitle("\(defaultLocalizer.stringForKey(key: "More_about_the_service"))  >", for: .normal)
        icon_more.setTitleColor(.orange, for: .normal)
        icon_more.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        //openmenu.addTarget(self, action: #selector(goback), for: UIControl.Event.touchUpInside)
  
        sendButton.frame = CGRect(x: 20, y: 560, width: Int(UIScreen.main.bounds.size.width) - 40, height: 45)
        //ReconnectBut.setImage(#imageLiteral(resourceName: "connect"), for: UIControl.State.normal)
        //openmenu.addTarget(self, action: #selector(goback), for: UIControl.Event.touchUpInside)
        sendButton.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
        sendButton.setTitle(defaultLocalizer.stringForKey(key: "Transfer2"), for: .normal)
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        sendButton.layer.cornerRadius = sendButton.frame.height / 2
        
        slider.orientation = .horizontal
        slider.isVertical = false
        slider.outerTrackColor = (UserDefaults.standard.string(forKey: "ThemeAppereance") == "dark" ? UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.00) : UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00))
        slider.tintColor = .orange
        slider.trackWidth = 5
        slider.snapStepSize = 1
        slider.thumbImage = UIImage(named: "slider_thumb")
        slider.value = [0]
        slider.frame = CGRect(x: 20, y: 390, width: UIScreen.main.bounds.size.width - 40, height: 30)
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        count_transfer.leftView = paddingView
        count_transfer.leftViewMode = .always
        
        type_transfer.isSearchEnable = false
        type_transfer.selectedRowColor = .lightGray
        let paddingView2: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        type_transfer.leftView = paddingView2
        type_transfer.leftViewMode = .always
        
        let paddingView3: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        user_to_number.leftView = paddingView3
        user_to_number.leftViewMode = .always
        
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
