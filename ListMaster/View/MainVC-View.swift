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
//        bottomView.backgroundColor = .white
        view.addSubview(bottomView)
        bottomView.addSubview(listsTableView)
        bottomView.addSubview(titleBG)
        titleBG.addSubview(titleLabel)
        titleBG.addSubview(addItemButton)
        topView.addSubview(logo)
        view.addSubview(topView)
        let height = view.bounds.height/2
        listsTableView.backgroundColor = .clear
        topViewConstraints = topView.constraintsWithDistanceTo(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.centerYAnchor, topDistance: 20, leftDistance: 0, rightDistance: 0, bottomDistance: 0)
        logo.centerInTheView(centerX: topView.centerXAnchor, centerY: topView.centerYAnchor)
        
        _ = bottomView.constraintAnchors(top: topView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topDistance: 0, leftDistance: 0, rightDistance: 0, bottomDistance: 0, height: height, width: nil)
        _ = titleBG.constraintAnchors(top: bottomView.topAnchor, left: bottomView.leftAnchor, right: bottomView.rightAnchor, bottom: nil, topDistance: 0, leftDistance: 0, rightDistance: 0, bottomDistance: 0, height: 60, width: nil)
        addItemButton.translatesAutoresizingMaskIntoConstraints = false
        addItemButton.setPropertyOf(width: 22, height: 22)
        addItemButton.centerYAnchor.constraint(equalTo: titleBG.centerYAnchor).isActive = true
        addItemButton.rightAnchor.constraint(equalTo: titleBG.rightAnchor, constant: -25).isActive = true
        titleLabel.centerInTheView(centerX: titleBG.centerXAnchor, centerY: titleBG.centerYAnchor)
        _ = listsTableView.constraintsWithDistanceTo(top: titleBG.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, topDistance: 0, leftDistance: 0, rightDistance: 0, bottomDistance: 0)
        let constraint = getConstraintWith(identifier: "bottomAnchorConstraint", from: topViewConstraints)
        constraint?.constant = height
        
    }
}
