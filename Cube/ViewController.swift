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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cubeView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cubeView)

        NSLayoutConstraint.activate([
            cubeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            cubeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            cubeView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            cubeView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}
