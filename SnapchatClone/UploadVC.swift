//
//  UploadVC.swift
//  SnapchatClone
//
//  Created by Muhammet Kadir on 13.03.2023.
//

import UIKit
import Firebase
import FirebaseStorage
class UploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    
    
    @IBAction func uploadClick(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            let uuid = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data) { metadata, error in
                if error != nil{
                    self.makeAlert(titleInput: "error", messageInput: error!.localizedDescription)
                }else{
                    imageReference.downloadURL { url, error in
                        if error == nil{
                            let imageUrl = url?.absoluteString
                            
                            
                            let fireStore = Firestore.firestore()
                            
                            
                            
                            fireStore.collection("Snaps").whereField("snapOwner", isEqualTo: UserSingleton.sharedUserInfo.username).getDocuments {(snapshot, error) in
                                if error != nil{
                                    self.makeAlert(titleInput: "error", messageInput: error?.localizedDescription ?? "Error")
                                }else{
                                    if snapshot?.isEmpty == false && snapshot != nil{
                                        for document in snapshot!.documents{
                                            let documentId = document.documentID
                                            
                                            if var imageUrlArray = document.get("imageUrlArray") as? [String]{
                                                
                                                imageUrlArray.append(imageUrl!)
                                                
                                                let additionalDictionary = ["imageUrlArray" : imageUrlArray] as [String : Any]
                                                
                                                fireStore.collection("Snaps").document(documentId).setData(additionalDictionary,merge: true){(error) in
                                                    if(error == nil){
                                                        self.tabBarController?.selectedIndex = 0
                                                        self.imageView.image = UIImage(named: "selectimage")
                                                    }
                                                    
                                                }
                                            }
                                        }
                                    }else{
                                        let snapDictionary = [
                                            "imageUrlArray" : [imageUrl!],
                                            "snapOwner" : UserSingleton.sharedUserInfo.username,
                                            "date" : FieldValue.serverTimestamp()
                                        ] as [String:Any]
                                        fireStore.collection("Snaps").addDocument(data: snapDictionary){(error) in
                                            if error != nil{
                                                self.makeAlert(titleInput: "error", messageInput: error?.localizedDescription ?? "Error")
                                            }else{
                                                self.tabBarController?.selectedIndex = 0
                                                self.imageView.image = UIImage(named: "selectimage")
                                            }
                                        }
                                    }
                                }
                            }
                            
                            
                        }
                    }
                }
            }
        }
    }
    
    
    @objc func chooseImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    
    
    func makeAlert(titleInput:String, messageInput:String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
