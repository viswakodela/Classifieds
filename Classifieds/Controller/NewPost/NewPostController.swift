//
//  NewPostController.swift
//  Classifieds
//
//  Created by Viswa Kodela on 12/26/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import BSImagePicker
import Photos


class CustiomeImagePicker: UIImagePickerController {
    var button: UIButton?
}

class NewPostController: UITableViewController, ChooseCategoryDelegate, MapControllerDelegate {
    
    
    var imageAssets = [PHAsset]()
    var photosArray = [UIImage]()
    
    var post: Post?
    var cell: NewPostCell3?
    var user: User?
    
    private let cellId = "cellId"
    private let newPost1CellId = "newPost1CellId"
    private let newPost2CellId = "newPost2CellId"
    private let newPost3CellId = "newPost3CellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        self.post = Post()
        fetchUser()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(savePostToFirebase))
    }
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("users").document(uid).getDocument { (snap, err) in
            guard let userDictionary = snap?.data() else {return}
            self.user = User(dictionary: userDictionary)
//            guard let uid = Auth.auth().currentUser?.uid else {return}
            self.post?.uid = self.user?.uid
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "icons8-google-images-100").withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        button.backgroundColor = .white
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    
    lazy var image1Button = createButton(selector: #selector(imageButtonsImagePicker))
    lazy var image2Button = createButton(selector: #selector(imageButtonsImagePicker))
    lazy var image3Button = createButton(selector: #selector(imageButtonsImagePicker))
    lazy var image4Button = createButton(selector: #selector(imageButtonsImagePicker))
    lazy var image5Button = createButton(selector: #selector(imageButtonsImagePicker))
    
    lazy var footer: UIView = {
        let footer = UIView()
        footer.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
//        footer.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [image1Button, image2Button, image3Button, image4Button, image5Button])
        image2Button.isHidden = true
        image3Button.isHidden = true
        image4Button.isHidden = true
        image5Button.isHidden = true
        
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false

        footer.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: footer.topAnchor, constant: 8).isActive = true
        stackView.leadingAnchor.constraint(equalTo: footer.leadingAnchor, constant: 8).isActive = true
        stackView.trailingAnchor.constraint(equalTo: footer.trailingAnchor, constant: -8).isActive = true
        stackView.bottomAnchor.constraint(equalTo: footer.bottomAnchor, constant: -8).isActive = true
        
        return footer
    }()
    
    @objc func imageButtonsImagePicker(button: UIButton) {
        
        let vc = BSImagePickerViewController()
        vc.maxNumberOfSelections = 5
        self.bs_presentImagePickerController(vc, animated: true, select: { (PHAsset) in
            
        }, deselect: { (PHAsset) in
            
        }, cancel: { ([PHAsset]) in
            
        }, finish: { (assets) in
            for i in 0..<assets.count {
                self.imageAssets.append(assets[i])
            }
            self.convertAssetsintoImages()
        }, completion: nil)
    }
    
    func convertAssetsintoImages() {
        if imageAssets.count != 0 {
            for asset in imageAssets {
                let manager = PHImageManager.default()
                let options = PHImageRequestOptions()
                var thumbnail = UIImage()
                options.isSynchronous = true
                
                manager.requestImage(for: asset, targetSize: CGSize(width: 1600, height: 900), contentMode: .aspectFill, options: options) { (image, info) in
                    guard let image = image else {return}
                    thumbnail = image
                }
//                guard let data = thumbnail.jpegData(compressionQuality: 0.4) else {return}
//                guard let newImage = UIImage(data: data) else {return}
                self.photosArray.append(thumbnail)
            }
            
            DispatchQueue.main.async {
                
                
                
                var buttonsArray = [self.image1Button, self.image2Button, self.image3Button, self.image4Button, self.image5Button]
                
                
                for image in self.photosArray {
                    for button in buttonsArray {
                        if let imageIndex = self.photosArray.firstIndex(of: image), let buttonIndex = buttonsArray.firstIndex(of: button) {
                            
                            if imageIndex == buttonIndex {
                                buttonsArray[buttonIndex].setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
                                
                                
                                let count = self.photosArray.count
                                
                                for element in 0...count - 1 {
                                    buttonsArray.forEach({ (but) in
                                        if element > count {
                                            return
                                        }
                                        buttonsArray[element].isHidden = false
                                    })
                                }
                                
                                let fileName = UUID().uuidString
                                let ref = Storage.storage().reference().child("postImages").child(fileName)
                                
                                let hud = JGProgressHUD(style: .dark)
                                hud.textLabel.text = "Uploading Image"
                                hud.show(in: self.view)
                                
                                self.image1Button.isEnabled = false
                                self.image2Button.isEnabled = false
                                self.image3Button.isEnabled = false
                                self.image4Button.isEnabled = false
                                self.image5Button.isEnabled = false
                                
                                guard let uploadData = image.jpegData(compressionQuality: 1) else {return}
                                
                                ref.putData(uploadData, metadata: nil, completion: { (metadata, err) in
                                    hud.dismiss()
                                    if let error = err {
                                        self.showProgressHUD(error: error)
                                        return
                                    }
                                    
                                    ref.downloadURL(completion: { (url, err) in
                                        if let error = err {
                                            self.showProgressHUD(error: error)
                                            return
                                        }
                                        
                                        if button == self.image1Button {
                                            self.post?.imageUrl1 = url?.absoluteString
                                        } else if button == self.image2Button {
                                            self.post?.imageUrl2 = url?.absoluteString
                                        } else if button == self.image3Button {
                                            self.post?.imageUrl3 = url?.absoluteString
                                        } else if button == self.image4Button {
                                            self.post?.imageUrl4 = url?.absoluteString
                                        } else {
                                            self.post?.imageUrl5 = url?.absoluteString
                                        }
                                        
                                    })
                                })
                            }
                        }
                    }
                }
            }
        }
    }
    
    func showProgressHUD(error: Error) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Registration Failed"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }
    
    static let newPostUpdateNotification = Notification.Name("newPostUpdate")
    
    @objc fileprivate func savePostToFirebase() {
        
        if post?.title == nil || post?.description == nil || post?.location == nil {
            let hud = JGProgressHUD(style: .dark)
            hud.textLabel.text = "Some fields are empty, Please check your entries"
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2)
            return
        }
        
        guard let uid = user?.uid else {return}
        self.post?.date = Date().timeIntervalSinceReferenceDate
        let postId = UUID().uuidString
        self.post?.postId = postId
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Posting the ad"
        hud.show(in: self.view)
        
        let postData: [String : Any] = [
            "title" : self.post?.title,
            "description" : self.post?.description,
            "price" : self.post?.price,
            "categoryName" : self.post?.categoryName,
            "location" : self.post?.location,
            "uid" : self.post?.uid,
            "imageUrl1" : self.post?.imageUrl1,
            "imageUrl2" : self.post?.imageUrl2,
            "imageUrl3" : self.post?.imageUrl3,
            "imageUrl4" : self.post?.imageUrl4,
            "imageUrl5" : self.post?.imageUrl5,
            "date" : self.post?.date,
            "postId" : self.post?.postId
        ]
        
//        Database.database().reference().child("posts").child(postId).updateChildValues(postData)
    Firestore.firestore().collection("posts").document(uid).collection("userPosts").document(postId).setData(postData) { (err) in
            if let error = err {
                print(error)
            }
        hud.dismiss(afterDelay: 3, animated: true)
        }
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: NewPostController.newPostUpdateNotification, object: nil)
        }
    }
    
    fileprivate func setupLayout() {
        tableView.keyboardDismissMode = .interactive
        navigationItem.title = "Add Listing"
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleCancel))
        tableView.register(NewPostCell1.self, forCellReuseIdentifier: newPost1CellId)
        tableView.register(NewPostCell2.self, forCellReuseIdentifier: newPost2CellId)
        tableView.register(NewPostCell3.self, forCellReuseIdentifier: newPost3CellId)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleTitleChange(textField: UITextField) {
        self.post?.title = textField.text
    }
    
    @objc func handlePriceButton() {
        var textFild = UITextField()
        let alert = UIAlertController(title: "Enter Price (e.g. $150)", message: "", preferredStyle: .alert)
        let cancelaction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter"
            textFild = textField
        }
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            guard let text = textFild.text else {return}
            let priceText = Int(text)
            let indexPath = IndexPath(row: 0, section: 2)
            self.cell = self.tableView.cellForRow(at: indexPath) as? NewPostCell3

            if priceText == nil {
                self.cell?.textField.text = nil
            } else {
                self.cell?.textField.text = "$\(text)"
                self.tableView.reloadData()
            }
            self.post?.price = priceText
        }
        alert.addAction(cancelaction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func handleCategoryButton() {
        let chooseCategoryController = ChooseCategoryController()
        chooseCategoryController.delegate = self
        let navBarChooseController = UINavigationController(rootViewController: chooseCategoryController)
        present(navBarChooseController, animated: true, completion: nil)
    }
    
    func didChooseCategory(categoryName: String) {
        let indexPath = IndexPath(row: 0, section: 3)
        self.cell = self.tableView.cellForRow(at: indexPath) as? NewPostCell3
        cell?.textField.text = categoryName
        self.post?.categoryName = categoryName
        self.tableView.reloadData()
    }

    
    @objc func handleLocationButton() {
        let mapController = MapViewController()
        mapController.delegate = self
        let navController = UINavigationController(rootViewController: mapController)
        present(navController, animated: true)
    }
    
    func didTapRow(title: String, subtitle: String) {
        let indexPath = IndexPath(row: 0, section: 4)
        self.cell = self.tableView.cellForRow(at: indexPath) as? NewPostCell3
        cell?.textField.text = "\(title) \(subtitle)"
        self.post?.location = "\(title) \(subtitle)"
        self.tableView.reloadData()
    }
}

