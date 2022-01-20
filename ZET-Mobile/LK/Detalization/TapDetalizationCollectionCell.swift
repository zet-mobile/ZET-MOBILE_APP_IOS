//
//  TapDetalizationCollectionCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 12/1/21.
//

import UIKit

protocol CellDetalizationDelegate{
    func didCalendarTapped(for cell: TapDetalizationCollectionCell)
}

class TapDetalizationCollectionCell: UICollectionViewCell {
    
    var actionDelegate: CellDetalizationDelegate?
    
    lazy var titleOne: UILabel = {
        let titleOne = UILabel()
        titleOne.text = "Период детализации"
        titleOne.numberOfLines = 0
        titleOne.textColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1)
        titleOne.font = UIFont(name: "", size: 10)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 20, y: 50, width: 300, height: 20)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleOne
    }()
    
    lazy var user_to_number: UITextField = {
        let textfield = UITextField()
        textfield.frame = CGRect(x: 20, y: 80, width: UIScreen.main.bounds.size.width - 40, height: 50)
        textfield.layer.cornerRadius = 16
        textfield.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        textfield.layer.borderWidth = 1
        //textfield.setView(.right, image: UIImage(named: "calendar"))
        let open_calendar = textfield.setView(.right, image: UIImage(named: "calendar"))
        open_calendar.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        return textfield
    }()
    
    lazy var title_commission: UILabel = {
        let title = UILabel()
        title.text = "Комиссия: 0.2 сомони"
        title.numberOfLines = 0
        title.textColor = .orange
        title.font = UIFont(name: "", size: 9)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 20, y: 180, width: 300, height: 20)
        title.autoresizesSubviews = true
        title.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return title
    }()
    
    lazy var title_info: UILabel = {
        let title = UILabel()
        title.text = "Услуга “Детализация” позволит грамотно планировать расходы на связь на ближайший месяц и всегда быть в курсе состояния баланса и списаний."
        title.numberOfLines = 5
        title.textColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1)
        title.font = UIFont(name: "", size: 10)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.textAlignment = .left
        title.frame = CGRect(x: 20, y: 220, width: UIScreen.main.bounds.size.width - 40, height: 90)
        title.autoresizesSubviews = true
        title.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return title
    }()
    
    lazy var icon_more: UIButton = {
        let icon_more = UIButton()
        //icon_more.setImage(#imageLiteral(resourceName: "View_all"), for: UIControl.State.normal)
        icon_more.backgroundColor = .clear
        icon_more.frame = CGRect(x: 20, y: 320, width: 200, height: 20)
        icon_more.contentHorizontalAlignment = .left
        icon_more.setTitle("Подробнее об услуге  >", for: .normal)
        icon_more.setTitleColor(.orange, for: .normal)
        icon_more.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        //openmenu.addTarget(self, action: #selector(goback), for: UIControl.Event.touchUpInside)
        return icon_more
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 20, y: 480, width: Int(UIScreen.main.bounds.size.width) - 40, height: 45))
        //ReconnectBut.setImage(#imageLiteral(resourceName: "connect"), for: UIControl.State.normal)
        //openmenu.addTarget(self, action: #selector(goback), for: UIControl.Event.touchUpInside)
        button.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
        button.setTitle("Отправить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.layer.cornerRadius = button.frame.height / 2
        return button
    }()
    
    @objc func buttonClicked() {
        actionDelegate?.didCalendarTapped(for: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        contentView.autoresizesSubviews = true
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.addSubview(titleOne)
        contentView.addSubview(user_to_number)
        
        contentView.addSubview(title_commission)
        contentView.addSubview(title_info)
        contentView.addSubview(icon_more)
        contentView.addSubview(sendButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
