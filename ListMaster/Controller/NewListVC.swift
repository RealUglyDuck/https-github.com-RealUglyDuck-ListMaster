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
    
    let separator:UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = MAIN_COLOR
        return separatorView
    }()
    
    let backButton:StandardUIButton = {
        let button = StandardUIButton()
        button.setTitle("Back", for: .normal)
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let titleLabel: TitleUILabel = {
        let textTitle = TitleUILabel()
        textTitle.text = "Create New List"
        return textTitle
    }()
    
    let listNameTextField =  NewTextField()
    
    let createButton: FilledUIButton = {
        let cb = FilledUIButton()
        cb.setTitle("Create", for: .normal)
        cb.backgroundColor = MAIN_COLOR
        cb.setTitleColor(.white, for: .normal)
        cb.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        cb.addTarget(self, action: #selector(createButtonPressed), for: .touchUpInside)
        return cb
    }()
    
    
    @objc func backButtonPressed() {
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
        view.addSubview(separator)
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(listNameTextField)
        view.addSubview(createButton)
        
        _ = backButton.constraintAnchors(top: nil, left: separator.leftAnchor, right: nil, bottom: separator.topAnchor, topDistance: 0, leftDistance: 0, rightDistance: 0, bottomDistance: 5, height: 20, width: 50)
        _ = separator.constraintAnchors(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topDistance: 45, leftDistance: 25, rightDistance: 25, bottomDistance: 0, height: 0.5, width: nil)
        _ = titleLabel.constraintsWithDistanceTo(top: separator.bottomAnchor, left: separator.leftAnchor, right: separator.rightAnchor, bottom: nil, topDistance: 30, leftDistance: 0, rightDistance: 0, bottomDistance: 0)
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        _ = listNameTextField.constraintAnchors(top: titleLabel.bottomAnchor, left: separator.leftAnchor, right: separator.rightAnchor, bottom: nil, topDistance: 20, leftDistance: 0, rightDistance: 0, bottomDistance: 0, height: 40, width: nil)
        _ = createButton.constraintAnchors(top: nil, left: separator.leftAnchor, right: separator.rightAnchor, bottom: view.bottomAnchor, topDistance: 0, leftDistance: 0, rightDistance: 0, bottomDistance: 35, height: 40, width: nil)
        
    }

}
