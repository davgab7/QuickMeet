//
//  SecondViewController.swift
//  QuickMeet
//
//  Created by Gabe Wilson on 11/3/18.
//  Copyright © 2018 Gabe Wilson. All rights reserved.
//

import UIKit
import Parse

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet var searchTableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var userArray : [User] = []
    var currentUserArray : [User] = []
    var selectedUser = User()
    var dataDict = ["phone":"", "email": "", "facebook": "", "snapchat": "", "instagram": ""]
    var unwinded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.dataSource = self
        searchTableView.delegate = self
        getUsers()
        setUpSearchBar()
        alterLayout()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedUser = userArray[indexPath.row]
        self.performSegue(withIdentifier: "showSendScreen", sender: nil)
    }
    
    func queryUserData() {
        let query = PFQuery(className: "_User")
        query.getObjectInBackground(withId: (PFUser.current()?.objectId)!) { (object, error) in
            let user = object as! PFUser
            for key in self.dataDict.keys {
                self.dataDict[key] = user[key] as? String
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUserArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")  as! tableViewCell
        
        cell.personName.text = currentUserArray[indexPath.row].username
        cell.personImage.image = currentUserArray[indexPath.row].image
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return searchBar
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentUserArray = userArray
            self.searchTableView.reloadData()
            return
        }
        print(searchText)
        print(currentUserArray.count)
        currentUserArray = userArray.filter({ User -> Bool in User.username.lowercased().contains(searchText.lowercased())})
        self.searchTableView.reloadData()
    }
    
    private func setUpSearchBar() {
        searchBar.delegate = self
    }
    
    func alterLayout() {
        searchTableView.tableHeaderView = UIView()
        searchTableView.estimatedSectionHeaderHeight = 50
    }
    
    func getUsers() {
        let query = PFQuery(className: "_User")
        query.findObjectsInBackground {
            (objects:[PFObject]?, error:Error?) -> Void in
            if let error = error {
                print("Error: " + error.localizedDescription)
            } else {
                if objects?.count == 0 || objects?.count == nil {
                    return
                } else {
                    for object in objects! {
                        let pfUser = object as! PFUser
                        let user = User()
                        user.username = pfUser.username
                        user.objectID = pfUser.objectId
                        print("Here")
                        if let image = object["profilePicture"] as? PFFile {
                            image.getDataInBackground {
                                (imageData:Data?, error:Error?) -> Void in
                                print(user.username)
                                user.image = UIImage(data: imageData!)
                                print("Got here")
                                self.userArray.append(user)
                                self.currentUserArray = self.userArray
                                self.searchTableView.reloadData()
                            }
                        }
                    }
                }
            }
            
        }
    }

    @IBAction func registrationUnwind(segue: UIStoryboardSegue) {
    }
    
    @IBAction func sendUnwind(segue: UIStoryboardSegue) {
        if segue.identifier == "sendUnwind" {
            unwinded = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (unwinded) {
            let alert = UIAlertController(title: "Successfully Sent", message: "You've successfully shared your info with " + self.selectedUser.username + "!", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            unwinded = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navVC = segue.destination as? UINavigationController

        if segue.identifier == "showSendScreen" {
            let targetVC = navVC?.viewControllers.first as! sendInfoVC
            targetVC.selectedUser = self.selectedUser
        }
    }
    
}
