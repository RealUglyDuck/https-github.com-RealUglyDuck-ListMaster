//
//  TutorialViewCellCollectionViewCell.swift
//  ListMaster
//
//  Created by Paweł Ambrożej on 11/03/2018.
//  Copyright © 2018 Paweł Ambrożej. All rights reserved.
//

import UIKit

class TutorialViewCell: UICollectionViewCell {
    
    let headerBG: UIImageView = {
        let bg = UIImageView()
        bg.backgroundColor = .white
        bg.contentMode = .center
        return bg
    }()
    
    lazy var imageView :UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .center
        textView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        textView.isEditable = false
        textView.isAccessibilityElement = true
        return textView
    }()
    
    let separator: UIView  = {
        let separatorView = UIView()
        separatorView.setPropertyOf(width: nil, height: 1)
        separatorView.backgroundColor = MAIN_COLOR.withAlphaComponent(0.3)
        return separatorView
    }()
    
    let startButton: FilledUIButton = {
        let button = FilledUIButton()
        button.setTitle("Get Started", for: .normal)
        button.isHidden = true
        button.isAccessibilityElement = true
        button.accessibilityTraits = UIAccessibilityTraitButton
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(page:Page) {
        let attributedString = createTutorialLabelFrom(title: page.title, and: page.description)
        textView.attributedText = attributedString
        if page.imageName != "" {
            imageView.image = UIImage(named: page.imageName)
            headerBG.layer.shadowOpacity = 0
            separator.isHidden = false
        } else {
            imageView.image = nil
            separator.isHidden = true
            headerBG.layer.shadowColor = UIColor.black.cgColor
            headerBG.layer.shadowOpacity = 0.2
            headerBG.layer.shadowOffset = CGSize(width: 0, height: 5)
            headerBG.layer.shadowRadius = 5
        }
    }
    
    func setupViews() {
        backgroundColor = .white
        imageView.backgroundColor = .clear
        textView.backgroundColor = .clear

        addSubview(headerBG)
        headerBG.addSubview(imageView)
        addSubview(textView)
        addSubview(separator)
        addSubview(startButton)
        
        
        _ = headerBG.constraintsWithDistanceTo(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: centerYAnchor, topDistance: 0, leftDistance: 0, rightDistance: 0, bottomDistance: -100)
        _ = imageView.constraintAnchors(top: nil, left: headerBG.leftAnchor, right: headerBG.rightAnchor, bottom: headerBG.bottomAnchor, topDistance: 0, leftDistance: 20, rightDistance: 20, bottomDistance: 0, height: 300, width: nil)
        _ = textView.constraintsWithDistanceTo(top: headerBG.bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, topDistance: 0, leftDistance: 20, rightDistance: 20, bottomDistance: 20)
        _ = separator.constraintsWithDistanceTo(top: headerBG.bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: nil, topDistance: 0, leftDistance: 30, rightDistance: 30, bottomDistance: 0  )
        startButton.centerInTheView(centerX: centerXAnchor, centerY: centerYAnchor)
        startButton.setPropertyOf(width: 200, height: 40)
    }
    
    func createTutorialLabelFrom(title:String,and description:String) -> NSMutableAttributedString{
        let titleFont = UIFont(name: "HelveticaNeue-Bold", size: 18)
        let titleMetricsFont = UIFontMetrics(forTextStyle: .body)
//        titleMetricsFont.scaledFont(for: titleFont!)
        let descFont = UIFont(name: "HelveticaNeue-Medium", size: 15)
        let descMetricsFont = UIFontMetrics(forTextStyle: .body)
//        descMetricsFont.scaledFont(for: descFont!)
        let titleColor = UIColor(red: 57/255, green: 57/255, blue: 57/255, alpha: 1)
        let descColor = UIColor(red: 97/255, green: 97/255, blue: 97/255, alpha: 1)
        let attributedString = NSMutableAttributedString(
            string: title,
            attributes: [NSAttributedStringKey.font:titleMetricsFont.scaledFont(for: titleFont!),
                         NSAttributedStringKey.foregroundColor:titleColor])
        
        attributedString.append(NSAttributedString(
            string: "\n\n\(description)",
            attributes: [NSAttributedStringKey.font:descMetricsFont.scaledFont(for: descFont!),
                         NSAttributedStringKey.foregroundColor:descColor]))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let lenght = attributedString.string.count
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, lenght))
        
        return attributedString
        
    }
}
