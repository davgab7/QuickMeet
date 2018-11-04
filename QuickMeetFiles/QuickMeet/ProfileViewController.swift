//
//  ProfileViewController.swift
//  QuickMeet
//
//  Created by David Gabrielyan on 3/11/18.
//  Copyright © 2018 Gabe Wilson. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var mediaItems = ["Phone","Email", "Facebook", "Snapchat", "Instagram"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ChooseMediaCell
        cell.mediaNameLabel.text = mediaItems[indexPath.row]
        cell.mediaImageView.image = UIImage(named: mediaItems[indexPath.row])
        cell.mediaSwitch.isOn = false
        cell.mediaSwitch.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    
    @IBOutlet weak var tableView: SelfSizedTableView!
    
    @IBOutlet weak var defaultPicOutlet: UIButton!
    @IBOutlet weak var usernameOutlet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.reloadData()
        defaultPicOutlet.layer.cornerRadius = defaultPicOutlet.frame.size.width / 2
        defaultPicOutlet.clipsToBounds = true
        defaultPicOutlet.layer.borderColor = UIColor.black.cgColor
        defaultPicOutlet.layer.borderWidth = 2
        defaultPicOutlet.imageView?.contentMode = .scaleAspectFill
        tableView.maxHeight = 372
        queryUser()
    }
    
    func queryUser() {
        usernameOutlet.text = PFUser.current()?.username

        
    }
    

    @IBAction func defaultPicAction(_ sender: Any) {
        print("lol")
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
