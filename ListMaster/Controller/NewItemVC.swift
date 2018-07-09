//
//  NewItemVC.swift
//  ListMaster
//
//  Created by Paweł Ambrożej on 19/12/2017.
//  Copyright © 2017 Paweł Ambrożej. All rights reserved.
//

import UIKit
import CoreData

protocol ListItemEditDelegate {
    func userFinishedEditingItem(at indexPath: IndexPath)
}

class NewItemVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate{

    var productToEdit:Product?
    
    var indexPath:IndexPath?
    
    var delegate: ListItemEditDelegate?
    
    var listName = ""
    
    var addButtonConstraints: [NSLayoutConstraint]? = nil
    
    var predictionData: [String] = []
    
    var predictionDataFiltered: [String] = []
    
    let rowHeight: Double = 40
    
    var predictionHeightConstraint:NSLayoutConstraint?
    
    var unitsTable = ["pcs","kg","g","l"]
    
    var unitButtons = [UnitOptionView]()
    
    lazy var unitsModel = UnitsModel(numberOfUnits: unitsTable.count)
    
    let ad = UIApplication.shared.delegate as! AppDelegate
    
    lazy var context = ad.persistentContainer.viewContext
    
    let titleBG:UIView = {
        
        let background = UIView()
        
        background.backgroundColor = BACKGROUND_COLOR
        
        background.layer.shadowColor = UIColor.black.cgColor
        
        background.layer.shadowOpacity = 0.5
        
        background.layer.shadowOffset = CGSize.zero
        
        background.layer.shadowRadius = 10
        
        return background
        
    }()
    
    let backButtonTapView = UIView()
    
    let backButton:StandardUIButton = {
        
        let button = StandardUIButton()
        
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        let image = UIImage(named: "BackButton")
        
        button.setBackgroundImage(image, for: .normal)
        
        button.accessibilityLabel = "Back to list"
        
        button.accessibilityTraits = UIAccessibilityTraits.button
        
        return button
        
    }()
    
    @objc func backButtonPressed() {
        let slideTransition = SlideTransition()
        slideTransition.transitionMode = .Dismiss
        self.transitioningDelegate = slideTransition
        dismissKeyboard()
        dismiss(animated: true, completion: nil)
    }
    
    lazy var titleLabel: TitleUILabel = {
        
        let textTitle = TitleUILabel()
        
        textTitle.text = "Add products"
        
        return textTitle
        
    }()
    
    let mainStack: UIStackView = {
        
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        
        stackView.distribution = .equalSpacing
        
        stackView.spacing = 20
        
        return stackView
        
    }()
    
    let itemNameTextField: NewTextField = {
        
        let textField = NewTextField()
        
        textField.placeholder = "List name..."
        
        textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        return textField
        
    }()
    
    let amountStackView: UIStackView = {
        
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        
        stackView.distribution = .fillEqually
        
        stackView.spacing = 15
        
//        stackView.spacing =
        return stackView
        
    }()
    
    let amountLabel: StandardUILabel = {
        
        let label = StandardUILabel()
        
        label.text = "Amount:"
        
        label.textAlignment = .right
        
        label.isAccessibilityElement = false
        
        return label
        
    }()
    
    let amountButtonStack: UIStackView = {
        
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        
        stackView.distribution = .fillEqually
        
        stackView.spacing = 15
        
        return stackView
        
    }()
    
    lazy var plusButton: UIImageView = {
        
        let button = UIImageView()
        
        button.contentMode = .scaleAspectFit
        
        button.image = UIImage(named: "PlusButton")
        
        button.isUserInteractionEnabled = true
        
        button.isAccessibilityElement = true

        button.accessibilityTraits = UIAccessibilityTraits.button
        
        button.accessibilityTraits = UIAccessibilityTraits.updatesFrequently
        
        button.accessibilityLabel = "Tap to increase amount. Current amount \(amountTextField.text ?? "")"
        
        return button
    }()
    
    lazy var minusButton: UIImageView = {
        
        let button = UIImageView()
        
        button.contentMode = .scaleAspectFit
        
        button.image = UIImage(named: "MinusButton")
        
        button.isUserInteractionEnabled = true
        
        button.isAccessibilityElement = true
        
        button.accessibilityTraits = UIAccessibilityTraits.button
        
        button.accessibilityTraits = UIAccessibilityTraits.updatesFrequently
        
        button.accessibilityLabel = "Tap to decrease amount. Current amount \(amountTextField.text ?? "")"
        
        return button
    }()
    
