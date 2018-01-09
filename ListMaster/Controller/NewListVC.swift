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
    
    let blurredBackground: UIVisualEffectView = {
        let blur = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let view = UIVisualEffectView(effect: blur)
        return view
    }()
    
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = BACKGROUND_COLOR.withAlphaComponent(0.5)
        
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 3
        view.layer.cornerRadius = 23
        return view
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named:"CloseIcon")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
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
    }

    func setupLayout() {
        view.backgroundColor = BACKGROUND_COLOR.withAlphaComponent(0.8)
        view.addSubview(backgroundView)
        view.addSubview(closeButton)
        backgroundView.addSubview(stackView)
        stackView.addSubview(listNameTextField)
        stackView.addSubview(createButton)
        listNameTextField.translatesAutoresizingMaskIntoConstraints = false
        createButton.translatesAutoresizingMaskIntoConstraints = false

        
        
//        blurredBackground.constraintsTo(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)
        _ = backgroundView.constraintsWithDistanceTo(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topDistance: 45, leftDistance: 15, rightDistance: 15, bottomDistance: 0)
        backgroundView.setPropertyOf(width: nil, height: 190)
        _ = closeButton.constraintsWithDistanceTo(top: backgroundView.topAnchor, left: nil, right: backgroundView.rightAnchor, bottom: nil, topDistance: -7, leftDistance: 0, rightDistance: -7, bottomDistance: 0)
        closeButton.setPropertyOf(width: 22, height: 22)
        stackView.centerInTheView(centerX: backgroundView.centerXAnchor, centerY: backgroundView.centerYAnchor)
        _ = stackView.constraintsWithDistanceTo(top: nil, left: backgroundView.leftAnchor, right: backgroundView.rightAnchor, bottom: nil, topDistance: 0, leftDistance: 30, rightDistance: 30, bottomDistance: 0)
        stackView.setPropertyOf(width: nil, height: 110)
        _ = listNameTextField.constraintAnchors(top: stackView.topAnchor, left: stackView.leftAnchor, right: stackView.rightAnchor, bottom: nil, topDistance: 0, leftDistance: 0, rightDistance: 0, bottomDistance: 0, height: 40, width: nil)
        _  = createButton.constraintAnchors(top: nil, left: stackView.leftAnchor, right: stackView.rightAnchor, bottom: stackView.bottomAnchor, topDistance: 0, leftDistance: 0, rightDistance: 0, bottomDistance: 0, height: 40, width: nil)
        

        
    }

}
