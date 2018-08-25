//
//  GetStartedCell.swift
//  ListMaster
//
//  Created by Paweł Ambrożej on 19/08/2018.
//  Copyright © 2018 Paweł Ambrożej. All rights reserved.
//

import UIKit

class GetStartedCell: UICollectionViewCell {
    
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
    
    func setupViews() {
        addSubview(startButton)
        startButton.centerInTheView(centerX: centerXAnchor, centerY: centerYAnchor)
        startButton.setPropertyOf(width: 250, height: 50)
    }
    
}
