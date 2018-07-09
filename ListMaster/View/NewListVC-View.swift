//
//  NewListVC-View.swift
//  ListMaster
//
//  Created by Paweł Ambrożej on 09/07/2018.
//  Copyright © 2018 Paweł Ambrożej. All rights reserved.
//

import UIKit

extension NewListVC {
    func setupLayout() {
        view.backgroundColor = BACKGROUND_COLOR.withAlphaComponent(0.8)
        view.addSubview(backgroundView)
        view.addSubview(closeButton)
        view.addSubview(closeButtonTapView)
        backgroundView.addSubview(stackView)
        stackView.addSubview(listNameTextField)
        stackView.addSubview(createButton)
        
        _ = backgroundView.constraintsWithDistanceTo(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topDistance: 45, leftDistance: 15, rightDistance: 15, bottomDistance: 0)
        
        backgroundView.setPropertyOf(width: nil, height: 190)
        
        closeButton.centerInTheView(centerX: backgroundView.rightAnchor, centerY: backgroundView.topAnchor)
        
        closeButton.setPropertyOf(width: 32, height: 32)
        
        closeButtonTapView.centerInTheView(centerX: closeButton.centerXAnchor, centerY: closeButton.centerYAnchor)
        
        closeButtonTapView.setPropertyOf(width: 35, height: 35)
        
        stackView.centerInTheView(centerX: backgroundView.centerXAnchor, centerY: backgroundView.centerYAnchor)
        
        _ = stackView.constraintsWithDistanceTo(top: nil, left: backgroundView.leftAnchor, right: backgroundView.rightAnchor, bottom: nil, topDistance: 0, leftDistance: 30, rightDistance: 30, bottomDistance: 0)
        
        stackView.setPropertyOf(width: nil, height: 110)
        
        _ = listNameTextField.constraintAnchors(top: stackView.topAnchor, left: stackView.leftAnchor, right: stackView.rightAnchor, bottom: nil, topDistance: 0, leftDistance: 0, rightDistance: 0, bottomDistance: 0, height: 40, width: nil)
        
        _  = createButton.constraintAnchors(top: nil, left: stackView.leftAnchor, right: stackView.rightAnchor, bottom: stackView.bottomAnchor, topDistance: 0, leftDistance: 0, rightDistance: 0, bottomDistance: 0, height: 40, width: nil)
        
        
        
    }
}
