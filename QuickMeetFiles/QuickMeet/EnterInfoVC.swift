//
//  EnterInfoVC.swift
//  QuickMeet
//
//  Created by Gabe Wilson on 11/3/18.
//  Copyright © 2018 Gabe Wilson. All rights reserved.
//

import Foundation
import UIKit
import Parse

class EnterInfoVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    
    @IBOutlet weak var saveOutlet: UIBarButtonItem!
    
    @IBAction func saveAction(_ sender: Any) {
        if let currentUser = PFUser.current()! as? PFUser {
            for key in dataDict.keys {
                currentUser[key] = dataDict[key]
            }
            currentUser.saveInBackground(){ (success, error) -> Void in
                if success {
                    self.performSegue(withIdentifier: "showTabBar", sender: nil)
                } else {
                    print("failed to clear badges")
                }
            }
        }
    }
    
    var dataDict = ["phone":"", "email": "", "facebook": "", "snapchat": "", "instagram": ""]
    var chosenItems = [String]()
    var verifiedFields = [Bool]()
    var inputs = [String]()
    
    override func viewDidLoad() {
        print("made it to view did load")
        saveOutlet.isEnabled = false
        collectionView?.isPagingEnabled = true
        for item in chosenItems {
            verifiedFields.append(false)
        }
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        collectionView?.backgroundColor = UIColor(red: 0/255, green: 128/255, blue: 128/255, alpha: 1)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillAppear() {
        collectionView.isScrollEnabled = false
    }
    
    @objc func keyboardWillDisappear() {
        collectionView.isScrollEnabled = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chosenItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! EnterInfoCollectionViewCell
        cell.imageView.layer.cornerRadius = cell.imageView.frame.height/2
        cell.imageView.layer.masksToBounds = true
        cell.imageView.image = UIImage(named: chosenItems[indexPath.item])
        cell.titleLabel.text = chosenItems[indexPath.item]
        cell.textField.delegate = self
        cell.textField.tag = indexPath.item
        cell.textField.addTarget(self, action: #selector(EnterInfoVC.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        if chosenItems[indexPath.item] == "Phone" {
            cell.textField.keyboardType = .phonePad
            cell.descriptionLabel.text = "Enter your phone number below"
        } else if chosenItems[indexPath.item] == "Email" {
            cell.textField.keyboardType = .emailAddress
            cell.descriptionLabel.text = "Enter the email you would like to share with friends below"
        } else if chosenItems[indexPath.item] == "Facebook" {
            cell.textField.keyboardType = .default
            cell.descriptionLabel.text = "Enter your Facebook username below"
        } else if chosenItems[indexPath.item] == "Snapchat" {
            cell.textField.keyboardType = .default
            cell.descriptionLabel.text = "Enter your Snapchat handle below"
        } else if chosenItems[indexPath.item] == "Instagram" {
            cell.textField.keyboardType = .default
            cell.descriptionLabel.text = "Enter your instagram handle below"
        }
        cell.textField.returnKeyType = .done
        cell.imageView.backgroundColor = self.navigationController?.navigationBar.barTintColor
        cell.imageView.layer.borderWidth = 3.0
        cell.imageView.layer.borderColor = UIColor(red: 0.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0).cgColor
        cell.titleLabel.text = chosenItems[indexPath.item]
        cell.contentView.layer.cornerRadius = 30.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true;
        cell.layer.shadowColor = UIColor.white.cgColor
        cell.layer.shadowOffset = CGSize(width:0,height: 2.0)
        cell.layer.shadowRadius = 1.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false;
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        let cellMaxY = cell.frame.maxY
        let viewMaxY = collectionView.frame.maxY
        cell.frame.origin.y = cell.frame.origin.y + (viewMaxY - cellMaxY)
        
        return cell
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        print("text field is changing")
        if chosenItems[textField.tag] == "Phone" {
            if (textField.text?.characters.count)! < 11 && (textField.text?.characters.count)! > 9 {
                verifiedFields[textField.tag] = true
                dataDict["phone"] = textField.text
            } else {
                verifiedFields[textField.tag] = false
            }
        } else if chosenItems[textField.tag] == "Email" {
            if (isValidEmail(email: textField.text!)) {
                verifiedFields[textField.tag] = true
                dataDict["email"] = textField.text
            } else {
                verifiedFields[textField.tag] = false
            }
        } else if chosenItems[textField.tag] == "Facebook" {
            if !((textField.text?.isEmpty)!) {
                verifiedFields[textField.tag] = true
                dataDict["facebook"] = textField.text
            } else {
                verifiedFields[textField.tag] = false
            }
        } else if chosenItems[textField.tag] == "Snapchat" {
            if !((textField.text?.isEmpty)!) {
                print("not empty!")
                verifiedFields[textField.tag] = true
                dataDict["snapchat"] = textField.text
            } else {
                verifiedFields[textField.tag] = false
            }
        } else if chosenItems[textField.tag] == "Instagram" {
            if !((textField.text?.isEmpty)!) {
                verifiedFields[textField.tag] = true
                dataDict["instagram"] = textField.text
            } else {
                verifiedFields[textField.tag] = false
            }
        }
        if allFieldVerified() {
            saveOutlet.isEnabled = true
        }
    }
    
    func allFieldVerified() -> Bool {
        for field in verifiedFields {
            if !field {
                return false
            }
        }
        return true
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let navBarHeight = navigationController!.navigationBar.frame.height
        return CGSize(width: view.frame.width, height: view.frame.height - navBarHeight)
    }
}

