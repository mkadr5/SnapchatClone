//
//  SettingsVC.swift
//  SnapchatClone
//
//  Created by Muhammet Kadir on 13.03.2023.
//

import UIKit
import Firebase
class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func logoutClick(_ sender: Any) {
        do{
            try  Auth.auth().signOut()
            performSegue(withIdentifier: "toSignInVC", sender: nil)
        }catch{
            print("error")
        }
    }
}
