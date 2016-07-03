//
//  UIViewController+.swift
//  MuseSync
//
//  Created by Fan Chen on 7/3/16.
//  Copyright © 2016 Fan Chen. All rights reserved.
//

import UIKit

extension UIViewController {

    /**
     Load view controller from storyboard of main bundle. Storyboard name and the storyboard identifier must be the same
     as the name of the view controller class.
     - Returns: view controller instance
     */
    static func loadViewControllerFromStoryboard<T: UIViewController>(type: T.Type) -> T? {
        let storyboard = UIStoryboard(name: String(T), bundle: nil)
        guard let viewController = storyboard.instantiateViewControllerWithIdentifier(String(T)) as? T else {
            print("Failed to load \(String(T)) from storyboard.")
            return nil
        }
        return viewController
    }
}