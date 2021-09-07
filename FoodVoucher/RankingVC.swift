//
//  RankingVC.swift
//  
//
//  Created by 임명심 on 2021/09/06.
//

import UIKit
import Firebase

class RankingVC: UITableViewController {
    
    let db = Firestore.firestore()
    var stores: [Store] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadRanking()
    }
    
    func loadRanking() {
        db.collection("rating").order(by: "rating", descending: true).addSnapshotListener { querysnapshot, error in
            self.stores = []
            
            if let e = error {
                print(e.localizedDescription)
            } else {
                if let snapShotDocuments = querysnapshot?.documents {
                    for doc in snapShotDocuments {
                        let data = doc.data()
                        //print(data)
                    }
                }
            }
        }
    }
}
