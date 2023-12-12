//
//  HistoryHeaderCell.swift
//  ZET-Mobile
//
//  Created by ScrumTJ on 11/03/22.
//

import UIKit

class HistoryHeaderCell: UITableViewHeaderFooterView {
    
    
    let title = UILabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 1
        title.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
        title.font = UIFont.systemFont(ofSize: 15)
        title.textAlignment = .left
        contentView.addSubview(title)

        NSLayoutConstraint.activate([
           
            title.heightAnchor.constraint(equalToConstant: 30),
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            title.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor,
                   constant: 8),
            title.trailingAnchor.constraint(equalTo:
                   contentView.layoutMarginsGuide.trailingAnchor),
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
