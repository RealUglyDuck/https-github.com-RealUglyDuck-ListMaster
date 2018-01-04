//
//  LogoScreenVC.swift
//  ListMaster
//
//  Created by Paweł Ambrożej on 30/12/2017.
//  Copyright © 2017 Paweł Ambrożej. All rights reserved.
//

import UIKit

class LogoScreenVC: UIViewController {
    
    let logo:UIImageView = {
        let screen = UIView()
        let image = UIImageView()
        screen.backgroundColor = MAIN_COLOR
        screen.addSubview(image)
        image.image = UIImage(named: "AppIcon")
        image.centerInTheView(centerX: screen.centerXAnchor, centerY: screen.centerYAnchor)
        image.setPropertyOf(width: 100, height: 74)
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGradient()
        view.addSubview(logo)
        
        
        
        logo.centerInTheView(centerX: view.centerXAnchor, centerY: view.centerYAnchor)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.performSegue(withIdentifier: "ShowMainVC", sender: nil)
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