extension NewPostController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 5 {
            return 0
        }
        return indexPath.section == 1 ? 70 : 50
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = HeaderLabel()
        header.backgroundColor = .white
        header.font = UIFont.boldSystemFont(ofSize: 20)
        
        switch section {
        case 0:
            header.text = "Title"
            break
        case 1:
            header.text = "Description"
            break
        case 2:
            header.text = "Price"
            break
        case 3:
            header.text = "Category"
            break
        case 4:
            header.text = "Location"
        default:
            header.text = "Images"
        }
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 5 {
            return footer
        }
        let view = UIView()
        view.backgroundColor = .white
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 5 {
            return 80
        }
        return 30
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 5 ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: newPost1CellId, for: indexPath) as! NewPostCell1
            cell.textField.addTarget(self, action: #selector(handleTitleChange), for: .editingChanged)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: newPost2CellId, for: indexPath) as! NewPostCell2
            cell.textView.delegate = self
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: newPost3CellId, for: indexPath) as! NewPostCell3
            cell.textField.addTarget(self, action: #selector(handlePriceButton), for: .allEvents)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: newPost3CellId, for: indexPath) as! NewPostCell3
            cell.textField.addTarget(self, action: #selector(handleCategoryButton), for: .allEvents) 
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: newPost3CellId, for: indexPath) as! NewPostCell3
            cell.textField.addTarget(self, action: #selector(handleLocationButton), for: .allEvents)
            return cell
        }
    }
}

