//
//  ViewController.swift
//  my-instaCloneFirebase
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController {
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBAction func signUpClicked(_ sender: Any) {
        if usernameText.text != "" && passwordText.text != "" {
            Auth.auth().createUser(withEmail: usernameText!.text!, password: passwordText!.text!) { (authData, error) in
                if error != nil {
                    self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Error")
                } else {
                    self.performSegue(withIdentifier: "toTabVC", sender: nil)
                }
            }
        } else {
            makeAlert(title: "Error", message: "username/password missing")
        }
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        
        if usernameText.text != nil && passwordText.text != nil {
            Auth.auth().signIn(withEmail: usernameText.text!, password: passwordText.text!) { (authData, error) in
                if error != nil {
                    self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Unknown error")
                } else {
                    self.performSegue(withIdentifier: "toTabVC", sender: nil)
                }
            }
        } else {
            makeAlert(title: "Error", message: "username/password missing")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
}

