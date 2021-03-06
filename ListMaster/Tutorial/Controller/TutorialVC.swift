//
//  TutorialVC.swift
//  ListMaster
//
//  Created by Paweł Ambrożej on 11/03/2018.
//  Copyright © 2018 Paweł Ambrożej. All rights reserved.
//

import UIKit

class TutorialVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {

    
    var isRootViewController = true
    var pages = [Page]()
    var nextButtonConstraints = [NSLayoutConstraint]()
    var skipButtonConstraints = [NSLayoutConstraint]()
//    var carouselAccessibilityElement: CarouselAccessibilityElement?
    
    let skipButton: StandardUIButton = {
        let button = StandardUIButton()
        button.setTitle("Skip", for: .normal)
        button.contentHorizontalAlignment = .left
        let font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        let fontMetrics = UIFontMetrics(forTextStyle: .body)
        button.titleLabel?.font = fontMetrics.scaledFont(for: font!)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(skipButtonPressed), for: .touchUpInside)
        button.accessibilityElementsHidden = true
        return button
    }()
    
    @objc func skipButtonPressed() {
        if !isRootViewController {
            skipButton.isHidden = true
            nextButton.isHidden = true
            dismiss(animated: true, completion: nil)
        } else {
            let vc = MainVC()
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: true, completion: nil)
        }
        
    }
    
    let nextButton: StandardUIButton = {
        let button = StandardUIButton()
        button.setTitle("Next", for: .normal)
        button.contentHorizontalAlignment = .right
        let font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        let fontMetrics = UIFontMetrics(forTextStyle: .body)
        button.titleLabel?.font = fontMetrics.scaledFont(for: font!)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        button.accessibilityElementsHidden = true
        return button
    }()
    
    @objc func nextButtonPressed() {
        
        let pagesCount = PagesData.instance.generateData().count
        
        if pageControl.currentPage == pagesCount - 1{
            return
        } else if pageControl.currentPage == pagesCount - 2 {
            hideNextButton()
        }
        
        if pageControl.currentPage == 0 {
            nextButton.setTitleColor(MAIN_COLOR, for: .normal)
            skipButton.setTitleColor(MAIN_COLOR, for: .normal)
        }
        
        let currentPage = IndexPath(item: pageControl.currentPage+1, section: 0)
        collectionView.scrollToItem(at: currentPage, at: .centeredHorizontally, animated: true)
        self.view.setNeedsFocusUpdate()
        
        pageControl.currentPage += 1
        
        UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil)
    }
    
    func hideNextButton() {
        let topNextConstraint = getConstraintWith(identifier: "topAnchorConstraint", from: nextButtonConstraints)
        topNextConstraint?.constant = -25
        let topSkipConstraint = getConstraintWith(identifier: "topAnchorConstraint", from: skipButtonConstraints)
        topSkipConstraint?.constant = -25
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func showNextButton() {
        let topNextConstraint = getConstraintWith(identifier: "topAnchorConstraint", from: nextButtonConstraints)
        topNextConstraint?.constant = 5
        let topSkipConstraint = getConstraintWith(identifier: "topAnchorConstraint", from: skipButtonConstraints)
        topSkipConstraint?.constant = 5
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.backgroundColor = .white
        cv.accessibilityTraits = UIAccessibilityTraitAdjustable
        cv.allowsSelection = false
        cv.remembersLastFocusedIndexPath = true
        return cv
    }()

    override func accessibilityIncrement() {
        nextButtonPressed()
    }
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        let pagesCount = PagesData.instance.generateData().count
        pc.pageIndicatorTintColor = MAIN_COLOR
        pc.currentPageIndicatorTintColor = SECONDARY_COLOR
        pc.numberOfPages = pagesCount
        pc.isAccessibilityElement = false
        return pc
    }()
    
    // #MARK: ------- LIFECYCLE --------
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        generateData()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TutorialViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(GetStartedCell.self, forCellWithReuseIdentifier: "GetStartedCell")
        setupViews()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let pagesCount = PagesData.instance.generateData().count
        return pagesCount
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let cell = cell as? TutorialViewCell {
            if indexPath.item == 0 {
                cell.headerBG.isHidden = false
                cell.separator.isHidden = false
                cell.textView.isHidden = false
                cell.headerBG.image = UIImage(named: "Logo")
                cell.headerBG.backgroundColor = BACKGROUND_COLOR
            } else {
                cell.headerBG.backgroundColor = .white
                cell.headerBG.isHidden = false
                cell.separator.isHidden = false
                cell.textView.isHidden = false
                
            }
        }
        if let cell = cell as? GetStartedCell {
            cell.startButton.isHidden = false
            cell.startButton.addTarget(self, action: #selector(skipButtonPressed), for: .touchUpInside)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath[1] < PagesData.instance.generateData().count - 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TutorialViewCell
            let pages = PagesData.instance.generateData()
            cell.configureCell(page: pages[indexPath.item])
            //        cell.isAccessibilityElement = true
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GetStartedCell", for: indexPath) as! GetStartedCell
            return cell
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber
        
        let pagesCount = PagesData.instance.generateData().count
        
        if pageControl.currentPage == pagesCount-1 {
            hideNextButton()
        }
        
        if pageControl.currentPage == pagesCount-2 {
            showNextButton()
        }
        
        if pageControl.currentPage == 1 {
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.nextButton.setTitleColor(MAIN_COLOR, for: .normal)
//                self.nextButton.tintColor = MAIN_COLOR
                self.skipButton.setTitleColor(MAIN_COLOR, for: .normal)
            }, completion: nil)
        }

        if pageControl.currentPage == 0 {
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.nextButton.setTitleColor(.white, for: .normal)
                self.skipButton.setTitleColor(.white, for: .normal)
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil)
        
        
    }
    
    func setupViews() {
        view.addSubview(collectionView)
        view.addSubview(skipButton)
        view.addSubview(nextButton)
        view.addSubview(pageControl)
        
        collectionView.constraintsTo(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)
        
        skipButtonConstraints = skipButton.constraintAnchors(top: view.topAnchor, left: view.leftAnchor, right: nil, bottom: nil, topDistance: 5, leftDistance: 25, rightDistance: 0, bottomDistance: 0, height: 30, width: 100)
        
        nextButtonConstraints = nextButton.constraintAnchors(top: view.topAnchor, left: nil, right: view.rightAnchor, bottom: nil, topDistance: 5, leftDistance: 0, rightDistance: 25, bottomDistance: 0, height: 30, width: 100)
        pageControl.centerInTheView(centerX: view.centerXAnchor, centerY: nil)
        pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
    }
    
}
//
//class CarouselAccessibilityElement: UIAccessibilityElement {
//
//    var currentPage: Page?
//
//    init(accessibilityContainer container: Any, page: Page?) {
//        super.init(accessibilityContainer: container)
//        currentPage = page
//
//    }
//
//    override var accessibilityLabel: String? {
//        get {
//            return "Tutorial Page"
//        }
//        set {}
//    }
//
//    override var accessibilityValue: String? {
//        get {
//            if let title = currentPage?.title, let description = currentPage?.description {
//                return title + description
//            } else {
//                return super.accessibilityValue
//            }
//
//        }
//        set {}
//    }
//
//    override var accessibilityTraits: UIAccessibilityTraits {
//        get {
//            return UIAccessibilityTraits.adjustable
//        }
//        set {
//
//        }
//    }
//}
