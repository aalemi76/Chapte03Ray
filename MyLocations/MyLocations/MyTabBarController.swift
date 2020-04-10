//
//  MyTabBarController.swift
//  MyLocations
//
//  Created by Catalina on 4/2/20.
//  Copyright © 2020 Deep Minds. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return nil
    }
}
