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
    let margin:CGFloat = 25
    
    var textColor:UIColor = .black
    
    let topBorder:UIView = {
        let bv = UIView()
        bv.backgroundColor = .black
        bv.setPropertyOf(width: nil, height: 1)
        return bv
    }()
    
    let bottomBorder:UIView = {
        let bv = UIView()
        bv.backgroundColor = .black
        bv.setPropertyOf(width: nil, height: 1)
        return bv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    convenience init(leftTitle leftTitleText:String,rightTitle rightTitleText:String) {
        self.init(frame: CGRect())
        self.leftTitle.text = leftTitleText
        self.rightTitle.text = rightTitleText
        self.setColorsOf(text: .white, background: MAIN_COLOR)
        
        
        self.leftTitle.font = UIFont(name: "HelveticaNeue-bold", size: 16)
        self.rightTitle.font = UIFont(name: "HelveticaNeue-bold", size: 16)
        self.rightTitle.textAlignment = .right
        
        self.addSubview(self.leftTitle)
        self.addSubview(self.rightTitle)
        
        _ = self.leftTitle.constraintsWithDistanceTo(top: self.topAnchor, left: self.leftAnchor, right: nil, bottom: self.bottomAnchor, topDistance: 0, leftDistance: margin, rightDistance: 0, bottomDistance: 0)
        self.leftTitle.setPropertyOf(width: 100, height: nil)
        _ = self.rightTitle.constraintsWithDistanceTo(top: self.topAnchor, left: nil, right: self.rightAnchor, bottom: self.bottomAnchor, topDistance: 0, leftDistance: 0, rightDistance: margin, bottomDistance: 0)
        self.rightTitle.setPropertyOf(width: 100, height: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setColorsOf(text textColor: UIColor, background backgroundColor: UIColor){
        self.rightTitle.textColor = textColor
        self.leftTitle.textColor = textColor
        self.backgroundColor = backgroundColor
    }
    
    func addBordersOn(top: Bool,bottom: Bool, height: CGFloat, color: UIColor){
        if top {
            self.addSubview(topBorder)
            topBorder.backgroundColor = color
            topBorder.constraintsTo(top: self.topAnchor, left: self.leftAnchor, right: self.rightAnchor, bottom: nil)
            topBorder.setPropertyOf(width: nil, height: height)
            
        }
        if bottom {
            self.addSubview(bottomBorder)
            bottomBorder.backgroundColor = color
            bottomBorder.constraintsTo(top: nil, left: self.leftAnchor, right: self.rightAnchor, bottom: self.bottomAnchor)
            bottomBorder.setPropertyOf(width: nil, height: height)
        }
    }
}

