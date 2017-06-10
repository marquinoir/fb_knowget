//
//  LoginViewController.swift
//  FireBooks
//
//  Created by K: Viho on 6/9/17.
//  Copyright © 2017 NYU. All rights reserved.
//

import UIKit

import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    /**
     Sent to the delegate when the button was used to login.
     - Parameter loginButton: the sender
     - Parameter result: The results of the login
     - Parameter error: The error (if any) from the login
     */
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        //frame's are obselete, please use constraints instead because its 2016 after all
        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        
        loginButton.delegate = self
    }
    
       func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
        print("Successfully logged in with facebook...")
        FIRAuth.auth()!.addStateDidChangeListener { (auth, user) in
                       if user != nil {
                            self.performSegue(withIdentifier: "showBooks", sender: nil)
                        }
                    }
        
        func login(_ sender: Any) {
                    FIRAuth.auth()!.signIn(withEmail: username.text!, password: password.text!)
            
                }
        func register(_ sender: Any) {
                    let alert =
                        UIAlertController(title: "Register", message: "Register", preferredStyle: .alert)
                   let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            
                        let username = alert.textFields![0]
                        let password = alert.textFields![1]
            
                        FIRAuth.auth()!.createUser(withEmail: username.text!, password: password.text!, completion: { (user, error) in
            
            
            
                            if error == nil {
                               FIRAuth.auth()!.signIn(withEmail: username.text!, password: password.text!)
                            }
            
                       })
            
            
                }
                  let cancelAction =
                        UIAlertAction(title: "CaNcel", style: .default)
            
                   alert.addTextField { (textField) in
                        textField.placeholder = "Enter your email"
                    }
                    alert.addTextField { (textField) in
                        textField.placeholder = "Enter your password"
                        textField.isSecureTextEntry = true
                    }
            
                    alert.addAction(saveAction)
                    alert.addAction(cancelAction)
                    present(alert, animated: true, completion: nil)
                }

}
}

//    
//    override func viewDidLoad() {
//        super.viewDidLoad()

//    }
//    
//    
//
//
//extension LoginViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if textField == username {
//            password.becomeFirstResponder()
//        }
//        if textField == password {
//            textField.resignFirstResponder()
//        }
//        return true
//    }
//}
