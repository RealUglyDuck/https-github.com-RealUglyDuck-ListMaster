//
//  ViewController.swift
//  ListMaster
//
//  Created by Paweł Ambrożej on 26/11/2017.
//  Copyright © 2017 Paweł Ambrożej. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate,UITableViewDataSource, NSFetchedResultsControllerDelegate {

    let ad = UIApplication.shared.delegate as! AppDelegate
    lazy var context = ad.persistentContainer.viewContext
    
    var lists:[List]?
    let listCellID = "ListCellIdentifier"
    var topViewConstraints: [NSLayoutConstraint] = []
    var topViewBottomConstraint:NSLayoutConstraint?
    
    let listsTableView = UITableView()
    
    let infoTapView : UIButton = {
        let button = UIButton()
        button.isAccessibilityElement = true
        button.accessibilityTraits = UIAccessibilityTraitButton
        button.accessibilityLabel = "Instruction how to use Trolleyst"
        return button
    }()
    
    let infoButton:UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "InfoIcon")
        icon.isAccessibilityElement = false
        return icon
    }()
    
    @objc func infoButtonPressed() {
        
        let tutorialVC = TutorialVC()
        tutorialVC.isRootViewController = false
        present(tutorialVC, animated: true, completion: nil)
    }
    
    let logo:UIImageView = {
        let screen = UIView()
        let image = UIImageView()
        screen.backgroundColor = MAIN_COLOR
        screen.addSubview(image)
        image.image = UIImage(named: "Logo")
        image.centerInTheView(centerX: screen.centerXAnchor, centerY: screen.centerYAnchor)
        image.setPropertyOf(width: 100, height: 74)
        return image
    }()
    
    let topView:UIView = {
        let tv = UIView()
        tv.backgroundColor = BACKGROUND_COLOR
        return tv
    }()
    
    lazy var bottomView:UIView = {
        let bv = UIView()
        bv.backgroundColor = .clear
        bv.layer.shadowColor = UIColor.black.cgColor
        bv.layer.shadowOpacity = 0.5
        bv.layer.shadowOffset = CGSize(width: 10, height: 10)
        bv.layer.shadowRadius = 10
        return bv
    }()
    
    let titleBG:UIView = {
        let background = UIView()
        background.backgroundColor = .clear
        return background
    }()
    
    
    let addItemButton: UIButton  = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        let backgroundImage = UIImage(named: "AddButton")
        button.setImage(backgroundImage, for: .normal)
        button.addTarget(self, action: #selector(addNewItemPressed), for: .touchUpInside)
        button.accessibilityLabel = "Add new list"
        button.accessibilityTraits = UIAccessibilityTraitButton
        //        button.target(forAction: #selector(addNewItem), withSender: self)
        return button
    }()
    
    lazy var titleLabel: TitleUILabel = {
        let textTitle = TitleUILabel()
        textTitle.text = "Your Lists"
        textTitle.textColor = MAIN_COLOR
        return textTitle
    }()
    
    @objc func addNewItemPressed() {
        let vc = NewListVC()
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
        
    }
    
    let emptyListsView = EmptyListView(firstString: "You don't have any lists. \n Press ", imageName: "AddButton", secondString: " button to create new list.")
    
    lazy var controller:NSFetchedResultsController<List> = {
        
        let request: NSFetchRequest<List> = List.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        let fetchController: NSFetchedResultsController<List> = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchController.performFetch()
        } catch let error{
            print(error)
            
        }
        listsTableView.reloadData()
        return fetchController
    }()
    
    let dismissSlideTransition = SlideTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controller.delegate = self
        setupLayout()
        registerCells()
        listsTableView.delegate = self
        listsTableView.dataSource = self
        listsTableView.separatorInset = UIEdgeInsets.zero
        view.clipsToBounds = true
        infoTapView.addTarget(self, action: #selector(infoButtonPressed), for: .touchUpInside)
        let newProductTap = UITapGestureRecognizer(target: self, action: #selector(addNewItemPressed))
        emptyListsView.addGestureRecognizer(newProductTap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkIfListIsEmpty()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        
            UIView.animate(withDuration: 0.5, animations: {
                let height = self.view.bounds.height/2
                self.topViewBottomConstraint?.constant = -height+50
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        listsTableView.reloadData()
        
    }
    
    func registerCells() {
        listsTableView.register(ListCell.self, forCellReuseIdentifier: listCellID)
    }
    
    func checkIfListIsEmpty() {
        if listsTableView.visibleCells.count == 0 {
            emptyListsView.isHidden = false
        } else {
            emptyListsView.isHidden = true
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = controller.sections else {
            listsTableView.isHidden = true
            return 0
        }
        listsTableView.isHidden = false
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        tableView.separatorColor = .clear
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = controller.sections else {
            return 0
        }
        
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UITableViewHeaderFooterView()
        let header = TableHeaderView(leftTitle: "Name", rightTitle: "Created")
        headerView.addSubview(header)
        header.constraintsTo(top: headerView.topAnchor, left: headerView.leftAnchor, right: headerView.rightAnchor, bottom: headerView.bottomAnchor)
        let head = UIView()
        head.backgroundColor = .red
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.backgroundView?.backgroundColor = BACKGROUND_COLOR
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    let slideTransition = SlideTransition()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedVC = ShoppingListVC()
        let cell = listsTableView.cellForRow(at: indexPath) as! ListCell
        selectedVC.listName = cell.listName.text!
        slideTransition.transitionMode = .Present
        selectedVC.transitioningDelegate = slideTransition
        present(selectedVC, animated: true, completion: nil)
//        presentFromRight(viewControllerToPresent: selectedVC)
        
    }
    
    func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: .destructive, title: "Delete", handler: {(rowAction,indexPath) in
            let object = self.controller.object(at: indexPath)
            self.context.delete(object)
            self.ad.saveContext()
        })
        return [action]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: listCellID, for: indexPath) as! ListCell
        
        let list = self.controller.object(at: indexPath)
        
        cell.configureCell(object: list)
        cell.selectionStyle = .none
        
        
        return cell
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        listsTableView.beginUpdates()
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type) {
        case .delete :
            listsTableView.deleteRows(at: [indexPath!], with: .top)
            break
        case .insert:
            if let indexPath = newIndexPath{
                listsTableView.insertRows(at: [indexPath], with: .fade)
            }
            break
            
        case .move:
            listsTableView.moveRow(at: indexPath!, to: newIndexPath!)
            break
        case .update:
            listsTableView.reloadRows(at: [indexPath!], with: .fade)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        listsTableView.endUpdates()
        checkIfListIsEmpty()
    }

    
    func clearLists() {
        if let listArray = lists {
            for list in listArray {
                context.delete(list)
                ad.saveContext()
            }
        }
    }
    



}
