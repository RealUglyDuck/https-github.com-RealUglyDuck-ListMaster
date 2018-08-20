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
        bottomView.addSubview(titleBG)
        bottomView.addSubview(listsTableView)
        titleBG.addSubview(titleLabel)
        topView.addSubview(logo)
        view.addSubview(addItemButton)
        listsTableView.backgroundColor = .clear
        topView.addSubview(infoButton)
        topView.addSubview(infoTapView)
        view.addSubview(emptyListsView)
        
        let height = (view.bounds.height/2)-50
        
        topViewConstraints = topView.constraintsWithDistanceTo(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, topDistance: 0, leftDistance: 0, rightDistance: 0, bottomDistance: 0)
        
        _ = infoButton.constraintAnchors(top: topView.topAnchor, left: nil, right: topView.rightAnchor, bottom: nil, topDistance: 10, leftDistance:0 , rightDistance: 10, bottomDistance: 0, height: 32, width: 32)
        infoTapView.centerInTheView(centerX: infoButton.centerXAnchor, centerY: infoButton.centerYAnchor)
        infoTapView.setPropertyOf(width: 100 , height: 100)

        
        logo.centerInTheView(centerX: topView.centerXAnchor, centerY: topView.centerYAnchor)
//        logo.centerYAnchor.constraint(equalTo: topView.centerYAnchor, constant: -200).isActive = true
        
        _ = bottomView.constraintAnchors(top: topView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topDistance: 0, leftDistance: 12.5, rightDistance: 12.5, bottomDistance: 0, height: height, width: nil)
        _ = titleBG.constraintAnchors(top: bottomView.topAnchor, left: bottomView.leftAnchor, right: bottomView.rightAnchor, bottom: nil, topDistance: 0, leftDistance: 0, rightDistance: 0, bottomDistance: 0, height: 60, width: nil)

        addItemButton.centerInTheView(centerX: nil, centerY: bottomView.topAnchor)
        addItemButton.setPropertyOf(width: 52, height: 52)
        addItemButton.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -10).isActive = true
        
        titleLabel.centerInTheView(centerX: titleBG.centerXAnchor, centerY: titleBG.centerYAnchor)
        _ = listsTableView.constraintsWithDistanceTo(top: titleBG.bottomAnchor, left: bottomView.leftAnchor, right: bottomView.rightAnchor, bottom: bottomView.bottomAnchor, topDistance: 0, leftDistance: 15, rightDistance: 15, bottomDistance: 0)
        _ = emptyListsView.constraintsWithDistanceTo(top: listsTableView.topAnchor, left: listsTableView.leftAnchor, right: listsTableView.rightAnchor, bottom: listsTableView.bottomAnchor, topDistance: 40, leftDistance: 0, rightDistance: 0, bottomDistance: 0)
        topViewBottomConstraint = getConstraintWith(identifier: "bottomAnchorConstraint", from: topViewConstraints)
//        constraint?.constant = height
        
    }
}
