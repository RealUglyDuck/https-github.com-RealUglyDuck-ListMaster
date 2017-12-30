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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(name)
        self.addSubview(amount)
        self.addSubview(measureUnit)
        amount.textAlignment = .right
        _ = measureUnit.constraintsWithDistanceTo(top: self.topAnchor, left: nil, right: self.rightAnchor, bottom: self.bottomAnchor, topDistance: 0, leftDistance: 0, rightDistance: 25, bottomDistance: 0)
        measureUnit.setPropertyOf(width: 30, height: nil)
        _ = amount.constraintsWithDistanceTo(top: measureUnit.topAnchor, left: nil, right: measureUnit.leftAnchor, bottom: measureUnit.bottomAnchor, topDistance: 0, leftDistance: 0, rightDistance: 5, bottomDistance: 0)
        amount.setPropertyOf(width: 50, height: nil)
        _ = name.constraintsWithDistanceTo(top: measureUnit.topAnchor, left: self.leftAnchor, right: amount.leftAnchor, bottom: measureUnit.bottomAnchor, topDistance: 0, leftDistance: 25, rightDistance: 5, bottomDistance: 0)
        
        
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
            self.name.textColor = MAIN_COLOR
            self.amount.textColor = MAIN_COLOR
            self.measureUnit.textColor = MAIN_COLOR
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
