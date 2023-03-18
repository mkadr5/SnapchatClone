//
//  ViewController.swift
//  SnapchatClone
//
//  Created by Muhammet Kadir on 12.03.2023.
//

import UIKit
import Firebase

class SignInVC: UIViewController {

    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func signUpClick(_ sender: Any) {
        if emailText.text != "" && usernameText.text != "" && passwordText.text != ""{
            print("email \(emailText.text!) username : \(usernameText.text!)")
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { auth, error in
                if error != nil{
                    self.makeAlert(titleInput: "Error", messageInput: error!.localizedDescription)
                }else{
                    let fireStore = Firestore.firestore()
                    let userDictionary = ["email" : self.emailText.text!, "username" : self.usernameText.text!]
                    fireStore.collection("UserInfo").addDocument(data: userDictionary)
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }else{
            self.makeAlert(titleInput: "Error", messageInput: "Email / Username / Password ?")
        }
    }
    @IBAction func signInClick(_ sender: Any) {
        if emailText.text != "" && passwordText.text != ""{
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { auth, error in
                if error != nil{
                    self.makeAlert(titleInput: "Error", messageInput: error!.localizedDescription)
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }else{
            self.makeAlert(titleInput: "Error", messageInput: "Email / Username / Password ?")
        }
    }
    
    func makeAlert(titleInput:String, messageInput:String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}

/*
 if error != nil {
     self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription!)
 }else{
     let fireStore = Firestore.firestore()
     let userDictionary = ["email" : emailText.text, "username" : usernameText.text]
     fireStore.collection("UserInfo").addDocument(data: userDictionary)
     self.performSegue(withIdentifier: "toFeedVC", sender: nil)
 }
 */
