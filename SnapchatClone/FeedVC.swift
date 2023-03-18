//
//  FeedVC.swift
//  SnapchatClone
//
//  Created by Muhammet Kadir on 13.03.2023.
//

import UIKit
import Firebase
import SDWebImage
class FeedVC: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let fireStoreDataBase = Firestore.firestore()
    var snapArray = [Snap]()
    
    var choosenSnap : Snap?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getSnapsFromFirebase()
        getUserInfo()
    }
    
    
    func getSnapsFromFirebase(){
        fireStoreDataBase.collection("Snaps").order(by: "date",descending: true).addSnapshotListener { snapshot, error in
            if error != nil{
                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
            }else{
                if snapshot?.isEmpty == false && snapshot != nil{
                    self.snapArray.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents{
                        
                        let documentId = document.documentID
                        
                        if let username = document.get("snapOwner") as? String{
                            if let imageUrl = document.get("imageUrlArray") as? [String]{
                                if let date = document.get("date") as? Timestamp{
                                    if let difference = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour{
                                        if difference >= 24{
                                            self.fireStoreDataBase.collection("Snaps").document(documentId).delete(){(error) in
                                                
                                            }
                                        }else{
                                            let snap = Snap(userName: username, imageUrlArray: imageUrl, date: date.dateValue(), timeDifference: 24-difference)
                                            self.snapArray.append(snap)
                                        }
                                        
                                    }
                                    
                                }
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func getUserInfo(){
        fireStoreDataBase.collection("UserInfo").whereField("email", isEqualTo: Auth.auth().currentUser?.email!).getDocuments { snapshot, error in
            if error != nil{
                self.makeAlert(titleInput: "error", messageInput: error?.localizedDescription ?? "Error")
            }else{
                if snapshot?.isEmpty == false && snapshot != nil{
                    for document in snapshot!.documents{
                        if let username = document.get("username") as? String{
                            UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                            UserSingleton.sharedUserInfo.username = username
                        }
                    }
                }
            }
        }
    }
    
    
    func makeAlert(titleInput:String, messageInput:String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.feedUserNameLabel.text = snapArray[indexPath.row].userName
        cell.feedUserImageView.sd_setImage(with: URL(string: snapArray[indexPath.row].imageUrlArray[0]))
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSnapVC"{
            let destinationVC = segue.destination as! SnapVC
            destinationVC.selectedSnap = choosenSnap
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        choosenSnap = self.snapArray[indexPath.row]
        performSegue(withIdentifier: "toSnapVC", sender: nil)
    }
}
