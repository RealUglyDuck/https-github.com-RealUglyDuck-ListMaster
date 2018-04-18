//
//  NoListView.swift
//  ListMaster
//
//  Created by Paweł Ambrożej on 18/04/2018.
//  Copyright © 2018 Paweł Ambrożej. All rights reserved.
//

import UIKit

class NoListView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        let label = UILabel()
        let fontType = UIFont(name: "HelveticaNeue-Medium", size: 16)
        let fontMetrics = UIFontMetrics(forTextStyle: .body)
        let font = fontMetrics.scaledFont(for: fontType!)
        let attributedText = NSMutableAttributedString(string: "You don't have any lists. \n Press ", attributes: [NSAttributedStringKey.font:font])
        let attributedImage = NSTextAttachment()
        let image = UIImage(named: "AddButton")
        attributedImage.image = image
        attributedImage.bounds = CGRect(x: 0, y: -(image?.size.height)!/8, width: (image?.size.width)!/2, height: (image?.size.height)!/2)
        
        attributedText.append(NSAttributedString(attachment: attributedImage))
        attributedText.append(NSAttributedString(string: " button to create new list.", attributes: [NSAttributedStringKey.font:font]))
        label.attributedText = attributedText
        label.textColor = MAIN_COLOR
        addSubview(label)
        label.centerInTheView(centerX: centerXAnchor, centerY: centerYAnchor)
        _ = label.constraintsWithDistanceTo(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, topDistance: 20, leftDistance: 20, rightDistance: 20, bottomDistance: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
