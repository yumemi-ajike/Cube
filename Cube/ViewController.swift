//
//  ViewController.swift
//  Cube
//
//  Created by 寺家 篤史 on 2020/11/13.
//  Copyright © 2020 Atsushi Jike. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let cubeView = CubeView()
    let groundView = GroundView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        groundView.translatesAutoresizingMaskIntoConstraints = false
        cubeView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(groundView)
        view.addSubview(cubeView)
        
        NSLayoutConstraint.activate([
            groundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            groundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            groundView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            groundView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        NSLayoutConstraint.activate([
            cubeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            cubeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            cubeView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            cubeView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }


}

