//
//  UploadViewController.swift
//  my-instaCloneFirebase
//
//  Created by Shruti S on 11/05/23.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseImage)))
    }
    
    @objc func chooseImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        imageView.image = image
        self.dismiss(animated: true)
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "ok", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }

    @IBAction func uploadClicked(_ sender: Any) {
        
        let storageReference = Storage.storage().reference()
        let mediaFolder = storageReference.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")
            
            imageReference.putData(data) { metadata, error in
                if error != nil {
                    //print(error?.localizedDescription)
                    self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Unknown error")
                } else {
                    imageReference.downloadURL { url, error in
                        if error == nil {
                            let uploadedImageUrl = url?.absoluteString
                            
                            //Firestore Database
                            let firestoreDatabase = Firestore.firestore()
                            var firestoreReference: DocumentReference? = nil
                            
                            var firestorePost = ["imageUrl": uploadedImageUrl,
                                                 "postedBy": Auth.auth().currentUser!.email!,
                                                 "postComment": self.commentText.text,
                                                 "date": FieldValue.serverTimestamp(),
                                                 "likes": 0
                            ] as! [String: Any]
            
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost) { (error) in
                                if error != nil {
                                    self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "")
                                } else {
                                    self.tabBarController?.selectedIndex = 0
                                }
                            }
                        }
                    }
                } // else ends
                
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
