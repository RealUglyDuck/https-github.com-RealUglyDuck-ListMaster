//
//  TableHeaderView.swift
//  ListMaster
//
//  Created by Paweł Ambrożej on 18/12/2017.
//  Copyright © 2017 Paweł Ambrożej. All rights reserved.
//

import UIKit

class TableHeaderView: UIView {
    
    let leftTitle: StandardUILabel = {
        let title = StandardUILabel()
        title.accessibilityTraits = UIAccessibilityTraitHeader
        return title
    }()
    let rightTitle: StandardUILabel = {
        let title = StandardUILabel()
        title.accessibilityTraits = UIAccessibilityTraitHeader
        return title
    }()
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
        self.backgroundColor = .white
        
        headerView.layer.cornerRadius = 14.5
        
        let font = UIFont(name: "HelveticaNeue-bold", size: 16)
        let fontMetrics = UIFontMetrics(forTextStyle: .body)
        self.leftTitle.font = fontMetrics.scaledFont(for: font!)
        self.rightTitle.font = fontMetrics.scaledFont(for: font!)
        self.rightTitle.textAlignment = .right
        
        self.addSubview(headerView)
        headerView.addSubview(self.leftTitle)
        headerView.addSubview(self.rightTitle)
        
        _ = headerView.constraintsWithDistanceTo(top: self.topAnchor, left: self.leftAnchor, right: self.rightAnchor, bottom: self.bottomAnchor, topDistance: 0, leftDistance: margin, rightDistance: margin, bottomDistance: 0)
        _ = leftTitle.constraintsWithDistanceTo(top: headerView.topAnchor, left: headerView.leftAnchor, right: headerView.centerXAnchor, bottom: headerView.bottomAnchor, topDistance: 0, leftDistance: margin, rightDistance: 10, bottomDistance: 0)
//        leftTitle.setPropertyOf(width: 100, height: nil)
        _ = rightTitle.constraintsWithDistanceTo(top: headerView.topAnchor, left: headerView.centerXAnchor, right: headerView.rightAnchor, bottom: headerView.bottomAnchor, topDistance: 0, leftDistance: 10, rightDistance: margin, bottomDistance: 0)
//        rightTitle.setPropertyOf(width: 100, height: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setColorsOf(text textColor: UIColor, background backgroundColor: UIColor){
        self.rightTitle.textColor = textColor
        self.leftTitle.textColor = textColor
        headerView.backgroundColor = backgroundColor
    }
    
    func setTitles(leftTitle:String,rightTitle:String){
        self.leftTitle.text = leftTitle
        self.rightTitle.text = rightTitle
    }
}

