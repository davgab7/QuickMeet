//
//  ViewController.swift
//  DonationTracker
//
//  Created by Gabe Wilson on 9/29/18.
//  Copyright © 2018 Gabe Wilson. All rights reserved.
//

import UIKit
import Parse

class RegistrationVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var submitLoginSignUpOutlet: UIButton!
    @IBOutlet weak var loginSignUpOutlet: UIButton!
    @IBOutlet weak var toggleLoginSignUpOutlet: UIButton!
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    @IBOutlet weak var confirmPasswordLine: UILabel!
    
    @IBAction func submitLoginSignUpAction(_ sender: Any) {
        if confirmPasswordTextfield.isHidden { //Login
            login()
        } else { //Sign Up
            signUp()
        }
    }
    
    @IBAction func registrationUnwind(segue: UIStoryboardSegue) {
    }
    
    @IBAction func toggleLoginSignUpAction(_ sender: Any) {
        let yourAttributes : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
        if toggleLoginSignUpOutlet.titleLabel?.text == "Already have an account?" { //Change to login layout
            submitLoginSignUpOutlet.setTitle("Login", for: .normal)
            toggleLoginSignUpOutlet.setTitle(" Create a new account? ", for: .normal)
            let attributeString = NSMutableAttributedString(string: "Sign Up", attributes: yourAttributes)
            loginSignUpOutlet.setAttributedTitle(attributeString, for: .normal)
            confirmPasswordLabel.isHidden = true
            confirmPasswordTextfield.isHidden = true
            confirmPasswordLine.isHidden = true
            passwordTextField.returnKeyType = .go
        } else { //Change to Sign Up layout
            submitLoginSignUpOutlet.setTitle("Sign Up", for: .normal)
            toggleLoginSignUpOutlet.setTitle("Already have an account?", for: .normal)
            let attributeString = NSMutableAttributedString(string: "Login", attributes: yourAttributes)
            loginSignUpOutlet.setAttributedTitle(attributeString, for: .normal)
            confirmPasswordLabel.isHidden = false
            confirmPasswordTextfield.isHidden = false
            confirmPasswordLine.isHidden = false
            passwordTextField.returnKeyType = .next
        }
        textFieldDidChange()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            self.performSegue(withIdentifier: "showTB", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    
    func setupUI() {
        submitLoginSignUpOutlet.alpha = 0.5
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextfield.delegate = self
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        confirmPasswordTextfield.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        submitLoginSignUpOutlet.layer.cornerRadius = submitLoginSignUpOutlet.frame.height/2
    }
    
    func signUp() {
        let user = PFUser()
        user.username = usernameTextField.text
        user.password = passwordTextField.text
        
        let imageData = UIImage(named: "DefaultProfilePicture")!.pngData()
        //create parse file
        let parseImageFile = PFFile(name: "profilePicture.png", data: imageData!)
        user["profilePicture"] = parseImageFile
        user.signUpInBackground(block: { (success, error) in
            if success {
                self.performSegue(withIdentifier: "showChooseMedia", sender: nil)
            }
        })
    }
    
    func login() {
        print("got to login")
        PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!, block: { (user, error) in
            if user != nil {
                // Yes, User Exists
                self.usernameTextField.text = ""
                self.passwordTextField.text = ""
                self.performSegue(withIdentifier: "showTB", sender: nil)

            } else {
                // No, User Doesn't Exist
            }
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        print("return pressed")
        if textField == self.usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == self.passwordTextField {
            if confirmPasswordTextfield.isHidden {
                submitLoginSignUpAction(self)
            } else {
                confirmPasswordTextfield.becomeFirstResponder()
            }
        } else if textField == self.confirmPasswordTextfield {
            submitLoginSignUpAction(self)
        }
        return true
    }
    
    @objc func textFieldDidChange() {
        if !(usernameTextField.text?.isEmpty)! && !(passwordTextField.text?.isEmpty)!
            && (!(confirmPasswordTextfield.text?.isEmpty)! || confirmPasswordTextfield.isHidden) {
            submitLoginSignUpOutlet.alpha = 1.0
            submitLoginSignUpOutlet.isEnabled = true
        } else {
            submitLoginSignUpOutlet.alpha = 0.5
            submitLoginSignUpOutlet.isEnabled = false
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


