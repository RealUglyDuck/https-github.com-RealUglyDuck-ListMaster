//
//  ListCell.swift
//  ListMaster
//
//  Created by Paweł Ambrożej on 03/12/2017.
//  Copyright © 2017 Paweł Ambrożej. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {
    
    let listName = StandardUILabel()
    
    let created:StandardUILabel = {
        let label = StandardUILabel()
        label.text = "Default"
        label.textAlignment = .right
        return label
    }()
    
//    let listIconImage:UIImageView = {
//        let image = UIImageView()
//        image.contentMode = .scaleAspectFit
//        return image
//    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        listName.text = "Default"
        
        addSubview(listName)
//        addSubview(listIconImage)
        addSubview(created)
//
//        _ = listIconImage.constraintsWithDistanceTo(top: topAnchor, left: leftAnchor, right: nil, bottom: bottomAnchor, topDistance: 15, leftDistance: 15, rightDistance: 0, bottomDistance: 15)
//        listIconImage.widthAnchor.constraint(equalTo: heightAnchor).isActive = true

        _ = listName.constraintsWithDistanceTo(top: nil, left: leftAnchor, right: created.leftAnchor, bottom: nil, topDistance: 0, leftDistance: 25, rightDistance: 0, bottomDistance: 0)
        listName.centerInTheView(centerX: nil, centerY: centerYAnchor)
        
        _ = created.constraintsWithDistanceTo(top: nil, left: nil, right: rightAnchor, bottom: nil, topDistance: 0, leftDistance: 0, rightDistance: 20, bottomDistance: 0)
        created.centerInTheView(centerX: nil, centerY: centerYAnchor)
        created.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
