//
//  MessagesTableController.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/10/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit
import Firebase

class MessagesTableController: UITableViewController {
    
    var messages = [Message]()
    var post: Post?
    var messagesDictionary = [String : Message]()
    
    private let messagesCellsId = "messagesCellsId"
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Messages"
        tableView.register(MessagesControllerCell.self, forCellReuseIdentifier: messagesCellsId)
        fetchMessagesFromFirebase()
    }
    
    func fetchMessagesFromFirebase() {
        
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("posts").document(currentUID).collection("userPosts").getDocuments { (snap, err) in
            if let error = err {
                print(error.localizedDescription)
            }
            snap?.documents.forEach({ (snapshot) in
                let postDictionary = snapshot.data()
                let post = Post(dictionary: postDictionary)
                
                guard let postID = post.postId else {return}
                
                let postMessages = Database.database().reference().child("post-messages").child(postID).child(currentUID)
                postMessages.observe(.childAdded, with: { (snap) in
                    let buyerID = snap.key
                    postMessages.child(buyerID).observe(.childAdded, with: { (snap) in
                        
                        let messageID = snap.key
                        let messagesRef = Database.database().reference().child("messages")
                        messagesRef.child(messageID).observe(.value, with: { (snap) in
                            guard let messageDictionary = snap.value as? [String : Any] else {return}
                            let message = Message(dictionary: messageDictionary)
                            let chatPartnerID = message.chatPartnerId()
                            self.messagesDictionary[chatPartnerID] = message
                            self.messages = Array(self.messagesDictionary.values)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        })
                    })
                })
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: messagesCellsId, for: indexPath) as! MessagesControllerCell
        let message = messages[indexPath.row]
        cell.message = message
//        cell.messagesTableController = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newMessage = NewMessageController()
        let message = messages[indexPath.row]
        
        let chatPartnerID = message.chatPartnerId()
        print(chatPartnerID)
        
        Firestore.firestore().collection("users").document(chatPartnerID).getDocument { (snap, err) in
            if let error = err {
                print(error.localizedDescription)
            }
            guard let userDictionary = snap?.data() else {return}
            let user = User(dictionary: userDictionary)
            
            let newMessageController = NewMessageController()
            newMessageController.user = user
            
        }
        navigationController?.pushViewController(newMessage, animated: true)
    }
    
}
