//
//  FeedCell.swift
//  my-instaCloneFirebase
//
//  Created by Shruti S on 13/05/23.
//

import UIKit
import FirebaseFirestore

class FeedCell: UITableViewCell {

    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    
    @IBOutlet weak var documentIdLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        let firestore = Firestore.firestore()
        var likecount = Int(likeLabel.text!)
        var likeStore = ["likes": likecount!+1] as [String: Any]
        
        firestore.collection("Posts").document(documentIdLabel.text!).setData(likeStore, merge: true)
    }

}
