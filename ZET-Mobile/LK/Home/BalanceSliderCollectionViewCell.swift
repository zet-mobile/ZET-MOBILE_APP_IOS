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
        titleOne.text = defaultLocalizer.stringForKey(key: "Your_balance")
        titleOne.numberOfLines = 0
        titleOne.textColor = .white
        titleOne.font = UIFont(name: "", size: 10)
        titleOne.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleOne.textAlignment = .left
        titleOne.frame = CGRect(x: 20, y: 40, width: 300, height: 20)
        titleOne.autoresizesSubviews = true
        titleOne.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleOne
    }()
    
    lazy var balance: UILabel = {
        let user_name = UILabel()
        user_name.text = ""
        user_name.numberOfLines = 0
        user_name.textColor = .white
        user_name.font = UIFont.preferredFont(forTextStyle: .subheadline)
        user_name.font = UIFont.boldSystemFont(ofSize: 25)
        user_name.lineBreakMode = NSLineBreakMode.byWordWrapping
        user_name.textAlignment = .left
        user_name.frame = CGRect(x: 20, y: 65, width: 200, height: 28)
        user_name.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return user_name
    }()
    
    lazy var popolnit: UIButton = {
        let popolnit = UIButton()
        //popolnit.setImage(#imageLiteral(resourceName: "Popolnit"), for: UIControl.State.normal)
        popolnit.backgroundColor = UIColor(red: 1, green: 0.871, blue: 0, alpha: 1)
        popolnit.setTitle(defaultLocalizer.stringForKey(key: "Top_up_balance"), for: .normal)
        popolnit.setTitleColor(.black, for: .normal)
        popolnit.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        popolnit.frame = CGRect(x: UIScreen.main.bounds.size.width - 200, y: 30, width: 140, height: 35)
        popolnit.layer.cornerRadius = popolnit.frame.height / 2
        popolnit.addTarget(self, action: #selector(addBalanceOption), for: UIControl.Event.touchUpInside)
        
        return popolnit
    }()
    
    lazy var titleTarif: UILabel = {
        let titleTarif = UILabel()
        titleTarif.text = ""
        titleTarif.numberOfLines = 0
        titleTarif.textColor = .white
        titleTarif.font = UIFont.boldSystemFont(ofSize: 19)
        titleTarif.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleTarif.textAlignment = .left
        //titleTarif.frame = CGRect(x: 20, y: 60, width: 200, height: 20)
        titleTarif.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleTarif
    }()
    
    lazy var settings: UIButton = {
        let settings = UIButton()
        settings.setImage(UIImage(named: "Setting"), for: .normal)
        settings.frame = CGRect(x: titleTarif.text!.count * 10 + 30, y: 90, width: 30, height: 30)
        settings.addTarget(self, action: #selector(openTarifView), for: UIControl.Event.touchUpInside)
        settings.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return settings
    }()
    
    lazy var titleNumber: UILabel = {
        let titleNumber = UILabel()
        titleNumber.text = ""
        titleNumber.numberOfLines = 0
        titleNumber.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        titleNumber.font = UIFont(name: "", size: 10)
        titleNumber.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleNumber.textAlignment = .left
        titleNumber.frame = CGRect(x: 20, y: 155, width: 200, height: 20)
        titleNumber.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return titleNumber
    }()
    
    lazy var spisanie: UILabel = {
        let spisanie = UILabel()
        spisanie.text = ""
        spisanie.numberOfLines = 0
        spisanie.textColor = .white
        spisanie.font = UIFont(name: "", size: 10)
        spisanie.lineBreakMode = NSLineBreakMode.byWordWrapping
        spisanie.textAlignment = .left
        spisanie.frame = CGRect(x: 20, y: 130, width: 300, height: 20)
        spisanie.autoresizesSubviews = true
        spisanie.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return spisanie
    }()
    
    
    @objc func openTarifView(_ sender: UIButton){
        sender.showAnimation { [self] in
            actionDelegate?.didSettingTapped(for: self)
        }
        
    }
    
    @objc func addBalanceOption(_ sender: UIButton){
        sender.showAnimation { [self] in
            actionDelegate?.didAddBalance(for: self)
        }
        
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
