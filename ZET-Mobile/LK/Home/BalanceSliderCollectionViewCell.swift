//
//  BalanceSliderCollectionViewCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/3/21.
//

import UIKit

protocol CellBalanceActionDelegate{
    func didSettingTapped(for cell: BalanceSliderCollectionViewCell)
    func didAddBalance(for cell: BalanceSliderCollectionViewCell)
}

class BalanceSliderCollectionViewCell: UICollectionViewCell {
    
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    var actionDelegate: CellBalanceActionDelegate?
    
    let image: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "BalanceBack")
        iv.contentMode = .scaleToFill
        iv.backgroundColor = .clear
        iv.autoresizesSubviews = true
        
        iv.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return iv
    }()
    
    lazy var titleOne: UILabel = {
        let titleOne = UILabel()
        titleOne.text = "Ваш баланс"
        titleOne.numberOfLines = 0
        titleOne.textColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1)
        titleOne.font = UIFont(name: "", size: 10)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 20, y: 25, width: 300, height: 20)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleOne
    }()
    
    lazy var balance: UILabel = {
        let user_name = UILabel()
        user_name.text = "45 somoni"
        user_name.numberOfLines = 0
        user_name.textColor = .white
        user_name.font = UIFont.preferredFont(forTextStyle: .subheadline)
        user_name.font = UIFont.boldSystemFont(ofSize: 24)
        user_name.lineBreakMode = NSLineBreakMode.byWordWrapping
        user_name.textAlignment = .left
        user_name.frame = CGRect(x: 20, y: 45, width: 200, height: 28)
        user_name.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return user_name
    }()
    
    lazy var popolnit: UIButton = {
        let popolnit = UIButton()
        //popolnit.setImage(#imageLiteral(resourceName: "Popolnit"), for: UIControl.State.normal)
        popolnit.backgroundColor = UIColor(red: 1, green: 0.871, blue: 0, alpha: 1)
        popolnit.setTitle(defaultLocalizer.stringForKey(key: "topUpBalance"), for: .normal)
        popolnit.setTitleColor(.black, for: .normal)
        popolnit.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        popolnit.frame = CGRect(x: UIScreen.main.bounds.size.width - 180, y: 20, width: 120, height: 33)
        popolnit.layer.cornerRadius = popolnit.frame.height / 2
        popolnit.addTarget(self, action: #selector(addBalanceOption), for: UIControl.Event.touchUpInside)
        return popolnit
    }()
    
    lazy var titleTarif: UILabel = {
        let titleTarif = UILabel()
        titleTarif.text = "Тариф “Супер-15"
        titleTarif.numberOfLines = 0
        titleTarif.textColor = .white
        titleTarif.font = UIFont.boldSystemFont(ofSize: 18)
        titleTarif.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleTarif.textAlignment = .left
        titleTarif.frame = CGRect(x: 20, y: 100, width: 200, height: 20)
        titleTarif.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleTarif
    }()
    
    lazy var settings: UIButton = {
        let settings = UIButton()
        settings.setImage(#imageLiteral(resourceName: "Setting"), for: UIControl.State.normal)
        settings.frame = CGRect(x: titleTarif.text!.count * 10 + 30, y: 100, width: 20, height: 20)
        settings.addTarget(self, action: #selector(openTarifView), for: UIControl.Event.touchUpInside)
        settings.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return settings
    }()
    
    lazy var titleNumber: UILabel = {
        let titleNumber = UILabel()
        titleNumber.text = "+992 (91) 900 09 44"
        titleNumber.numberOfLines = 0
        titleNumber.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        titleNumber.font = UIFont(name: "", size: 10)
        titleNumber.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleNumber.textAlignment = .left
        titleNumber.frame = CGRect(x: 20, y: 165, width: 200, height: 20)
        titleNumber.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleNumber
    }()
    
    lazy var spisanie: UILabel = {
        let spisanie = UILabel()
        spisanie.text = "Следующее списание 13 november"
        spisanie.numberOfLines = 0
        spisanie.textColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1)
        spisanie.font = UIFont(name: "", size: 10)
        spisanie.lineBreakMode = NSLineBreakMode.byWordWrapping
        spisanie.textAlignment = .left
        spisanie.frame = CGRect(x: 20, y: 130, width: 300, height: 20)
        spisanie.autoresizesSubviews = true
        spisanie.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return spisanie
    }()
    
    
    @objc func openTarifView(){
        actionDelegate?.didSettingTapped(for: self)
    }
    
    @objc func addBalanceOption(){
        actionDelegate?.didAddBalance(for: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.autoresizesSubviews = true
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        image.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: 210)
        contentView.addSubview(image)
        contentView.sendSubviewToBack(image)
        
        contentView.addSubview(titleOne)
        contentView.addSubview(balance)
        contentView.addSubview(popolnit)
        contentView.addSubview(titleTarif)
        contentView.addSubview(settings)
        contentView.addSubview(titleNumber)
        contentView.addSubview(spisanie)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
