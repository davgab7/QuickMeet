//
//  ProfileVC.swift
//  QuickMeet
//
//  Created by Gabe Wilson on 11/4/18.
//  Copyright © 2018 Gabe Wilson. All rights reserved.
//

import Foundation
import Parse

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!

    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    @IBAction func profilePictureAction(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let alert = UIAlertController(title: nil, message: "You can load a profile image from the following sources:", preferredStyle: UIAlertController.Style.actionSheet)
            alert.view.tintColor = self.navigationController?.navigationBar.backgroundColor
            alert.addAction(UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) { (action) in
                print("Open Camera")
                self.imagePicker.allowsEditing = true
                self.imagePicker.sourceType = .camera
                self.imagePicker.modalPresentationStyle = .popover
                self.imagePicker.navigationBar.isTranslucent = false
                self.present(self.imagePicker, animated: true, completion: nil)
            })
            
            alert.addAction(UIAlertAction(title: "Library", style: UIAlertAction.Style.default) { (action) in
                print("Open Library")
                self.imagePicker.allowsEditing = true
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.modalPresentationStyle = .popover
                self.imagePicker.navigationBar.isTranslucent = false
                self.present(self.imagePicker, animated: true, completion: nil)
            })
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            // Camera not available - open Library
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            imagePicker.modalPresentationStyle = .popover
            imagePicker.navigationBar.isTranslucent = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func logoutAction() {
        showLogout()
    }
    
    func showLogout() {
        let refreshAlert = UIAlertController(title: "Refresh", message: "Are you sure you want to log out?", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (action: UIAlertAction!) in
            PFUser.logOut()
            self.performSegue(withIdentifier: "registrationUnwind", sender: nil)
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    
    var mediaItems = ["Phone","Email", "Facebook", "Snapchat", "Instagram", "Log Out"]
    var dataArray = ["","","","",""]
    override func viewDidLoad() {
        setupUI()
    }
    
    func setupUI() {
        tableView.isScrollEnabled = false
        imagePicker.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        print(tableView.allowsSelection, "can i select tv")
        tableView.allowsSelection = true
        print("now i can", tableView.allowsSelection)
        usernameLabel.text = PFUser.current()?.username
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(ProfileVC.logoutAction))
        if let image = PFUser.current()!["profilePicture"] as? PFFile {
            image.getDataInBackground {
                (imageData:Data?, error:Error?) -> Void in
                print(PFUser.current()?.username, "this is the user with image")
                self.profilePictureImageView.image = UIImage(data: imageData!)
                print(imageData!, "imageData")
            }
        }
        queryUserData()
        
    }
    
    func queryUserData() {
        let query = PFQuery(className: "_User")
        query.getObjectInBackground(withId: (PFUser.current()?.objectId)!) { (object, error) in
            let user = object as! PFUser
            if let phone = user["phone"] as? String {
                self.dataArray[0] = phone
            } else {
                self.dataArray[0] = ""
            }
            if let email = user["email"] as? String {
                self.dataArray[1] = email
            } else {
                self.dataArray[1] = ""
            }
            if let facebook = user["facebook"] as? String {
                self.dataArray[2] = facebook
            } else {
                self.dataArray[2] = ""
            }
            if let snapchat = user["snapchat"] as? String {
                self.dataArray[3] = snapchat
            } else {
                self.dataArray[3] = ""
            }
            if let instagram = user["instagram"] as? String {
                self.dataArray[4] = instagram
            } else {
                self.dataArray[4] = ""
            }
            self.tableView.reloadData()
        }
        tableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ChooseMediaCell
        cell.selectionStyle = .none
        if indexPath.row < 5 {
            cell.mediaNameLabel.text = dataArray[indexPath.row]
            cell.mediaImageView.image = UIImage(named: mediaItems[indexPath.row])
            if dataArray[indexPath.row] != "" {
                cell.mediaSwitch.isOn = true
            } else {
                cell.mediaSwitch.isOn = false
            }
            if dataArray[indexPath.row] == "" {
                if indexPath.row == 0 {
                    cell.mediaNameLabel.text = "Phone"
                } else if indexPath.row == 1 {
                    cell.mediaNameLabel.text = "Email"
                } else if indexPath.row == 2 {
                    cell.mediaNameLabel.text = "Facebook"
                } else if indexPath.row == 3 {
                    cell.mediaNameLabel.text = "Snapchat"
                } else if indexPath.row == 4 {
                    cell.mediaNameLabel.text = "Instagram"
                }
            }
        } else {
            cell.mediaNameLabel.text = "Logout"
            cell.mediaImageView.image = UIImage(named: "Logout")
            cell.mediaSwitch.isHidden = true
        }
        
        cell.mediaSwitch.tag = indexPath.row
        cell.mediaSwitch.addTarget(self, action: #selector(ProfileVC.onSwitchValueChanged), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
        if indexPath.row == 5 {
            showLogout()
        }
    }
    
    /*func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        print("made it here")
        if let currentUser = PFUser.current() {
            title = "Saving..."
            let imageData = image.pngData()
            currentUser["profilePicture"] = PFFile(name: "image.jpg", data: imageData!)
            currentUser.saveInBackground(block: { (success, error) in
                if let error = error {
                    print("Error saving image: \(error.localizedDescription)")
                } else if success {
                    print("Profile image updated!")
                }
                
                // Load from Parse
                self.profilePictureImageView.image = image
                self.title = "Profile"
            })
        }
        
        dismiss(animated: true, completion: nil)
    }*/
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        print(image.size)
        if let currentUser = PFUser.current() {
            let imageData = image.pngData()
            currentUser["profilePicture"] = PFFile(name: "image.jpg", data: imageData!)
            currentUser.saveInBackground(block: { (success, error) in
                if let error = error {
                    print("Error saving image: \(error.localizedDescription)")
                } else if success {
                    print("Profile image updated!")
                }
                
                // Load from Parse
                self.profilePictureImageView.image = image
            })
        }
    }
    
    @objc func onSwitchValueChanged(_ mediaSwitch: UISwitch) {
        if mediaSwitch.isOn {
            print("on")
        } else {
            print("off")
        }
    }
    

    
    
    
}
