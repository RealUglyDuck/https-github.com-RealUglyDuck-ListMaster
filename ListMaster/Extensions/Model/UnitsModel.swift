//
//  UnitsModel.swift
//  ListMaster
//
//  Created by Paweł Ambrożej on 20/02/2018.
//  Copyright © 2018 Paweł Ambrożej. All rights reserved.
//

import Foundation

//: Playground - noun: a place where people can play

class UnitsModel {
    var units = [Unit]()
    
    func chooseUnit(at index:Int){
        
        for unitNumber in units.indices {
            
            if unitNumber == index {
                
                units[unitNumber].isSelected = true
                
            } else {
                
                units[unitNumber].isSelected = false
                
            }
        }
    }
    
    func getSelectedUnitIndex() -> Int {
        for unit in units {
            if unit.isSelected {
                return unit.identifier
            }
        }
        return 0
    }
    
    init(numberOfUnits:Int){
        
        for identifier in 0..<numberOfUnits {
            
            let unit = Unit(identifier: identifier)
            
            units.append(unit)
            
        }
    }
    
}

struct Unit {
    
    var identifier: Int
    
    var isSelected = false
    
    init(identifier:Int){
        
        self.identifier = identifier
        
    }
}


