//
//  NewItemVC.swift
//  ListMaster
//
//  Created by Paweł Ambrożej on 19/12/2017.
//  Copyright © 2017 Paweł Ambrożej. All rights reserved.
//

import UIKit

class NewItemVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate{

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
        
        return button
        
    }()
    
    @objc func backButtonPressed() {
        
        dismissFromLeft()
        
    }
    
    lazy var titleLabel: TitleUILabel = {
        
        let textTitle = TitleUILabel()
        
        textTitle.text = "Add products"
        
        return textTitle
        
    }()
    
    let closeButtonTapView = UIView()
    
    let closeButton: UIButton = {
        
        let button = UIButton()
        
        let image = UIImage(named:"CloseIcon")
        
        button.setImage(image, for: .normal)
        
        button.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        
        return button
        
    }()
    
    @objc func closeButtonPressed() {
        
        dismiss(animated: true, completion: nil)
        
    }
    
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
        
        return label
        
    }()
    
    let amountButtonStack: UIStackView = {
        
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        
        stackView.distribution = .fillEqually
        
        stackView.spacing = 15
        
        return stackView
        
    }()
    
    let plusButton: UIImageView = {
        
        let button = UIImageView()
        
        button.contentMode = .scaleAspectFit
        
        button.image = UIImage(named: "PlusButton")
        
        button.isUserInteractionEnabled = true
        
        return button
    }()
    
    lazy var minusButton: UIImageView = {
        
        let button = UIImageView()
        
        button.contentMode = .scaleAspectFit
        
        button.image = UIImage(named: "MinusButton")
        
        button.isUserInteractionEnabled = true
        
        return button
    }()
    
    @objc func plusButtonTapped(){
        
        print("plusButtonTapped")
        
        var currentAmount = Int(amountTextField.text!)!
        
        currentAmount = currentAmount + 1
        
        amountTextField.text = String(currentAmount)
        
    }
    
    @objc func minusButtonTapped(){
        
        print("plusButtonTapped")
        
        var currentAmount = Int(amountTextField.text!)!
        
        if currentAmount != 1 {
            
            currentAmount = currentAmount - 1
            
            amountTextField.text = String(currentAmount)
            
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
                unitButtons[index].backgroundColor = MAIN_COLOR
            } else {
                unitButtons[index].backgroundColor = MAIN_COLOR.withAlphaComponent(0.5)
            }
        }
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: mainStack))! {
//        if (touch.view?.isDescendant(of: predictionTableView))! {
            return false
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
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
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
    
    @objc func addButtonPressed(sender: UIButton) {
        if itemNameTextField.text == "" {
            return
        }
        let item = Product(context: context)
        item.name = itemNameTextField.text
        item.amount = amountTextField.text
        item.isInBasket = false
        let list = getListObject(name: listName)
        item.toList = list
        item.measureUnit = "pcs"
        let selectedUnitIndex = unitsModel.getSelectedUnitIndex()
        item.measureUnit = unitsTable[selectedUnitIndex]
        ad.saveContext()
        animatePopupView()
        itemNameTextField.text = ""
        amountTextField.text = "1"
        unitsModel.chooseUnit(at: 0)
        updateUnitsView()
    }
    
    func animatePopupView() {
        addedItemPopupView.alpha = 1
        addedItemPopupView.isHidden = false
        
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
            self.addedItemPopupView.alpha = 0
        }) { (true) in
            self.addedItemPopupView.isHidden = true
        }
    }
    
    private func getListObject(name:String)->List{
        do{
            let listObject = try context.fetch(List.fetchRequest()).filter {$0.name == name}
            return listObject[0]
        } catch {
            print(error)
        }
        return List()
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
