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
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func nextAction(_ sender: Any) {
        self.performSegue(withIdentifier: "showEnterInfo", sender: nil)
    }
    
    var chosenMediaItems = [String]()
    var mediaItems = ["Phone","Email", "Facebook", "Snapchat", "Instagram"]
    
    override func viewDidLoad() {
        setupUI()
    }
    
    func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ChooseMediaCell
        cell.mediaNameLabel.text = mediaItems[indexPath.row]
        cell.mediaImageView.image = UIImage(named: mediaItems[indexPath.row])
        cell.mediaSwitch.isOn = false
        cell.mediaSwitch.tag = indexPath.row
        cell.mediaSwitch.addTarget(self, action: #selector(ChooseMediaVC.onSwitchValueChanged), for: .touchUpInside)
        return cell
    }
    
    @objc func onSwitchValueChanged(_ mediaSwitch: UISwitch) {
        if mediaSwitch.isOn {
            chosenMediaItems.append(mediaItems[mediaSwitch.tag])
            print("added ", mediaItems[mediaSwitch.tag])
        } else {
            chosenMediaItems.remove(at: chosenMediaItems.firstIndex(of: mediaItems[mediaSwitch.tag])!)
            print("removed", mediaItems[mediaSwitch.tag])
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let targetVC = segue.destination as! EnterInfoVC
        if segue.identifier == "showEnterInfo" {
            targetVC.chosenItems = self.chosenMediaItems
        }
    }
    
    
    
}
