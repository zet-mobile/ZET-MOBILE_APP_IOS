//
//  RemainderStackView.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/3/21.
//

import UIKit

class RemainderStackView: UIStackView {
    
    
    lazy var minutesRemainder: CircularProgressView = {
        let view = CircularProgressView()
        return view
    }()
    
    lazy var internetRemainder: CircularProgressView = {
        let view = CircularProgressView()
        return view
    }()
    
   /* lazy var messagesRemainder: CircularProgressView = {
        let view = CircularProgressView()
        return view
    }()*/
    
    let messagesRemainder = CircularProgressView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        axis = .horizontal
        alignment = .fill
        distribution = .fillEqually
        spacing  = 16
        //addBackground(color: .white, radiusSize: 4)
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 20, right: 16)
        messagesRemainder.plusText.isHidden = false
  
        addArrangedSubview(minutesRemainder)
        addArrangedSubview(internetRemainder)
        addArrangedSubview(messagesRemainder)
    }
    
}
