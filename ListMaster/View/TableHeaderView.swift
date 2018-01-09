//
//  TableHeaderView.swift
//  ListMaster
//
//  Created by Paweł Ambrożej on 18/12/2017.
//  Copyright © 2017 Paweł Ambrożej. All rights reserved.
//

import UIKit

class TableHeaderView: UIView {
    
    let leftTitle = StandardUILabel()
    let rightTitle = StandardUILabel()
    let headerView = UIView()
    let margin:CGFloat = 12.5
    
    var textColor:UIColor = .black
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    convenience init(leftTitle leftTitleText:String,rightTitle rightTitleText:String) {
        self.init(frame: CGRect())
        self.leftTitle.text = leftTitleText
        self.rightTitle.text = rightTitleText
        self.setColorsOf(text: .white, background: MAIN_COLOR)
        self.backgroundColor = .clear
        
        headerView.layer.cornerRadius = 14.5
        self.leftTitle.font = UIFont(name: "HelveticaNeue-bold", size: 16)
        self.rightTitle.font = UIFont(name: "HelveticaNeue-bold", size: 16)
        self.rightTitle.textAlignment = .right
        
        self.addSubview(headerView)
        headerView.addSubview(self.leftTitle)
        headerView.addSubview(self.rightTitle)
        
        _ = headerView.constraintsWithDistanceTo(top: self.topAnchor, left: self.leftAnchor, right: self.rightAnchor, bottom: self.bottomAnchor, topDistance: 0, leftDistance: margin, rightDistance: margin, bottomDistance: 0)
        _ = leftTitle.constraintsWithDistanceTo(top: headerView.topAnchor, left: headerView.leftAnchor, right: nil, bottom: headerView.bottomAnchor, topDistance: 0, leftDistance: margin, rightDistance: 0, bottomDistance: 0)
        leftTitle.setPropertyOf(width: 100, height: nil)
        _ = rightTitle.constraintsWithDistanceTo(top: headerView.topAnchor, left: nil, right: headerView.rightAnchor, bottom: headerView.bottomAnchor, topDistance: 0, leftDistance: 0, rightDistance: margin, bottomDistance: 0)
        rightTitle.setPropertyOf(width: 100, height: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setColorsOf(text textColor: UIColor, background backgroundColor: UIColor){
        self.rightTitle.textColor = textColor
        self.leftTitle.textColor = textColor
        headerView.backgroundColor = backgroundColor
    }
    
}

