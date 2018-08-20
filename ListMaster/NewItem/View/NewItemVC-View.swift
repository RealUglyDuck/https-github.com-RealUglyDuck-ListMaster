//
//  NewItemVC-View.swift
//  ListMaster
//
//  Created by Paweł Ambrożej on 20/02/2018.
//  Copyright © 2018 Paweł Ambrożej. All rights reserved.
//

import Foundation

extension NewItemVC{
    
    func setupLayout() {
        view.backgroundColor = .white
        predictionTableView.backgroundColor = BACKGROUND_COLOR.withAlphaComponent(0.9)
        predictionTableView.separatorColor = .clear
        view.addSubview(titleBG)
        titleBG.addSubview(backButton)
        titleBG.addSubview(backButtonTapButton)
        titleBG.addSubview(titleLabel)
        view.addSubview(mainStack)
        mainStack.addArrangedSubview(itemNameTextField)
        mainStack.addArrangedSubview(amountStackView)
        amountStackView.addArrangedSubview(amountLabel)
        amountStackView.addArrangedSubview(amountTextField)
        amountStackView.addArrangedSubview(amountButtonStack)
        amountButtonStack.addArrangedSubview(plusButton)
        amountButtonStack.addArrangedSubview(minusButton)
        mainStack.addArrangedSubview(segmentsStackView)
        
        for unit in unitButtons{
            segmentsStackView.addArrangedSubview(unit)
        }

        mainStack.addArrangedSubview(addButton)
        view.addSubview(predictionTableView)
        view.addSubview(addedItemPopupView)
        _ = addedItemPopupView.constraintsWithDistanceTo(top: titleBG.bottomAnchor, left: nil, right: nil, bottom: nil, topDistance: 40, leftDistance: 0, rightDistance: 0, bottomDistance: 0)
        addedItemPopupView.centerInTheView(centerX: view.centerXAnchor, centerY: nil)
        addedItemPopupView.setPropertyOf(width: 200, height: 150)
        addedItemPopupView.isHidden = true
        _ = titleBG.constraintAnchors(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topDistance: 0, leftDistance: 0, rightDistance: 0, bottomDistance: 0, height: 80, width: nil)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.leftAnchor.constraint(equalTo: titleBG.leftAnchor, constant: 25).isActive = true
        backButton.centerYAnchor.constraint(equalTo: titleBG.centerYAnchor, constant: 0).isActive = true
        backButton.setPropertyOf(width: 20, height: 30)
        backButtonTapButton.centerInTheView(centerX: backButton.centerXAnchor, centerY: backButton.centerYAnchor)
        backButtonTapButton.setPropertyOf(width: 80, height: 50)
        
        _ = titleLabel.centerInTheView(centerX: titleBG.centerXAnchor, centerY: backButton.centerYAnchor)
        
        _ = mainStack.constraintsWithDistanceTo(top: titleBG.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.centerYAnchor, topDistance: 15, leftDistance: 30, rightDistance: 30, bottomDistance: -50)
        
        _ = predictionTableView.constraintsWithDistanceTo(top: itemNameTextField.bottomAnchor, left: itemNameTextField.leftAnchor, right: itemNameTextField.rightAnchor, bottom: nil, topDistance: 0, leftDistance: 12.5, rightDistance: 12.5, bottomDistance: 0)
        predictionHeightConstraint = predictionTableView.heightAnchor.constraint(equalToConstant: 0)
        predictionHeightConstraint!.isActive = true
        
        amountStackView.translatesAutoresizingMaskIntoConstraints = false
        segmentsStackView.translatesAutoresizingMaskIntoConstraints = false
        itemNameTextField.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        amountButtonStack.translatesAutoresizingMaskIntoConstraints = false
        amountStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        segmentsStackView.heightAnchor.constraint(equalToConstant: 52).isActive = true
        itemNameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
}
