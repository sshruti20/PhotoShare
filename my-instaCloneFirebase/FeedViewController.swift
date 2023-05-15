//
//  FeedViewController.swift
//  my-instaCloneFirebase
//
//  Created by Shruti S on 11/05/23.
//

import UIKit

import FirebaseCore
import FirebaseFirestore
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    //Arrays of all user's data
    var userEmails = [String]()
    var imageUrls = [String]()
    var comments = [String]()
    var likes = [Int]()
    var documentIds = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
        getDataFromFirestore()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmails.count
    }
    
    /*
    override func viewWillAppear(_ animated: Bool) {
        getDataFromFirestore()
    } */

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.userEmailLabel.text = userEmails[indexPath.row]
        //cell.imageView?.sd_setImage(with: URL(string: self.imageUrls[indexPath.row]))
        cell.userImageView?.sd_setImage(with: URL(string: self.imageUrls[indexPath.row]))
        cell.commentLabel.text = comments[indexPath.row]
        cell.likeLabel.text = String(likes[indexPath.row])
        cell.documentIdLabel.text = documentIds[indexPath.row]
        
        return cell
    }
    
    func getDataFromFirestore() {
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                
                if snapshot?.isEmpty == true || snapshot == nil {
                    return
                }
                
                self.clearUserArrays()
                
                print("Gathering images")
                
                for document in snapshot!.documents {
                    let documentId = document.documentID
                    self.documentIds.append(documentId)
                    
                    if let userEmail = document.get("postedBy") as? String {
                        self.userEmails.append(userEmail)
                    }
                    if let imageUrl = document.get("imageUrl") as? String {
                        self.imageUrls.append(imageUrl)
                    }
                    if let comment = document.get("postComment") as? String {
                        self.comments.append(comment)
                    }
                    if let likeCount = document.get("likes") as? Int {
                        self.likes.append(likeCount)
                    }
                }
            }
            self.tableView.reloadData()
        } //snapshot listener ends
        
    }

    func clearUserArrays() {
        self.userEmails.removeAll()
        self.comments.removeAll()
        self.likes.removeAll()
        self.imageUrls.removeAll()
        self.documentIds.removeAll()
    }

}


extension UIImage {
  func scaleToSize(aSize :CGSize) -> UIImage? {
    if (CGSizeEqualToSize(self.size, aSize)) {
      return self
    }

    UIGraphicsBeginImageContextWithOptions(aSize, false, 0.0)
      self.draw(in: CGRectMake(0.0, 0.0, aSize.width, aSize.height))
      guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
    UIGraphicsEndImageContext()
    return image
  }
}


extension UIImageView {
    var intrinsicScaledContentSize: CGSize? {
        switch contentMode {
        case .scaleAspectFit:
            // aspect fit
            if let image = self.image {
                let imageWidth = image.size.width
                let imageHeight = image.size.height
                let viewWidth = self.frame.size.width
                
                let ratio = viewWidth/imageWidth
                let scaledHeight = imageHeight * ratio
                
                return CGSize(width: viewWidth, height: scaledHeight)
            }
        case .scaleAspectFill:
            // aspect fill
            if let image = self.image {
                let imageWidth = image.size.width
                let imageHeight = image.size.height
                let viewHeight = self.frame.size.width
                
                let ratio = viewHeight/imageHeight
                let scaledWidth = imageWidth * ratio
                
                return CGSize(width: scaledWidth, height: imageHeight)
            }
            
        default: return self.bounds.size
        }
        
        return nil
    }
}
