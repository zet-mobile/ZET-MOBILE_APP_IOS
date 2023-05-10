//
//  CompetitionView.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 07/12/22.
//

import UIKit

class CompetitionView: UIView {
    
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    lazy var image_banner: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "image 98")
        image.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 150)
        return image
    }()
    
    let ico_image = UIImageView()
    let titleOne = UILabel()
    let titleTwo = UILabel()
    
    let sendButton = UIButton()
    
    let view_prize = UIView()
    let view_button = UIView()
    
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
        
        view_prize.frame = CGRect(x: 0, y: 520, width: UIScreen.main.bounds.size.width, height: 90)
        view_prize.backgroundColor = .white
        
        view_button.frame = CGRect(x: 0, y: 610, width: UIScreen.main.bounds.size.width, height: 70)
        view_button.backgroundColor = .white
        
        ico_image.frame = CGRect(x: 20, y: 30, width: 45, height: 45)
        ico_image.image = UIImage(named: "noto_wrapped-gift")
        
        titleOne.frame = CGRect(x: 80, y: 10, width: 240, height: 30)
        titleOne.text = "50 мегабайт"
        titleOne.numberOfLines = 1
        titleOne.textColor = .orange
        titleOne.font = UIFont.boldSystemFont(ofSize: 17)
        titleOne.textAlignment = .left
        
        titleTwo.frame = CGRect(x: 80, y: 40, width: 340, height: 30)
        titleTwo.text = "за каждый полученный ID– номер!"
        titleTwo.numberOfLines = 0
        titleTwo.sizeToFit()
        titleTwo.textColor = UIColor(red: 0.153, green: 0.682, blue: 0.376, alpha: 1)
        titleTwo.font = UIFont.systemFont(ofSize: 15)
        titleTwo.textAlignment = .left
        
        sendButton.frame = CGRect(x: 20, y: 10, width: Int(UIScreen.main.bounds.size.width) - 40, height: 45)
        sendButton.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
        sendButton.setTitle("Участвовать!", for: .normal)
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        sendButton.layer.cornerRadius = sendButton.frame.height / 2
        
        self.addSubview(image_banner)
        view_prize.addSubview(ico_image)
        view_prize.addSubview(titleOne)
        view_prize.addSubview(titleTwo)
        
        self.addSubview(view_prize)
        
        view_button.addSubview(sendButton)
        self.addSubview(view_button)
    }

}

