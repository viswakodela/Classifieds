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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMessagesFromFirebase()
    }
    
    func fetchMessagesFromFirebase() {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        var postIds = [String]()
        
        let messagesRef = Database.database().reference().child("messages")
        messagesRef.child(uid).observe(.value) { (snap) in
            guard let snapDictionary = snap.value as? [String : Any] else {return}
            snapDictionary.forEach({ (key, value) in
                
                let toId = key
                messagesRef.child(uid).child(toId).observe(.value, with: { (snap) in
                    guard let postIdDictionary = snap.value as? [String : Any] else {return}
                    postIdDictionary.forEach({ (arg) in
                        let (key, _) = arg
                        postIds.append(key)
                    })
                    
                    postIds.forEach({ (postId) in
                        
                        messagesRef.child(uid).child(toId).child(postId).observe(.value, with: { (snap) in
                            
                            guard let snapDict = snap.value as? [String : Any] else {return}
                            snapDict.forEach({ (key, value) in
                                
                                guard let messaageDict = value as? [String : Any] else {return}
                                let message = Message(dictionary: messaageDict)

                                self.messagesDictionary[postId] = message
                                self.messages = Array(self.messagesDictionary.values)
                                self.messages.sort(by: { (message1, message2) -> Bool in
                                    return Double(message1.timeStamp!) > Double(message2.timeStamp!)
                                })
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                            })
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
        newMessage.messages = self.messages
        navigationController?.pushViewController(newMessage, animated: true)
    }
    
}