    @objc func plusButtonTapped(){
        
        print("plusButtonTapped")
        
        var currentAmount = Int(amountTextField.text!)!
        
        currentAmount = currentAmount + 1
        
        amountTextField.text = String(currentAmount)
        
        plusButton.accessibilityLabel = "Tap to increase amount. Current amount \(currentAmount)"
        minusButton.accessibilityLabel = "Tap to decrease amount. Current amount \(currentAmount)"
        
    }
    
    @objc func minusButtonTapped(){
        
        print("plusButtonTapped")
        
        var currentAmount = Int(amountTextField.text!)!
        
        if currentAmount != 1 {
            
            currentAmount = currentAmount - 1
            
            amountTextField.text = String(currentAmount)
            
            plusButton.accessibilityLabel = "Tap to increase amount. Current amount \(currentAmount)"
            minusButton.accessibilityLabel = "Tap to decrease amount. Current amount \(currentAmount)"
            
        }
        
    }
    
    let amountTextField: NewTextField = {
        
        let textField = NewTextField()
        textField.text = "1"
        textField.keyboardType = UIKeyboardType.numberPad
        textField.textAlignment = .right
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        textField.rightView = paddingView
        textField.rightViewMode = .always
        textField.isAccessibilityElement = true
        
        return textField
    }()
    
