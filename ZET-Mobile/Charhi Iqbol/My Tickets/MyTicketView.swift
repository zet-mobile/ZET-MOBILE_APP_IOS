//
//  MyTicket.swift
//  ZET-Mobile
//
//  Created by iDev on 06/09/23.
//

import UIKit

class MyTicketView: UIView {
    let view_button = UIView()

   

    let sendButton = UIButton()
   
    
   


    
    lazy var image_banner: UIImageView = {
        let image = UIImageView()
        image.image = UIImage()
        image.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 167)
        return image
    }()
    
    let totalTickets = UILabel()
    
   
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
        sendButton.frame = CGRect(x: 20, y: 10, width: Int(UIScreen.main.bounds.size.width) - 40, height: 45)
        sendButton.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
        sendButton.setTitle("\(defaultLocalizer.stringForKey(key: "Participate"))", for: .normal)
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        sendButton.layer.cornerRadius = sendButton.frame.height / 2
        
        view_button.frame = CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.size.width), height: 70)
        let screenSize = UIScreen.main.bounds.size

        // Вычисляем центр экрана
        let centerX = screenSize.width / 2
        let centerY = screenSize.height / 2

        // Устанавливаем центр view_button
        view_button.center = CGPoint(x: centerX, y: centerY)
        view_button.backgroundColor = .white
        view_button.isHidden = true
        
        view_button.backgroundColor = contentColor
        view_button.addSubview(sendButton)

        
        
        totalTickets.frame = CGRect(x: -20, y: image_banner.frame.maxY + 15 , width: image_banner.frame.width, height: 50)
       // totalTickets.frame = CGRect(x: image_banner.frame.minX + 250, y: image_banner.frame.maxY, width: 240, height: 50)
     // totalTickets.text =
        totalTickets.text = ""//defaultLocalizer.stringForKey(key: "TOTAL") + ": "
        totalTickets.numberOfLines = 2
        totalTickets.textColor = colorBlackWhite
        totalTickets.font = UIFont.boldSystemFont(ofSize: 18)
        totalTickets.textAlignment = .right
        self.addSubview(image_banner)
        self.addSubview(totalTickets)
        self.addSubview(view_button)
    }
    
}
