//
//  NewListVC.swift
//  ListMaster
//
//  Created by Paweł Ambrożej on 27/11/2017.
//  Copyright © 2017 Paweł Ambrożej. All rights reserved.
//

import UIKit
import CoreData

class NewListVC: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {

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
        button.accessibilityTraits = UIAccessibilityTraits.button
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
        print("Background tapped")
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
        tap.delegate = self
        closeButtonTapView.addGestureRecognizer(tap)
        listNameTextField.becomeFirstResponder()
        listNameTextField.delegate = self
//        let tapBackground = UIGestureRecognizer(target: self, action: #selector(closeButtonPressed))
        view.addGestureRecognizer(tap)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        listNameTextField.resignFirstResponder()
        return true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    
        if touch.view!.isDescendant(of: backgroundView) {
            
            return false
            
        } else {
            
            return true
            
        }
    }

}
