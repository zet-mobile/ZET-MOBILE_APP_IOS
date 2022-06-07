//
//  EmptyView.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 03/06/22.
//

import UIKit

class EmptyView: UIView {
    let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    // MARK: - Init
    init(frame: CGRect, text: String) {
        infoLabel.text = text
        super.init(frame: frame)
        configureView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Functions
    func configureView() {
        
        infoLabel.frame = CGRect(x: 20, y: 20, width: UIScreen.main.bounds.size.width - 40, height: 60)
        addSubview(infoLabel)
        
        
    }
}
