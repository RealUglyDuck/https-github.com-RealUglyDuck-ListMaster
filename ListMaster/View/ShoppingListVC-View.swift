//
//  ShoppingListVC-View.swift
//  ListMaster
//
//  Created by Paweł Ambrożej on 09/07/2018.
//  Copyright © 2018 Paweł Ambrożej. All rights reserved.
//

import UIKit

extension ShoppingListVC {
    func setupLayout() {
        view.backgroundColor = .white
        view.addSubview(listTableView)
        view.addSubview(emptyListView)
        view.addSubview(titleBG)
        titleBG.addSubview(backButton)
        titleBG.addSubview(backButtonTapView)
        titleBG.addSubview(titleLabel)
        titleBG.addSubview(addItemButton)
        view.addSubview(bottomBG)
        
        _ = titleBG.constraintAnchors(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topDistance: 0, leftDistance: 0, rightDistance: 0, bottomDistance: 0, height: 80, width: nil)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.leftAnchor.constraint(equalTo: titleBG.leftAnchor, constant: 25).isActive = true
        backButton.centerYAnchor.constraint(equalTo: titleBG.centerYAnchor, constant: 0).isActive = true
        backButton.setPropertyOf(width: 20, height: 30)
        backButtonTapView.centerInTheView(centerX: backButton.centerXAnchor, centerY: backButton.centerYAnchor)
        backButtonTapView.setPropertyOf(width: 80, height: 50)
        
        addItemButton.translatesAutoresizingMaskIntoConstraints = false
        addItemButton.setPropertyOf(width: 32, height: 32)
        addItemButton.centerInTheView(centerX: nil, centerY: backButton.centerYAnchor)
        addItemButton.rightAnchor.constraint(equalTo: titleBG.rightAnchor, constant: -25).isActive = true
        
        _ = titleLabel.centerInTheView(centerX: titleBG.centerXAnchor, centerY: backButton.centerYAnchor)
        _ = listTableView.constraintsWithDistanceTo(top: titleBG.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: bottomBG.topAnchor, topDistance: 15, leftDistance: 0, rightDistance: 0, bottomDistance: 0)
        _ = emptyListView.constraintsWithDistanceTo(top: listTableView.topAnchor, left: listTableView.leftAnchor, right: listTableView.rightAnchor, bottom: listTableView.bottomAnchor, topDistance: 0, leftDistance: 0, rightDistance: 0, bottomDistance: 0)
        
        bottomBG.constraintsTo(top: nil, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)
        bottomBG.setPropertyOf(width: nil, height: 40)
        
        listTableView.backgroundColor = .clear
    }
}
