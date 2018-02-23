//
//  MainVC-View.swift
//  ListMaster
//
//  Created by Paweł Ambrożej on 02/02/2018.
//  Copyright © 2018 Paweł Ambrożej. All rights reserved.
//

import UIKit

extension MainVC {
    func setupLayout() {
        //        view.addGradient()
        view.backgroundColor = BACKGROUND_COLOR
        bottomView.backgroundColor = .white
        view.addSubview(topView)
        view.addSubview(bottomView)
        bottomView.addSubview(listsTableView)
        bottomView.addSubview(titleBG)
        titleBG.addSubview(titleLabel)
        topView.addSubview(logo)
        view.addSubview(addItemButton)
        let height = (UIScreen.main.bounds.height/2)
        listsTableView.backgroundColor = .clear
        topViewConstraints = topView.constraintsWithDistanceTo(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.centerYAnchor, topDistance: 20, leftDistance: 0, rightDistance: 0, bottomDistance: -height)
        logo.centerInTheView(centerX: topView.centerXAnchor, centerY: topView.centerYAnchor)
        
        _ = bottomView.constraintAnchors(top: topView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, topDistance: 0, leftDistance: 12.5, rightDistance: 12.5, bottomDistance: 0, height: nil, width: nil)
        _ = titleBG.constraintAnchors(top: bottomView.topAnchor, left: bottomView.leftAnchor, right: bottomView.rightAnchor, bottom: nil, topDistance: 0, leftDistance: 0, rightDistance: 0, bottomDistance: 0, height: 60, width: nil)

        addItemButton.centerInTheView(centerX: nil, centerY: bottomView.topAnchor)
        addItemButton.setPropertyOf(width: 52, height: 52)
        addItemButton.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -10).isActive = true
        
        titleLabel.centerInTheView(centerX: titleBG.centerXAnchor, centerY: titleBG.centerYAnchor)
        _ = listsTableView.constraintsWithDistanceTo(top: titleBG.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, topDistance: 0, leftDistance: 15, rightDistance: 15, bottomDistance: 0)
        topViewBottomConstraint = getConstraintWith(identifier: "bottomAnchorConstraint", from: topViewConstraints)
//        constraint?.constant = height
        
    }
}