    let segmentsStackView:UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        return stackView
    }()
    

    
    @objc func segmentPressed(sender:UISegmentedControl) {

    }
    
    let addedItemPopupView: UIView = {
        let popupView = UIView()
        let label = TitleUILabel()
        label.text = "Product added"
        label.textColor = .white
        popupView.backgroundColor = MAIN_COLOR
        popupView.addSubview(label)
        popupView.layer.cornerRadius = 20
        
        label.centerInTheView(centerX: popupView.centerXAnchor, centerY: popupView.centerYAnchor)
        return popupView
    }()
    
    let addButton: FilledUIButton = {
        let button = FilledUIButton()
        button.setTitle("Add", for: .normal)
        button.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        return button
    }()

    
    let predictionTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUnitButtons()
        setupLayout()
        setupPredictionTableView()
        addGestureRecognizers()
        handleKeyboard()
        itemNameTextField.delegate = self
        itemNameTextField.becomeFirstResponder()
        amountTextField.accessibilityLabel = "Amount set to \(amountTextField.text ?? "")"
        
        if productToEdit != nil {
            setupEditView()
            addButton.setTitle("Save", for: .normal)
        }
        
    }
    
    func setupPredictionTableView() {
        predictionTableView.isHidden = true
        predictionTableView.delegate = self
        predictionTableView.dataSource = self
        predictionTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        loadPredictionDataFromCSV()
        predictionTableView.reloadData()
    }
    
    func handleKeyboard() {
        let hideKeyboardTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        hideKeyboardTap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(hideKeyboardTap)
        hideKeyboardTap.delegate = self
    }
    
    func addGestureRecognizers() {
        let plusTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(plusButtonTapped))
        let minusTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(minusButtonTapped))
        let backButtonTap = UITapGestureRecognizer(target: self, action: #selector(backButtonPressed))
        plusButton.addGestureRecognizer(plusTapRecognizer)
        minusButton.addGestureRecognizer(minusTapRecognizer)
        backButtonTapView.addGestureRecognizer(backButtonTap)
    }
    
    func prepareUnitButtons() {
        for unitLabel in unitsTable {
            let unit = UnitOptionView()
            let tap = UITapGestureRecognizer(target: self, action: #selector(measureUnitSelected(sender:)))
            tap.name = unitLabel
            unit.addGestureRecognizer(tap)
            unit.optionName.text = unitLabel
            unitButtons.append(unit)
        }
        unitsModel.chooseUnit(at: 0)
        updateUnitsView()
    }
    
    @objc func measureUnitSelected(sender: UITapGestureRecognizer){
        if let buttonName = sender.name {
            for index in unitsTable.indices {
                if unitsTable[index] == buttonName {
                    unitsModel.chooseUnit(at: index)
                    updateUnitsView()
                }
            }
            
        }
    }
    
    func updateUnitsView() {
        let choosedIndex = unitsModel.getSelectedUnitIndex()
        for index in unitButtons.indices {
            if index == choosedIndex {
                unitButtons[index].accessibilityLabel = "Measure unit \(unitButtons[index].optionName.text ?? "") is selected"
                unitButtons[index].backgroundColor = MAIN_COLOR
            } else {
                unitButtons[index].accessibilityLabel = "Measure unit \(unitButtons[index].optionName.text ?? "") is not selected"
                unitButtons[index].backgroundColor = MAIN_COLOR.withAlphaComponent(0.5)
            }
        }
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: predictionTableView))! {
            return false
//        } else if (touch.view?.isDescendant(of: mainStack))! {
//            return false
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return predictionDataFiltered.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("DidSelectRow")
        self.itemNameTextField.text = predictionTableView.cellForRow(at: indexPath)?.textLabel?.text
        predictionTableView.isHidden = true
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = predictionTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = predictionDataFiltered[indexPath.row]
        cell.backgroundColor = .white
        cell.textLabel?.textColor = .black
        cell.isAccessibilityElement = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(rowHeight)
    }
    
    @objc func textFieldChanged(){
        if itemNameTextField.text == nil || itemNameTextField.text == "" {
            predictionTableView.isHidden = true
            
        } else {
            
            let capitalized = itemNameTextField.text!.capitalized
            print(capitalized)
            predictionDataFiltered = predictionData.filter({$0.range(of: capitalized) != nil  })
            predictionTableView.reloadData()
            if predictionTableView.numberOfRows(inSection: 0) == 0 {
                predictionTableView.isHidden = true
            } else {
                let rows = Double(predictionTableView.numberOfRows(inSection: 0))
                predictionHeightConstraint?.constant = CGFloat(rowHeight * rows)
                predictionTableView.isHidden = false
            }
            
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        predictionTableView.isHidden = true
    }
    
    func setupEditView() {
        itemNameTextField.text = productToEdit?.name
        amountTextField.text = productToEdit?.amount
        for index in unitsTable.indices {
            if unitsTable[index] == productToEdit?.measureUnit {
                unitsModel.chooseUnit(at: index)
                updateUnitsView()
            }
        }
        
    }
    
    @objc func addButtonPressed(sender: UIButton) {
        if itemNameTextField.text == "" {
            return
        }
        
        if productToEdit != nil && indexPath != nil && delegate != nil {
            let product = Product(context: context)
            configure(product: product)
//            let cell = ItemCell()
//            cell.name.text = itemNameTextField.text
//            cell.amount.text = amountTextField.text
//            cell.measureUnit.text = "pcs"
//            let selectedUnitIndex = unitsModel.getSelectedUnitIndex()
//            cell.measureUnit.text = unitsTable[selectedUnitIndex]
            delegate?.userFinishedEditingItem(at: indexPath!)
            print("Cell sended to list")
            backButtonPressed()
            return
        }
        
        let product = Product(context: context)
        configure(product:product)
        ad.saveContext()
        animatePopupView()
        resetView()
    }
    
    func configure(product:Product) {
        product.isInBasket = false
        product.name = itemNameTextField.text
        product.amount = amountTextField.text
        guard let lists = getListObject(name: listName,objectType: List()) else {return}
        for list in lists {
            if list.name == listName {
                product.toList = list
            }
        }
        product.measureUnit = "pcs"
        let selectedUnitIndex = unitsModel.getSelectedUnitIndex()
        product.measureUnit = unitsTable[selectedUnitIndex]
        if let oldProduct = productToEdit {
            product.isInBasket = oldProduct.isInBasket
        }
    }
    
    func resetView() {
        itemNameTextField.text = ""
        amountTextField.text = "1"
        unitsModel.chooseUnit(at: 0)
        updateUnitsView()
        predictionTableView.isHidden = true
        itemNameTextField.becomeFirstResponder()
    }
    
    func animatePopupView() {
        addedItemPopupView.alpha = 1
        addedItemPopupView.isHidden = false
        
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
            self.addedItemPopupView.alpha = 0
        }) { (true) in
            self.addedItemPopupView.isHidden = true
        }
        
        UIAccessibility.post(notification: UIAccessibility.Notification.announcement, argument: NSLocalizedString("Product added", comment: ""))
    }
    
    private func getListObject<T:NSManagedObject>(name:String, objectType: T)->[T]?{
        
        if let fetchRequest = T.fetchRequest() as? NSFetchRequest<T> {
            do{
                let listObject = try context.fetch(fetchRequest)
                return listObject
            } catch {
                print(error)
            }
        }
        
        return [objectType]
    }
    
    func loadPredictionDataFromCSV() {
        guard let filePath = Bundle.main.path(forResource: "GroceryList", ofType: "csv") else {
            return
        }
        do {
            let data = try String(contentsOfFile: filePath, encoding: .utf8)
            let rows = data.components(separatedBy: "\n")
            for row in rows {
                self.predictionData.append(row)
            }
        } catch {
            print(error)
        }
    }
}
