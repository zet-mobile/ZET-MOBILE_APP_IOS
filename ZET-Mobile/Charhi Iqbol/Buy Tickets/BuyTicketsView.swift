//
//  BuyTicketsView.swift
//  ZET-Mobile
//
//  Created by iDev on 06/09/23.
//

import UIKit

class BuyTicketsView: UIView {
    
    lazy var image_banner: UIImageView = {
        let image = UIImageView()
        image.image = UIImage()
        image.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 167)
        return image
    }()
    
    var ticketCount: Int = 1 {
        didSet {
            if ticketCount > 999999 {
                ticketCount = 999999 // Ограничение до 6 символов
            }
            updateTicketCountLabel()
        }
    }
    
    let ticketCountLabel = UITextField()
    
    
    let buyLabel = UILabel()
    
    lazy var ticketImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Frame 213")
            // image.frame = CGRect(x: UIScreen.main.bounds.size.width / 2, y: 220, width: 192, height: 125)
        
        return image
        
    }()
    
    lazy var backgroundImage: UIImageView = {
        
        let image = UIImageView()
        image.image = UIImage(named: "confetti-bg-2")
        image.backgroundColor = contentColor
        image.frame = CGRect(x: 0, y: image_banner.frame.maxY, width: UIScreen.main.bounds.size.width, height: 300)
        return image
    }()
    
    
    let minusButton = UIButton()
    let plusButton = UIButton()
    
    // let ticketCountTextField = UITextField()
    
    let oneTicketPrice = UILabel()
    let oneTicketPriceCount = UILabel()
    
    let total = UILabel()
    let totalCount = UILabel()
    
    
    let totalMb = UILabel()
    let totalMbCount = UILabel()
    
    let view_button = UIView()
    
    let buyTicketButton = UIButton()
    
    
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
        
        
        
        self.addSubview(backgroundImage)
        
        
        self.addSubview(ticketImage)
        
        let screenSize = UIScreen.main.bounds.size

        // Вычисляем центр экрана
        let centerX = screenSize.width / 2
        
            //  ticketCountLabel.frame = CGRect(x: centerX, y: 260, width: 150, height: 45)
        ticketCountLabel.textColor = .black
        ticketCountLabel.font = UIFont.boldSystemFont(ofSize: 36)
        ticketCountLabel.textAlignment = .center
        
        ticketCount = 1
        
        self.addSubview(ticketCountLabel)
        
        self.addSubview(image_banner)
        
        //        buyLabel.frame = CGRect(x: 60, y: 170, width: 255, height: 33)
        //        buyLabel.textColor = colorBlackWhite
        //        buyLabel.font = UIFont.boldSystemFont(ofSize: 24)
        //        buyLabel.textAlignment = .center
        //        buyLabel.text = "Приобрести билеты"
        //        self.addSubview(buyLabel)
        
        buyTicketButton.frame = CGRect(x: 20, y: 0, width: Int(UIScreen.main.bounds.size.width) - 40, height: 45)
        buyTicketButton.backgroundColor = UIColor(red: 1.00, green: 0.50, blue: 0.05, alpha: 1.00)
        buyTicketButton.setTitle("\(defaultLocalizer.stringForKey(key: "ButtonBuyTickets"))", for: .normal)
        buyTicketButton.setTitleColor(.white, for: .normal)
        buyTicketButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        buyTicketButton.layer.cornerRadius = buyTicketButton.frame.height / 2
        
        view_button.frame = CGRect(x: 0, y: backgroundImage.frame.maxY, width: UIScreen.main.bounds.size.width, height: 60)
        view_button.isUserInteractionEnabled = true
        view_button.backgroundColor = contentColor
        view_button.addSubview(buyTicketButton)
        
        let minusImage = UIImage(named: "plus-circle-2")
        minusButton.setImage(minusImage, for: .normal)
        minusButton.frame = CGRect(x: Int(UIScreen.main.bounds.minX) + 15, y: 260, width: 45, height: 45)
        self.addSubview(minusButton)
        
        let plusImage = UIImage(named: "plus-circle")
        plusButton.setImage(plusImage, for: .normal)
        plusButton.frame = CGRect(x: Int(UIScreen.main.bounds.maxX) - 65, y: 260, width: 45, height: 45)
        self.addSubview(plusButton)
        
        
        let minusButtonWidth = minusButton.frame.width
        let plusButtonX = plusButton.frame.origin.x
        let ticketCountLabelWidth: CGFloat = 150
        let ticketCountLabelX = minusButtonWidth + (plusButtonX - minusButtonWidth - ticketCountLabelWidth) / 2
        ticketImage.frame = CGRect(x: ticketCountLabelX - 10, y: 220, width: 192, height: 125)
        ticketCountLabel.frame = CGRect(x: ticketCountLabelX, y: 260, width: ticketCountLabelWidth, height: 45)
        
        oneTicketPrice.textColor = colorBlackWhite
        oneTicketPrice.font = UIFont.systemFont(ofSize: 16)
        oneTicketPrice.text = "\(defaultLocalizer.stringForKey(key: "OneTicketPrice"))"
        let labelWidthTicket = oneTicketPrice.text?.size(withAttributes: [.font: oneTicketPrice.font]).width ?? 0
        oneTicketPrice.frame = CGRect(x: 15, y: view_button.frame.maxY + 24, width: labelWidthTicket, height: 22)
        self.addSubview(oneTicketPrice)
        
        
        oneTicketPriceCount.frame = CGRect(x: labelWidthTicket + 16, y: view_button.frame.maxY + 24, width: 162, height: 22)
        oneTicketPriceCount.textColor = .orange
        oneTicketPriceCount.font = UIFont.boldSystemFont(ofSize: 16)
        oneTicketPriceCount.text = "0"
        self.addSubview(oneTicketPriceCount)
        
        
        totalMb.textColor = colorBlackWhite
        totalMb.font = UIFont.systemFont(ofSize: 16)
        totalMb.text = "\(defaultLocalizer.stringForKey(key: "Present"))"
        let labelWidthTotalMb = totalMb.text?.size(withAttributes: [.font: totalMb.font]).width ?? 0
        totalMb.frame = CGRect(x: 15, y: oneTicketPrice.frame.maxY + 6, width: 162, height: 22)
        self.addSubview(totalMb)
        
        totalMbCount.frame = CGRect(x: labelWidthTotalMb + 16, y: oneTicketPrice.frame.maxY + 6, width: 162, height: 22)
        totalMbCount.textColor = .orange
        totalMbCount.font = UIFont.boldSystemFont(ofSize: 16)
        totalMbCount.text = "0"
        self.addSubview(totalMbCount)
        
        
        total.textColor = colorBlackWhite
        total.font = UIFont.boldSystemFont(ofSize: 16)
        total.text = "\(defaultLocalizer.stringForKey(key: "TOTAL")): "
        let labelWidthTotal = total.text?.size(withAttributes: [.font: total.font]).width ?? 0
        total.frame = CGRect(x: 15, y: totalMb.frame.maxY + 10, width: labelWidthTotal, height: 22)
        self.addSubview(total)
        
        totalCount.frame = CGRect(x: labelWidthTotal + 16, y: totalMb.frame.maxY + 10, width: 162, height: 22)
        totalCount.textColor = .orange
        totalCount.font = UIFont.boldSystemFont(ofSize: 16)
        totalCount.text = "0"
        self.addSubview(totalCount)
        
        
        self.addSubview(view_button)

        
        
        
        
        
    }
    private func updateTicketCountLabel() {
        ticketCountLabel.text = "\(ticketCount)"
    }
    
    
}


