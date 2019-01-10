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
    
    var post: Post! {
        didSet {
            
            
        }
    }
    
    var user: User! {
        didSet {
            observeMessages()
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
    
    func observeMessages() {
        navigationItem.title = self.user.name
        guard let fromId = Auth.auth().currentUser?.uid else {return}
        guard let toId = self.user?.uid else {return}
        
        let usermessagesRef = Database.database().reference().child("userMessages").child(fromId).child(toId)
        usermessagesRef.observe(.childAdded) { (snap) in
            let messageId = snap.key
            
            let messageRef = Database.database().reference().child("messages").child(messageId)
            messageRef.observe(.value, with: { (snap) in
                let message = Message(dictionary: snap.value as! [String : Any])
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
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSend() {
        print("Sending")
        
        guard let fromId = Auth.auth().currentUser?.uid else {return}
        guard let text = messageTextField.text else {return}
        if messageTextField.text == "" {
            return
        }
        guard let toId = self.user?.uid else {return}
        let timeStamp = Int(Date().timeIntervalSinceReferenceDate)
        let values: [String : Any] = ["messageText" : text, "fromId" : fromId, "toId" : toId, "timeStamp" : timeStamp]
        
        let databaseref = Database.database().reference().child("messages")
        let childRef = databaseref.childByAutoId()
        
        childRef.updateChildValues(values) { (err, ref) in
            self.messageTextField.text = nil
            if let error = err {
                print(error.localizedDescription)
            }
            let messageRef = Database.database().reference().child("userMessages").child(fromId).child(toId)
            let messageId = childRef.key
            let value = [messageId : 1]
            messageRef.updateChildValues(value, withCompletionBlock: { (err, _) in
                if let error = err {
                    print(error.localizedDescription)
                }
            })
        }
    }
    
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
