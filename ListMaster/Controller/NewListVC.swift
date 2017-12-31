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
    
    let titleBG:UIView = {
        let background = UIView()
        background.backgroundColor = MAIN_COLOR
        return background
    }()
    
    let backButton:StandardUIButton = {
        let button = StandardUIButton()
        button.setTitle("Back", for: .normal)
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let titleLabel: StandardUILabel = {
        let textTitle = StandardUILabel()
        textTitle.text = "Create list"
        textTitle.textColor = .white
        textTitle.font = UIFont(name: "HelveticaNeue-Medium", size: 24)
        textTitle.textAlignment = .center
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
        view.addSubview(titleBG)
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(listNameTextField)
        view.addSubview(createButton)

        _ = titleBG.constraintAnchors(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topDistance: 0, leftDistance: 0, rightDistance: 0, bottomDistance: 0, height: 60, width: nil)
        _ = backButton.constraintAnchors(top: titleBG.topAnchor, left: titleBG.leftAnchor, right: nil, bottom: titleBG.bottomAnchor, topDistance: 0, leftDistance: 25, rightDistance: 0, bottomDistance: 0, height: nil, width: 50)
        _ = listNameTextField.constraintAnchors(top: titleBG.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topDistance: 20, leftDistance: 25, rightDistance: 25, bottomDistance: 0, height: 40, width: nil)
        _ = createButton.constraintAnchors(top: nil, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, topDistance: 0, leftDistance: 25, rightDistance: 25, bottomDistance: 35, height: 40, width: nil)

        titleLabel.centerInTheView(centerX: titleBG.centerXAnchor, centerY: titleBG.centerYAnchor)
        
    }

}
