//
//  TimetableDetailsFooters.swift
//  HTWDD
//
//  Created by Chris Herlemann on 21.07.21.
//  Copyright © 2021 HTW Dresden. All rights reserved.
//

class RequiredFooter: UITableViewHeaderFooterView {
    
    let title = UILabel()
    let background = UIView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configureContents()
    }
    
    func configureContents() {
        
        background.backgroundColor = UIColor.htw.cellBackground
        
        if #available(iOS 11.0, *) {
            background.layer.cornerRadius = 6
            background.layer.masksToBounds = true
            background.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        
        contentView.backgroundColor = UIColor.htw.veryLightGrey
        
        background.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 14)
        
        contentView.addSubview(background)
        contentView.addSubview(title)
        
        NSLayoutConstraint.activate([
            background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            background.topAnchor.constraint(equalTo: contentView.topAnchor),
            background.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            
            title.heightAnchor.constraint(equalToConstant: 30),
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class EmptyFooter: UITableViewHeaderFooterView {
    
    let background = UIView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configureContents()
    }
    
    func configureContents() {
        
        background.backgroundColor = UIColor.htw.cellBackground
        
        if #available(iOS 11.0, *) {
            background.layer.cornerRadius = 6
            background.layer.masksToBounds = true
            background.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        
        contentView.backgroundColor = UIColor.htw.veryLightGrey
        
        background.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(background)
        
        NSLayoutConstraint.activate([
            background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            background.topAnchor.constraint(equalTo: contentView.topAnchor),
            background.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
