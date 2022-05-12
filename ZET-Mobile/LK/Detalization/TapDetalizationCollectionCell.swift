//
//  TapDetalizationCollectionCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 12/1/21.
//

import UIKit

class TapDetalizationCollectionCell: UICollectionViewCell {
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        contentView.backgroundColor = .clear
        contentView.autoresizesSubviews = true
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
