//
//  MainMenuCellCollectionViewCell.swift
//  ListMaster
//
//  Created by Paweł Ambrożej on 26/11/2017.
//  Copyright © 2017 Paweł Ambrożej. All rights reserved.
//

import UIKit

class MainMenuCell: UICollectionViewCell {
 
    let mainImage:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named:"NewListImage")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let separator:UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = MAIN_COLOR
        return separatorView
    }()
    
    let TitleUILabel: UIButton = {
        let ttf = UIButton()
        ttf.setTitle("Create New List", for: .normal)
        ttf.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 24)
        ttf.setTitleColor(MAIN_COLOR, for: .normal)
        ttf.contentHorizontalAlignment = .center
        return ttf
    }()
    
    let titleDescription: UILabel = {
        let ttf = UILabel()
        ttf.text = "Tap the image above to create new list or swipe to go through your lists."
        ttf.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        ttf.textColor = MAIN_COLOR
        ttf.textAlignment = .center
        ttf.numberOfLines = 2
        return ttf
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(mainImage)
        addSubview(separator)
        addSubview(TitleUILabel)
        addSubview(titleDescription)
        
        _ = mainImage.constraintsWithDistanceTo(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: nil, topDistance: 80, leftDistance: 60, rightDistance: 60, bottomDistance: 0)
        mainImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        _ = separator.constraintAnchors(top: mainImage.bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: nil, topDistance: 40, leftDistance: 20, rightDistance: 20, bottomDistance: 0, height: 0.5, width: nil)
        _ = TitleUILabel.constraintAnchors(top: separator.bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: nil, topDistance: 20, leftDistance: 0, rightDistance: 0, bottomDistance: 0, height: 28, width: nil)
        _ = titleDescription.constraintAnchors(top: TitleUILabel.bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: nil, topDistance: 6, leftDistance: 20, rightDistance: 20, bottomDistance: 0, height: 40, width: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
