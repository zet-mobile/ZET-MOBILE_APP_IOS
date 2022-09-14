//
//  DetalizationViewCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 12/05/22.
//

import UIKit

class DetalizationViewCell: UITableViewCell {

    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    let titleOne = UILabel()
    let period = UITextField()
    let title_commission = UILabel()
    let title_info = UILabel()
    let icon_more = UIButton()
    let sendButton = UIButton()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "detail_cell")
        backgroundColor = .clear
        
        contentView.addSubview(titleOne)
        contentView.addSubview(period)
        contentView.addSubview(title_commission)
        contentView.addSubview(title_info)
        contentView.addSubview(icon_more)
        contentView.addSubview(sendButton)
        
        contentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 500)
        
        titleOne.text = defaultLocalizer.stringForKey(key: "History_period")
        titleOne.numberOfLines = 0
        titleOne.textColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1)
        titleOne.font = UIFont(name: "", size: 10)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 20, y: 10, width: 300, height: 20)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        
        period.frame = CGRect(x: 20, y: 40, width: UIScreen.main.bounds.size.width - 40, height: 50)
        period.layer.cornerRadius = 16
        period.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        period.layer.borderWidth = 1
        period.textColor = colorBlackWhite
        
        
        title_commission.text = "Комиссия: 0.2 сомони"
        title_commission.numberOfLines = 0
        title_commission.textColor = .orange
        title_commission.font = UIFont(name: "", size: 9)
        title_commission.lineBreakMode = NSLineBreakMode.byWordWrapping
        title_commission.textAlignment = .left
        title_commission.frame = CGRect(x: 20, y: 100, width: 300, height: 20)
        title_commission.autoresizesSubviews = true
        title_commission.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        title_info.text = "Услуга “Детализация” позволит грамотно планировать расходы на связь на ближайший месяц и всегда быть в курсе состояния баланса и списаний."
        title_info.numberOfLines = 5
        title_info.textColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1)
        title_info.font = UIFont(name: "", size: 10)
        title_info.lineBreakMode = NSLineBreakMode.byWordWrapping
        title_info.textAlignment = .left
        title_info.frame = CGRect(x: 20, y: 130, width: UIScreen.main.bounds.size.width - 40, height: 90)
        title_info.autoresizesSubviews = true
        title_info.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        icon_more.backgroundColor = .clear
        icon_more.frame = CGRect(x: 20, y: 230, width: 200, height: 20)
        icon_more.contentHorizontalAlignment = .left
        icon_more.setTitle("\(defaultLocalizer.stringForKey(key: "More_about_the_service"))  >", for: .normal)
        icon_more.setTitleColor(.orange, for: .normal)
        icon_more.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        sendButton.frame = CGRect(x: 20, y: 270, width: Int(UIScreen.main.bounds.size.width) - 40, height: 45)
        sendButton.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
        sendButton.setTitle(defaultLocalizer.stringForKey(key: "Send"), for: .normal)
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        sendButton.layer.cornerRadius = sendButton.frame.height / 2
        
        let paddingView3: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        period.leftView = paddingView3
        period.leftViewMode = .always
        
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
