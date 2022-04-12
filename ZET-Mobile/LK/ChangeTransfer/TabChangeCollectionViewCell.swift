//
//  TabChangeCollectionViewCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/29/21.
//

import UIKit
import MultiSlider
import iOSDropDown

class TabChangeCollectionViewCell: UICollectionViewCell {
    
    lazy var titleOne: UILabel = {
        let titleOne = UILabel()
        titleOne.text = "Тип пакета"
        titleOne.numberOfLines = 0
        titleOne.textColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1)
        titleOne.font = UIFont(name: "", size: 10)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 20, y: 20, width: 300, height: 20)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleOne
    }()
    
    lazy var user_to_number: DropDown = {
        let textfield = DropDown()
        textfield.frame = CGRect(x: 20, y: 50, width: UIScreen.main.bounds.size.width - 40, height: 50)
        textfield.layer.cornerRadius = 16
        textfield.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        textfield.layer.borderWidth = 1
        textfield.setView(.right, image: UIImage(named: "drop_icon"))
        return textfield
    }()
    
    
    lazy var titleTwo: UILabel = {
        let title = UILabel()
        title.text = "Обменять на"
        title.numberOfLines = 0
        title.textColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1)
        title.font = UIFont(name: "", size: 10)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 20, y: 150, width: 300, height: 20)
        title.autoresizesSubviews = true
        title.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return title
    }()
    
    lazy var type_transfer: DropDown = {
        let textfield = DropDown()
        textfield.frame = CGRect(x: 20, y: 180, width: UIScreen.main.bounds.size.width - 40, height: 50)
        textfield.layer.cornerRadius = 16
        textfield.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        textfield.layer.borderWidth = 1
        textfield.setView(.right, image: UIImage(named: "drop_icon"))
        return textfield
    }()
    
    lazy var titleThree: UILabel = {
        let title = UILabel()
        title.text = "Минуты внутри сети"
        title.numberOfLines = 0
        title.textColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1)
        title.font = UIFont(name: "", size: 10)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 20, y: 270, width: 300, height: 20)
        title.autoresizesSubviews = true
        title.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return title
    }()
    
    lazy var titleFour: UILabel = {
        let title = UILabel()
        title.text = "Мегабайты"
        title.numberOfLines = 0
        title.textColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1)
        title.font = UIFont(name: "", size: 10)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .right
        title.frame = CGRect(x: UIScreen.main.bounds.size.width - 320, y: 270, width: 300, height: 20)
        title.autoresizesSubviews = true
        title.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return title
    }()
    
    lazy var count_transfer: UITextField = {
        let textfield = UITextField()
        textfield.frame = CGRect(x: 20, y: 300, width: (UIScreen.main.bounds.size.width / 2) - 60, height: 50)
        textfield.layer.cornerRadius = 16
        textfield.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        textfield.layer.borderWidth = 1
        return textfield
    }()
    
    lazy var count_to_transfer: UITextField = {
        let textfield = UITextField()
        textfield.frame = CGRect(x: UIScreen.main.bounds.size.width - count_transfer.frame.size.width - 20, y: 300, width: (UIScreen.main.bounds.size.width / 2) - 60, height: 50)
        textfield.layer.cornerRadius = 16
        textfield.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        textfield.layer.borderWidth = 1
        return textfield
    }()
    
    let slider = MultiSlider()
    
    lazy var title_commission: UILabel = {
        let title = UILabel()
        title.text = "Комиссия: 0.2 сомони"
        title.numberOfLines = 0
        title.textColor = .red
        title.font = UIFont(name: "", size: 9)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 20, y: 430, width: 300, height: 20)
        title.autoresizesSubviews = true
        title.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return title
    }()
    
    lazy var title_info: UILabel = {
        let title = UILabel()
        title.text = "Меняйте лишнее на нужное! Услуга «Обмен» позволит Вам обменивать"
        title.numberOfLines = 2
        title.textColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1)
        title.font = UIFont(name: "", size: 10)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 20, y: 460, width: UIScreen.main.bounds.size.width - 40, height: 50)
        title.autoresizesSubviews = true
        title.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return title
    }()
    
    lazy var icon_more: UIButton = {
        let icon_more = UIButton()
        //icon_more.setImage(#imageLiteral(resourceName: "View_all"), for: UIControl.State.normal)
        icon_more.backgroundColor = .clear
        icon_more.frame = CGRect(x: 20, y: 520, width: 200, height: 20)
        icon_more.contentHorizontalAlignment = .left
        icon_more.setTitle("Подробнее об услуге  >", for: .normal)
        icon_more.setTitleColor(.orange, for: .normal)
        icon_more.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        //openmenu.addTarget(self, action: #selector(goback), for: UIControl.Event.touchUpInside)
        return icon_more
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 20, y: 560, width: Int(UIScreen.main.bounds.size.width) - 40, height: 45))
        //ReconnectBut.setImage(#imageLiteral(resourceName: "connect"), for: UIControl.State.normal)
        //openmenu.addTarget(self, action: #selector(goback), for: UIControl.Event.touchUpInside)
        button.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
        button.setTitle("Перевести", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.layer.cornerRadius = button.frame.height / 2
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        slider.minimumValue = 0
        slider.maximumValue = 5
        slider.value = [3]
        slider.orientation = .horizontal
        slider.isVertical = false
        slider.outerTrackColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
        slider.tintColor = .orange
        slider.trackWidth = 5
        slider.snapStepSize = 1
        slider.thumbImage = UIImage(named: "slider_thumb")
        slider.frame = CGRect(x: 20, y: 370, width: UIScreen.main.bounds.size.width - 40, height: 30)
        
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        count_transfer.leftView = paddingView
        count_transfer.leftViewMode = .always
        
        let paddingView1: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        count_to_transfer.leftView = paddingView1
        count_to_transfer.leftViewMode = .always
        
        type_transfer.isSearchEnable = false
        type_transfer.selectedRowColor = .lightGray
        let paddingView2: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        type_transfer.leftView = paddingView2
        type_transfer.leftViewMode = .always
        
        user_to_number.isSearchEnable = false
        user_to_number.selectedRowColor = .lightGray
        let paddingView3: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        user_to_number.leftView = paddingView3
        user_to_number.leftViewMode = .always
        
        contentView.backgroundColor = .clear
        contentView.autoresizesSubviews = true
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.addSubview(titleOne)
        contentView.addSubview(user_to_number)
        contentView.addSubview(titleFour)
        contentView.addSubview(titleTwo)
        contentView.addSubview(type_transfer)
        contentView.addSubview(titleThree)
        contentView.addSubview(count_transfer)
        contentView.addSubview(count_to_transfer)
        contentView.addSubview(slider)
        contentView.addSubview(title_commission)
        contentView.addSubview(title_info)
        contentView.addSubview(icon_more)
        contentView.addSubview(sendButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

