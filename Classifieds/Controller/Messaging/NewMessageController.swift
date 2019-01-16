//
//  NewMessageController.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/9/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UIViewController {
    
    private let messageCell = "messageCell"
    
    var post: Post? {
        didSet {
            navigationItem.title = post?.title
            observeMessages(post: post, user: self.user)
        }
    }
    
    var user: User? {
        didSet {
            print(user?.uid)
            observeMessages(post: self.post, user: user)
        }
    }
    
    var message: Message? {
        didSet {
        }
    }
    
    var messages = [Message]()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .white
        tableView.register(MessageCell.self, forCellReuseIdentifier: messageCell)
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .interactive
        settingLayout()
    }
    
    func observeMessages(post: Post?, user: User?) {
        
        guard let postID = self.post?.postId else {return}
        guard let fromID = Auth.auth().currentUser?.uid else {return}
        guard let toID = self.post?.uid else {return}
        
        let postMesageRef = Database.database().reference().child("post-messages").child(postID).child(fromID).child(toID)
        postMesageRef.observe(.childAdded) { (snap) in
            print(snap.key)
            let messageId = snap.key
            
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            messagesRef.observe(.value, with: { (snap) in
                guard let messageDictionary = snap.value as? [String : Any] else {return}
                let message = Message(dictionary: messageDictionary)
                self.messages.append(message)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    lazy var messageTextField: UITextField = {
        let texField = UITextField()
        texField.placeholder = "Enter Message..."
        texField.delegate = self
        texField.borderStyle = .roundedRect
        texField.translatesAutoresizingMaskIntoConstraints = false
        return texField
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "icons8-send-letter-100").withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
//    @objc func handleSend() {
//        print("Sending")
//
//        if messageTextField.text == "" {
//            return
//        }
//        guard let postID = post?.postId else {return}
//        guard let messageText = messageTextField.text else {return}
//        guard let fromID = Auth.auth().currentUser?.uid else {return}
////        guard let toID = post?.uid else {return} // issue arised when i changed the uid to User
//        let timeStamp = Date.timeIntervalSinceReferenceDate
//        let values = ["messageText" : messageText, "fromId" : fromID, "toId" : toID, "timeStamp" : timeStamp] as [String : Any]
//
//        let messageRef = Database.database().reference().child("messages")
//        let childRef = messageRef.childByAutoId()
//
//        childRef.updateChildValues(values)
//
//        let postMessagesRef = Database.database().reference().child("post-messages")
//        guard let messageID = childRef.key else {return}
//        let childValue = [messageID : 1]
//        postMessagesRef.child(postID).child(fromID).child(toID).updateChildValues(childValue)
//
//        postMessagesRef.child(postID).child(toID).child(fromID).updateChildValues(childValue)
//
//        self.messageTextField.text = nil
        
//    }
    
    func settingLayout() {
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        
        
        let stackView = UIStackView(arrangedSubviews: [messageTextField, sendButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        sendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        view.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
}

extension NewMessageController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: messageCell, for: indexPath) as! MessageCell
        let message = messages[indexPath.row]
        cell.message = message
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NewMessageController: UITextFieldDelegate {
    
    
    
}
