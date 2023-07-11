//
//  SplashViewController.swift
//  Tracker
//
//  Created by Marina Kolbina on 01/04/2023.
//

import Foundation
import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let view = UIView()
        view.backgroundColor = UIColor(named: "blue_YP")
        

        // Create an image view
        let imageView = UIImageView(image: UIImage(named: "launchScreenLogo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false

        
        // Add the label to the view
        view.addSubview(imageView)
        
        // Add constraints to center the label in the view
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Set the view as the view controller's view
        self.view = view

            
    }
}
