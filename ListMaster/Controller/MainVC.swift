//
//  ViewController.swift
//  ListMaster
//
//  Created by Paweł Ambrożej on 26/11/2017.
//  Copyright © 2017 Paweł Ambrożej. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate,UITableViewDataSource {

    let ad = UIApplication.shared.delegate as! AppDelegate
    lazy var context = ad.persistentContainer.viewContext
    
    var lists:[List]?
    let listCellID = "ListCellIdentifier"

    lazy var pages:[Page] = {
        var pagesArray:[Page] = []
        let pageOne = Page(title: "Create New List", description: "Press the image above to create new list or swipe to go through your lists.", imageName: "NewListImage")
        return pagesArray
    }()
    
    let listsTableView = UITableView()
    
    let titleBG:UIView = {
        let background = UIView()
        background.backgroundColor = MAIN_COLOR
        return background
    }()
    
    
    let addItemButton: UIButton  = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        let backgroundImage = UIImage(named: "AddIcon")
        button.setImage(backgroundImage, for: .normal)
        button.addTarget(self, action: #selector(addNewItem), for: .touchUpInside)
        //        button.target(forAction: #selector(addNewItem), withSender: self)
        return button
    }()
    
    lazy var titleLabel: StandardUILabel = {
        let textTitle = StandardUILabel()
        textTitle.textColor = .white
        textTitle.font = UIFont(name: "HelveticaNeue-Medium", size: 24)
        textTitle.textAlignment = .center
        textTitle.text = "List Master"
        return textTitle
    }()
    
    @objc func addNewItem() {
        performSegue(withIdentifier: "AddNewList", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        registerCells()
        listsTableView.delegate = self
        listsTableView.dataSource = self
        listsTableView.separatorInset = UIEdgeInsets.zero
        getLists()
//        clearLists()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getLists()
        reloadData()
    }
    
    func registerCells() {
        listsTableView.register(ListCell.self, forCellReuseIdentifier: listCellID)
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        tableView.separatorColor = MAIN_COLOR
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(lists?.count ?? 0)
        return lists?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = createTableHeaderView()
        let header = TableHeaderView(leftTitle: "Name", rightTitle: "Created")
        let width = tableView.bounds.width
        header.setPropertyOf(width: width, height: 30)
        return header
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowSelectedListSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "ShowSelectedListSegue" {
                if let targetVC = segue.destination as? SelectedListVC {
                    let index = listsTableView.indexPathForSelectedRow
                    guard let cell = listsTableView.cellForRow(at: index!) as? ListCell else {
                        return
                    }
                    targetVC.listName = cell.listName.text!
                }
            }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("reaload Data")
        let cell = tableView.dequeueReusableCell(withIdentifier: listCellID, for: indexPath) as! ListCell
        
        if let listArray = lists {
            cell.listName.text = listArray[indexPath.row].name
//            cell.listIconImage.image = UIImage(named:"BasketImage")
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.init(identifier: "en_GB")
            dateFormatter.setLocalizedDateFormatFromTemplate("dd/MM/yyyy")
            if let creationDate = listArray[indexPath.row].created {
               
                cell.created.text = dateFormatter.string(from: creationDate)
            }
        }
        return cell
    }
    
    @objc func addNewList() {
        performSegue(withIdentifier: "AddNewList", sender: nil)
    }
    
    func setupLayout() {
        view.addSubview(listsTableView)
        view.addSubview(titleBG)
        view.addSubview(titleLabel)
        view.addSubview(addItemButton)

        
        _ = titleBG.constraintAnchors(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topDistance: 0, leftDistance: 0, rightDistance: 0, bottomDistance: 0, height: 60, width: nil)
        addItemButton.translatesAutoresizingMaskIntoConstraints = false
        addItemButton.setPropertyOf(width: 22, height: 22)
        addItemButton.centerYAnchor.constraint(equalTo: titleBG.centerYAnchor).isActive = true
        addItemButton.rightAnchor.constraint(equalTo: titleBG.rightAnchor, constant: -25).isActive = true
        titleLabel.centerInTheView(centerX: titleBG.centerXAnchor, centerY: titleBG.centerYAnchor)
        view.backgroundColor = .white
        listsTableView.constraintsTo(top: titleBG.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)

    
    }
    
    func getLists() {
        
        let request:NSFetchRequest<List> = List.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            let listTable = try context.fetch(request)
            self.lists = listTable
        } catch {
            fatalError("\(error)")
        }
    }
    
    func clearLists() {
        if let listArray = lists {
            for list in listArray {
                context.delete(list)
                ad.saveContext()
            }
        }
    }
    
    func reloadData() {
        let pageOne = Page(title: "Create New List", description: "Press the image above to create new list or swipe to go through your lists.", imageName: "NewListImage")
        pages = []
        pages.append(pageOne)
        if let listArray = lists {
            for list in listArray {
                print("page added")
                let page = Page(title: list.name!, description: "", imageName: "BasketImage")
                pages.append(page)
            }
        }
        
        listsTableView.reloadData()
    }
    
}

