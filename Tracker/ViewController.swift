//
//  ViewController.swift
//  Tracker
//
//  Created by Marina Kolbina on 27/03/2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let view = UIView()
        view.backgroundColor = UIColor(named: "blue_YP")
        
        // Create a label
//        let label = UILabel()
//        label.text = "Яндекс Практикум бесит"
//        label.textAlignment = .center

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

