//
//  ConfirmationView.swift
//  ListMaster
//
//  Created by Paweł Ambrożej on 26/05/2018.
//  Copyright © 2018 Paweł Ambrożej. All rights reserved.
//

import UIKit

class DeleteConfirmationView: UIView {

    lazy var mainStack:UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.addArrangedSubview(deleteLabel)
        let buttonsStack = UIStackView()
        buttonsStack.distribution = .fillEqually
        buttonsStack.addArrangedSubview(yesButton)
        buttonsStack.addArrangedSubview(noButton)
        stack.addArrangedSubview(buttonsStack)
        return stack
    }()
    
    let yesButton: StandardUIButton = {
        let button = StandardUIButton()
        button.setTitle("YES", for: .normal)
        return button
    }()
    
    let noButton: StandardUIButton = {
        let button = StandardUIButton()
        button.setTitle("NO", for: .normal)
        return button
    }()
    
    var deleteLabel:StandardUILabel = {
        let label = StandardUILabel()
        label.text = "Delete?"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        setupViews()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(mainStack)
        mainStack.constraintToSuperView()
        
    }

}
