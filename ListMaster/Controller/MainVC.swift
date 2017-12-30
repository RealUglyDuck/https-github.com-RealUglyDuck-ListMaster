//
//  ViewController.swift
//  ListMaster
//
//  Created by Paweł Ambrożej on 26/11/2017.
//  Copyright © 2017 Paweł Ambrożej. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UITableViewDelegate,UITableViewDataSource {

    let ad = UIApplication.shared.delegate as! AppDelegate
    lazy var context = ad.persistentContainer.viewContext
    
    var lists:[List]?
    
    let mainCellID = "MainCellIdentifier"
    let listCellID = "ListCellIdentifier"
    let yourListsID = "YourListsCellIdentifier"
    let cellIdentifier = "cellIdentifier"
    
    lazy var pages:[Page] = {
        var pagesArray:[Page] = []
        let pageOne = Page(title: "Create New List", description: "Press the image above to create new list or swipe to go through your lists.", imageName: "NewListImage")
        
        return pagesArray
    }()
    
    let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        return cv
    }()
    
    
    lazy var pageControl:UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = pages.count
        pc.pageIndicatorTintColor = MAIN_COLOR
        pc.currentPageIndicatorTintColor = SECONDARY_COLOR
        return pc
    }()
    
    let listsTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        registerCells()
        collectionView.delegate = self
        collectionView.dataSource = self
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
        collectionView.register(MainMenuCell.self, forCellWithReuseIdentifier: mainCellID)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(YourListsCell.self, forCellWithReuseIdentifier: yourListsID)
        listsTableView.register(ListCell.self, forCellReuseIdentifier: listCellID)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageControl.numberOfPages
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let rect = CGSize(width: view.frame.width, height: view.frame.height)
        return rect
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        
        pageControl.currentPage = pageNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCellIdentifier", for: indexPath) as! MainMenuCell
            let page = pages[indexPath.row]
            cell.mainImage.image = UIImage(named:page.imageName)
            cell.TitleUILabel.setTitle(page.title, for: .normal)
            cell.titleDescription.text = page.description
            cell.TitleUILabel.addTarget(self, action: #selector(addNewList), for: .touchUpInside)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: yourListsID, for: indexPath) as! YourListsCell
            cell.titleLabel.text = "Your Lists"
            cell.backgroundColor = .white
            cell.addSubview(listsTableView)
            _ = listsTableView.constraintsWithDistanceTo(top: cell.titleLabel.bottomAnchor, left: cell.leftAnchor, right: cell.rightAnchor, bottom: cell.bottomAnchor, topDistance: 0, leftDistance: 0, rightDistance: 0, bottomDistance: 0)
            
////            print("Lists number: \(lists?.count ?? 0)")
            return cell
        }
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
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        collectionView.constraintsTo(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)
        _ = pageControl.constraintAnchors(top: nil, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, topDistance: 0, leftDistance: 0, rightDistance: 0, bottomDistance: 0, height: 40, width: nil)
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
        if lists != nil {
            pageControl.numberOfPages = 2
        } else {
            pageControl.numberOfPages = 1
        }
        
        collectionView.reloadData()
        listsTableView.reloadData()
    }
    
}

