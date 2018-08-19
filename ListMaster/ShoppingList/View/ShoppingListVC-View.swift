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
        titleBG.addSubview(backButtonTapButton)
        titleBG.addSubview(titleLabel)
        titleBG.addSubview(addItemButton)
        titleBG.addSubview(addItemTapButton)
        view.addSubview(bottomBG)
        
        _ = titleBG.constraintAnchors(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topDistance: 0, leftDistance: 0, rightDistance: 0, bottomDistance: 0, height: 80, width: nil)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.leftAnchor.constraint(equalTo: titleBG.leftAnchor, constant: 25).isActive = true
        backButton.centerYAnchor.constraint(equalTo: titleBG.centerYAnchor, constant: 0).isActive = true
        backButton.setPropertyOf(width: 20, height: 30)
        backButtonTapButton.centerInTheView(centerX: backButton.centerXAnchor, centerY: backButton.centerYAnchor)
        backButtonTapButton.setPropertyOf(width: 60, height: 60)
        
        addItemButton.translatesAutoresizingMaskIntoConstraints = false
        addItemButton.setPropertyOf(width: 32, height: 32)
        addItemButton.centerInTheView(centerX: nil, centerY: backButton.centerYAnchor)
        addItemButton.rightAnchor.constraint(equalTo: titleBG.rightAnchor, constant: -25).isActive = true
        addItemTapButton.centerInTheView(centerX: addItemButton.centerXAnchor, centerY: addItemButton.centerYAnchor)
        addItemTapButton.setPropertyOf(width: 60, height: 60)
        
        _ = titleLabel.centerInTheView(centerX: titleBG.centerXAnchor, centerY: backButton.centerYAnchor)
        _ = listTableView.constraintsWithDistanceTo(top: titleBG.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: bottomBG.topAnchor, topDistance: 15, leftDistance: 0, rightDistance: 0, bottomDistance: 0)
        _ = emptyListView.constraintsWithDistanceTo(top: listTableView.topAnchor, left: listTableView.leftAnchor, right: listTableView.rightAnchor, bottom: listTableView.bottomAnchor, topDistance: 0, leftDistance: 0, rightDistance: 0, bottomDistance: 0)
        
        bottomBG.constraintsTo(top: nil, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)
        bottomBG.setPropertyOf(width: nil, height: 40)
        
        listTableView.backgroundColor = .clear
    }
}
