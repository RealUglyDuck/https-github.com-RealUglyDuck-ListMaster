//
//  ItemCell.swift
//  ListMaster
//
//  Created by Paweł Ambrożej on 20/12/2017.
//  Copyright © 2017 Paweł Ambrożej. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    let name = StandardUILabel()
    let amount = StandardUILabel()
    let measureUnit = StandardUILabel()
    let separator:UIView = {
        let sep = UIView()
        sep.backgroundColor = MAIN_COLOR
        return sep
        
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.addSubview(name)
        self.addSubview(amount)
        self.addSubview(measureUnit)
        self.addSubview(separator)
        amount.textAlignment = .right
        _ = measureUnit.constraintsWithDistanceTo(top: self.topAnchor, left: nil, right: self.rightAnchor, bottom: self.bottomAnchor, topDistance: 0, leftDistance: 0, rightDistance: 25, bottomDistance: 0)
        measureUnit.setPropertyOf(width: 30, height: nil)
        _ = amount.constraintsWithDistanceTo(top: measureUnit.topAnchor, left: nil, right: measureUnit.leftAnchor, bottom: measureUnit.bottomAnchor, topDistance: 0, leftDistance: 0, rightDistance: 5, bottomDistance: 0)
        amount.setPropertyOf(width: 50, height: nil)
        _ = name.constraintsWithDistanceTo(top: measureUnit.topAnchor, left: self.leftAnchor, right: amount.leftAnchor, bottom: measureUnit.bottomAnchor, topDistance: 0, leftDistance: 25, rightDistance: 5, bottomDistance: 0)
        
        _ = separator.constraintAnchors(top: nil, left: self.leftAnchor, right: self.rightAnchor, bottom: self.bottomAnchor, topDistance: 0, leftDistance: 25, rightDistance: 25, bottomDistance: 0, height: 0.5, width: nil)
        
    }
    
    func configureCell(object: Product) {
        self.name.text = object.name
        self.amount.text = object.amount
        self.measureUnit.text = object.measureUnit
        
        if object.isInBasket {
            self.name.textColor = SECONDARY_COLOR
            self.amount.textColor = SECONDARY_COLOR
            self.measureUnit.textColor = SECONDARY_COLOR
        } else {
            self.name.textColor = .white
            self.amount.textColor = .white
            self.measureUnit.textColor = .white
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
