//
//  UnitsControllerView.swift
//  ListMaster
//
//  Created by Paweł Ambrożej on 16/02/2018.
//  Copyright © 2018 Paweł Ambrożej. All rights reserved.
//

import UIKit

class UnitOptionView: UIView {
    var optionName = StandardUILabel()
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setPropertyOf(width: 52, height: 52)
        self.layer.cornerRadius = 26
        self.backgroundColor = MAIN_COLOR
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowRadius = 5
        
        self.isAccessibilityElement = true
        self.accessibilityTraits = UIAccessibilityTraits.button
        optionName.text = "PCS"
        optionName.textColor = .white
        optionName.textAlignment = .center
        self.addSubview(optionName)
        optionName.centerInTheView(centerX: self.centerXAnchor, centerY: self.centerYAnchor)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
