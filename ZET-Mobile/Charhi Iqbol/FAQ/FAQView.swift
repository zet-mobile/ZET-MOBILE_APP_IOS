//
//  FAQView.swift
//  ZET-Mobile
//
//  Created by iDev on 05/09/23.
//

import UIKit

class FAQView: UIView {
    
    
   
    
    lazy var conditionText: UILabel = {
       let condText = UILabel()
        condText.frame = CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.size.width), height: 75)
        condText.textColor = colorBlackWhite
        condText.textAlignment = .center
        condText.font = UIFont.boldSystemFont(ofSize: 26)
        condText.numberOfLines = 0
        condText.lineBreakMode = .byWordWrapping
        condText.text = "\(defaultLocalizer.stringForKey(key: "DRAW_TERMS"))"
        
        condText.translatesAutoresizingMaskIntoConstraints = false
            //  condText.widthAnchor.constraint(equalToConstant: 247).isActive = true
       // condText.heightAnchor.constraint(equalToConstant: 75).isActive = true
        return condText
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
        self.addSubview(conditionText)
    }

}
