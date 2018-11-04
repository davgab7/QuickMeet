//
//  ChooseMediaVC.swift
//  QuickMeet
//
//  Created by Gabe Wilson on 11/3/18.
//  Copyright © 2018 Gabe Wilson. All rights reserved.
//

import Foundation
import UIKit

class ChooseMediaVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var mediaItems = ["Email", ""]
    
    override func viewDidLoad() {
        setupUI()
    }
    
    func setupUI() {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ChooseMediaVC
        
    }
    
    
    
    
}
