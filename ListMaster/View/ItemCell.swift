//
//  ItemCell.swift
//  ListMaster
//
//  Created by Paweł Ambrożej on 20/12/2017.
//  Copyright © 2017 Paweł Ambrożej. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    override var isAccessibilityElement: Bool{
        get {
            return true
        }
        set {}
    }
    
    override var accessibilityLabel: String? {
        get{
            return "\(name.text ?? "") \(amount.text ?? "") \(measureUnit.text ?? "")"
        }
        set{}
    }
    
    let name:StandardUILabel =  {
        let nameLabel = StandardUILabel()
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        return nameLabel
    }()
    let amount = StandardUILabel()
    let measureUnit = StandardUILabel()
    let separator:UIView = {
        let sep = UIView()
        sep.backgroundColor = MAIN_COLOR.withAlphaComponent(0.8)
        return sep
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.addSubview(name)
        self.addSubview(amount)
        self.addSubview(measureUnit)
        self.addSubview(separator)
        
        amount.textAlignment = .right
        _ = measureUnit.constraintsWithDistanceTo(top: self.topAnchor, left: nil, right: self.rightAnchor, bottom: self.bottomAnchor, topDistance: 0, leftDistance: 0, rightDistance: 25, bottomDistance: 0)
        measureUnit.setPropertyOf(width: 50, height: nil)
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
            self.separator.backgroundColor = SECONDARY_COLOR.withAlphaComponent(0.5)
        } else {
            self.name.textColor = MAIN_COLOR
            self.amount.textColor = MAIN_COLOR
            self.measureUnit.textColor = MAIN_COLOR
            self.separator.backgroundColor = MAIN_COLOR.withAlphaComponent(0.5)
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
