//
//  NewMessageController.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/9/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit
import Firebase
import InputBarAccessoryView


class NewMessageController: UITableViewController {
    
    private static let messageCellID = "messageCellID"
    
    var post: Post? {
        didSet {
            print(post?.title ?? "")
            observeMessages()
        }
    }
    
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(MessageCell.self, forCellReuseIdentifier: NewMessageController.messageCellID)
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .interactive
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    var inputaccessoryView: UIView!
    
    override var inputAccessoryView: UIView? {
        
        if self.inputaccessoryView == nil {
            inputaccessoryView = Customview()
            inputaccessoryView.backgroundColor = UIColor.groupTableViewBackground
            inputaccessoryView.heightAnchor.constraint(equalToConstant: 80).isActive = true
            inputaccessoryView.autoresizingMask = .flexibleHeight
            inputaccessoryView.addSubview(messageTextView)
            
            
            inputaccessoryView.addSubview(sendButton)
            
            sendButton.trailingAnchor.constraint(equalTo: inputaccessoryView.trailingAnchor, constant: -10).isActive = true
            sendButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
            sendButton.topAnchor.constraint(equalTo: inputaccessoryView.topAnchor).isActive = true
            
            messageTextView.topAnchor.constraint(equalTo: inputaccessoryView.topAnchor, constant: 8).isActive = true
            messageTextView.leadingAnchor.constraint(equalTo: inputaccessoryView.leadingAnchor, constant: 8).isActive = true
            messageTextView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8).isActive = true
            messageTextView.bottomAnchor.constraint(equalTo: inputaccessoryView.layoutMarginsGuide.bottomAnchor, constant: -8).isActive = true
        }
        return inputaccessoryView
    }
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    
    lazy var messageTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 20)
        tv.sizeToFit()
        tv.delegate = self
        tv.layer.borderColor = UIColor.gray.cgColor
        tv.layer.borderWidth = 1
        return tv
    }()
    
    
    func observeMessages() {
        
        var messagesArray = [Message]()
        guard let fromId = Auth.auth().currentUser?.uid else {return}
        guard let toId = self.post?.uid else {return}
        guard let postId = self.post?.postId else {return}
        
        let messagesRef = Database.database().reference().child("messages")
        messagesRef.child(fromId).child(toId).child(postId).observe(.childAdded) { (snap) in
            guard let messageDictionary = snap.value as? [String : Any] else {return}
            let message = Message(dictionary: messageDictionary)
            self.messages.append(message)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
//        messageDictionary.forEach({ (key, value) in
//            let dictionary = value as! [String : Any]
//            let message = Message(dictionary: dictionary)
//            messagesArray.append(message)
//        })
//        DispatchQueue.main.async {
//            self.messages.removeAll()
//            self.messages = messagesArray
//            self.tableView.reloadData()
//        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewMessageController.messageCellID, for: indexPath) as! MessageCell
        let message = self.messages[indexPath.row]
        cell.message = message
        return cell
    }
}

//MARK: - Objective Methods
extension NewMessageController {
    
    @objc func handleSend() {
        
        guard let fromId = Auth.auth().currentUser?.uid else {return}
        guard let sellerId = self.post?.uid else {return}
        guard let postID = self.post?.postId else {return}
        guard let messageText = messageTextView.text else {return}
        let timeStamp = Date().timeIntervalSinceReferenceDate
        
        let values: [String : Any] = ["messageText" : messageText,
                                      "fromId" : fromId,
                                      "toId" : sellerId,
                                      "timeStamp" : timeStamp,
                                      "postID" : postID
        ]
        
        let messagesRef = Database.database().reference().child("messages")
        messagesRef.child(fromId).child(sellerId).child(postID).childByAutoId().updateChildValues(values)
        
        messagesRef.child(sellerId).child(fromId).child(postID).childByAutoId().updateChildValues(values)
    }
}


extension NewMessageController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            sendButton.isEnabled = false
        } else {
            sendButton.isEnabled = true
        }
    }
    
}


class Customview: UIView {
    
    override var intrinsicContentSize: CGSize {
        return CGSize.zero
    }
}

























//class NewMessageController: UIViewController {
//
//    private let messageCell = "messageCell"
//
//    var post: Post? {
//        didSet {
//            navigationItem.title = post?.title
//        }
//    }
//
//    var user: User? {
//        didSet {
//        }
//    }
//
//    var message: Message? {
//        didSet {
//        }
//    }
//
//    var messages = [Message]()
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.tabBarController?.tabBar.isHidden = true
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.tabBarController?.tabBar.isHidden = false
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.backgroundColor = .white
//        tableView.register(MessageCell.self, forCellReuseIdentifier: messageCell)
//        tableView.separatorStyle = .none
//        tableView.keyboardDismissMode = .interactive
//        settingLayout()
//    }
//
//    func observeMessages(post: Post?, user: User?) {
//
//    }
//
//    lazy var tableView: UITableView = {
//        let tv = UITableView()
//        tv.delegate = self
//        tv.dataSource = self
//        tv.translatesAutoresizingMaskIntoConstraints = false
//        return tv
//    }()
//
//    lazy var messageTextField: UITextField = {
//        let texField = UITextField()
//        texField.placeholder = "Enter Message..."
//        texField.delegate = self
//        texField.borderStyle = .roundedRect
//        texField.translatesAutoresizingMaskIntoConstraints = false
//        return texField
//    }()
//
//    let sendButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(#imageLiteral(resourceName: "icons8-send-letter-100").withRenderingMode(.alwaysOriginal), for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
////        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
//        return button
//    }()
//
//    func settingLayout() {
//        view.addSubview(tableView)
//        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
//
//
//        let stackView = UIStackView(arrangedSubviews: [messageTextField, sendButton])
//        stackView.axis = .horizontal
//        stackView.spacing = 8
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.distribution = .fillProportionally
//
//        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
//        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
//        stackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//
//    }
//}
//
//extension NewMessageController: UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return messages.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: messageCell, for: indexPath) as! MessageCell
//        let message = messages[indexPath.row]
//        cell.message = message
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//}
//
//extension NewMessageController: UITextFieldDelegate {
//
//
//
//}
