//
//  PagesData.swift
//  ListMaster
//
//  Created by Paweł Ambrożej on 19/08/2018.
//  Copyright © 2018 Paweł Ambrożej. All rights reserved.
//

import Foundation

class PagesData {
    
    static public var instance = PagesData()
    
    private var pages = [
        Page(title: "Thank you for choosing Trolleyst", description: "Please take this quick survey to learn how to use our app.", imageName: ""),
        Page(title: "Manage your Lists", description: "Press \"+\" button to create new List.\nClick on the list name to open the list", imageName: "TutorImage1"),
        Page(title: "Manage your Products", description: "Tap the product name to move it to basket.\nSwipe left to remove product from the list", imageName: "TutorialImage2"),
        Page(title: "Add products to your lists", description: "To add new product: write the name, choose the amount and measure unit", imageName: "TutorialImage3"),
        Page(title: "", description: "", imageName: "")
    ]
    
    
    func generateData() -> [Page] {
        var pagesData = [Page]()
        for page in pages {
            pagesData.append(page)
        }
        return pagesData
    }
    
}