extension NewPostController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor ==  .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.post?.description = textView.text
    }
}

//extension NewPostController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//
//
//        let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
//        let imageButton = (picker as? CustiomeImagePicker)?.button
//        imageButton?.setImage(editedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
//        self.dismiss(animated: true, completion: nil)
//
//        let fileName = UUID().uuidString
//        let ref = Storage.storage().reference().child("postImages").child(fileName)
//
//        let hud = JGProgressHUD(style: .dark)
//        hud.textLabel.text = "Uploading Image"
//        hud.show(in: view)
//
//        guard let uploadData = editedImage?.jpegData(compressionQuality: 0.8) else {return}
//
//        ref.putData(uploadData, metadata: nil) { (data, err) in
//            hud.dismiss()
//            if let error = err {
//                self.showProgressHUD(error: error)
//                return
//            }
//            print("Finish uploading the Image")
//
//            ref.downloadURL { (url, err) in
//                if let error = err {
//                    self.showProgressHUD(error: error)
//                    return
//                }
//
//                if imageButton == self.image1Button {
//                    self.post.imageUrl1 = url?.absoluteString
//                } else if imageButton == self.image2Button {
//                    self.post.imageUrl2 = url?.absoluteString
//                } else if imageButton == self.image3Button {
//                    self.post.imageUrl3 = url?.absoluteString
//                } else if imageButton == self.image4Button {
//                    self.post.imageUrl4 = url?.absoluteString
//                } else {
//                    self.post.imageUrl5 = url?.absoluteString
//                }
//            }
//        }
//    }
//}
