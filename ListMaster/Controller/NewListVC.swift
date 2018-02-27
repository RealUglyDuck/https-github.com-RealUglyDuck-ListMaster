//
//  NewListVC.swift
//  ListMaster
//
//  Created by Paweł Ambrożej on 27/11/2017.
//  Copyright © 2017 Paweł Ambrożej. All rights reserved.
//

import UIKit
import CoreData

class NewListVC: UIViewController {

    let ad = UIApplication.shared.delegate as! AppDelegate
    lazy var context = ad.persistentContainer.viewContext

    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 3
        view.layer.cornerRadius = 23
        return view
    }()
    
    let closeButtonTapView = UIView()
    
    let closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named:"CloseIcon")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        button.isAccessibilityElement = true
        button.accessibilityLabel = "Back to Lists"
        button.accessibilityTraits = UIAccessibilityTraitButton
        return button
    }()
    
    let stackView = UIView()
    
    let listNameTextField: NewTextField = {
        let textField = NewTextField()
        textField.placeholder = "List name..."
        return textField
    }()
    
    let createButton: FilledUIButton = {
        let cb = FilledUIButton()
        cb.setTitle("Create", for: .normal)
        cb.addTarget(self, action: #selector(createButtonPressed), for: .touchUpInside)
        return cb
    }()
    
    
    @objc func closeButtonPressed() {
        dismissKeyboard()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func createButtonPressed() {
        if listNameTextField.text?.isEmpty == true {
            return
        } else {
            let newList = List(context: context)
            newList.name = listNameTextField.text
            newList.created = Date()
            ad.saveContext()
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        self.hideKeyboardWhenTappedAround()
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeButtonPressed))
        closeButtonTapView.addGestureRecognizer(tap)
        listNameTextField.becomeFirstResponder()
    }

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
