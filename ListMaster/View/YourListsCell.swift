//
//  YourListsCell.swift
//  ListMaster
//
//  Created by Paweł Ambrożej on 04/12/2017.
//  Copyright © 2017 Paweł Ambrożej. All rights reserved.
//

import UIKit

class YourListsCell: UICollectionViewCell {
    
    var tableView:UITableView  = {
        let table = UITableView()
        return table
    }()
    
    var titleLabel = TitleUILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(titleLabel)
        addSubview(tableView)
        _ = titleLabel.constraintsWithDistanceTo(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: nil, topDistance: 0, leftDistance: 0, rightDistance: 0, bottomDistance: 0)
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tableView.constraintsTo(top: titleLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

