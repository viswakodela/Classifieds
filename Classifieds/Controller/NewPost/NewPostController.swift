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
import MapKit



class NewPostController: UITableViewController {
    
    //MARK: - Cell Identifiers
    private static let titleCell = "titleCell"
    private static let textViewCell = "textViewCell"
    private static let newPostPriceCategoryImagesCellId = "newPostPriceCategoryImagesCellId"
    
    //MARK: - Constants
    private let locationManager = CLLocationManager()
    static let newPostUpdateNotification = Notification.Name("newPostUpdate")
    
    lazy var image1Button = createButton(selector: #selector(imageButtonsImagePicker))
    lazy var image2Button = createButton(selector: #selector(imageButtonsImagePicker))
    lazy var image3Button = createButton(selector: #selector(imageButtonsImagePicker))
    lazy var image4Button = createButton(selector: #selector(imageButtonsImagePicker))
    lazy var image5Button = createButton(selector: #selector(imageButtonsImagePicker))
    
    //MARK: - Variables
    var imageAssets = [PHAsset]()
    var photosArray = [UIImage]()
    var post = Post()
    var cell: NewpostPriceCategoryLocationCell?
    var user: User?
    var currentLocation: String?
    
    //MARk: -  Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        fetchUser()
        navigationBarSetup()
        checkPermission()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: -  Layout Properties
    lazy var footer: UIView = {
        let footer = UIView()
        footer.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
        
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
    
    
    //MARK: -  Methods
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Database.database().reference().child("users").child(uid).observe(.value) { (snap) in
            guard let snapDict = snap.value as? [String : Any] else {return}
            let user = User(dictionary: snapDict)
            self.post.uid = user.uid
            self.user = user
        }
    }
    
    func navigationBarSetup() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(savePostToFirebase))
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
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                var buttonsArray = [self.image1Button, self.image2Button, self.image3Button, self.image4Button, self.image5Button]
                
                
                for image in self.photosArray {
                    for button in buttonsArray {
                        if let imageIndex = self.photosArray.firstIndex(of: image), let buttonIndex = buttonsArray.firstIndex(of: button) {
                            
                            let hud = JGProgressHUD(style: .dark)
                            if imageIndex == buttonIndex {
                                
                                DispatchQueue.main.async {
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
                                    
                                    self.image1Button.isEnabled = false
                                    self.image2Button.isEnabled = false
                                    self.image3Button.isEnabled = false
                                    self.image4Button.isEnabled = false
                                    self.image5Button.isEnabled = false
                                    
                                    hud.textLabel.text = "Uploading Image"
                                    hud.show(in: self.view)
                                }
                                
                                let fileName = UUID().uuidString
                                let ref = Storage.storage().reference().child("postImages").child(fileName)
                                
                                
                                
                                
                                
                                
                                guard let uploadData = image.jpegData(compressionQuality: 0.7) else {return}
                                
                                ref.putData(uploadData, metadata: nil, completion: { [weak self] (metadata, err) in
                                    
                                    DispatchQueue.main.async {
                                        hud.dismiss()
                                    }
                                    guard let self = self else {return}
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
                                            self.post.imageUrl1 = url?.absoluteString
                                        } else if button == self.image2Button {
                                            self.post.imageUrl2 = url?.absoluteString
                                        } else if button == self.image3Button {
                                            self.post.imageUrl3 = url?.absoluteString
                                        } else if button == self.image4Button {
                                            self.post.imageUrl4 = url?.absoluteString
                                        } else {
                                            self.post.imageUrl5 = url?.absoluteString
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
    
    @objc fileprivate func savePostToFirebase() {
        
        if post.title == nil || post.description == nil || post.location == nil || post.imageUrl1 == nil {
            let hud = JGProgressHUD(style: .dark)
            hud.textLabel.text = "Some fields are empty, Please check your entries"
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2)
            return
        }
        
        guard let uid = user?.uid else {return}
        //        self.post.date = Date.timeIntervalSinceReferenceDate
        let postId = UUID().uuidString
        self.post.postId = postId
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Posting the ad"
        hud.show(in: self.view)
        
        let postData: [String : Any] = [
            "title" : self.post.title ?? "No Title",
            "description" : self.post.description ?? "No Description",
            "price" : self.post.price ?? 0,
            "categoryName" : self.post.categoryName ?? "No Category",
            "location" : self.post.location ?? "No Location",
            "uid" : self.post.uid ?? "",
            "imageUrl1" : self.post.imageUrl1,
            "imageUrl2" : self.post.imageUrl2,
            "imageUrl3" : self.post.imageUrl3,
            "imageUrl4" : self.post.imageUrl4,
            "imageUrl5" : self.post.imageUrl5,
            "date" : Date.timeIntervalSinceReferenceDate,
            "postId" : self.post.postId ?? ""
        ]
        
        guard let postLocation = post.location else {return}
        
        //        guard let location = MapSearchHelper.searchText(search: postLocation) else {return}
        
        // searchRequest is to get the location of the Post
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = postLocation
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { (resp, err) in
            if let error = err {
                print(error.localizedDescription)
            }
            guard let response = resp?.mapItems else{return}
            guard let city = response.first?.placemark.locality else {return}
            
        Database.database().reference().child("cities").child(city).childByAutoId().updateChildValues(postData)
            
        Database.database().reference().child("posts").child(uid).childByAutoId().updateChildValues(postData)
            
            self.dismiss(animated: true) {
                NotificationCenter.default.post(name: NewPostController.newPostUpdateNotification, object: nil)
            }
        }
    }
    
    fileprivate func setupLayout() {
        tableView.keyboardDismissMode = .interactive
        navigationItem.title = "Add Listing"
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleCancel))
        tableView.register(TitleTextFieldCell.self, forCellReuseIdentifier: NewPostController.titleCell)
        tableView.register(TextViewCell.self, forCellReuseIdentifier: NewPostController.textViewCell)
        tableView.register(NewpostPriceCategoryLocationCell.self, forCellReuseIdentifier: NewPostController.newPostPriceCategoryImagesCellId)
    }
    
    deinit {
        print("NewPostController Deinitialized")
    }
}


//MARK: - TableView Delegate methods
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
            let cell = tableView.dequeueReusableCell(withIdentifier: NewPostController.titleCell, for: indexPath) as! TitleTextFieldCell
            cell.textField.addTarget(self, action: #selector(handleTitleChange), for: .editingChanged)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewPostController.textViewCell, for: indexPath) as! TextViewCell
            cell.textView.delegate = self
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewPostController.newPostPriceCategoryImagesCellId, for: indexPath) as! NewpostPriceCategoryLocationCell
            cell.textField.addTarget(self, action: #selector(handlePriceButton), for: .allEvents)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewPostController.newPostPriceCategoryImagesCellId, for: indexPath) as! NewpostPriceCategoryLocationCell
            cell.textField.addTarget(self, action: #selector(handleCategoryButton), for: .allEvents)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewPostController.newPostPriceCategoryImagesCellId, for: indexPath) as! NewpostPriceCategoryLocationCell
            cell.textField.addTarget(self, action: #selector(handleLocationButton), for: .allEvents)
            return cell
        }
    }
}

//MARK: - TextViewDelegate Methods
extension NewPostController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor ==  .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.post.description = textView.text
    }
}


//MARK: - LocationManager Delegate MNethods
extension NewPostController: CLLocationManagerDelegate {
    
    func checkPermission() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            checkLocationAuthorization()
            //            locationManager.startUpdatingLocation()
        } else {
            print("Check the location Services")
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            locationManager.requestLocation()
            break
        case .authorizedWhenInUse:
            locationManager.requestLocation()
            // DO Map Stuff
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .denied:
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.checkLocationAuthorization()
    }

}

//MARK: - Selector objective Functions
extension NewPostController {
    
    
    //For title change
    @objc func handleTitleChange(textField: UITextField) {
        self.post.title = textField.text
    }
    
    //For Category Change
    @objc func handleCategoryButton() {
        let chooseCategoryController = ChooseCategoryController()
        chooseCategoryController.delegate = self
        let navBarChooseController = UINavigationController(rootViewController: chooseCategoryController)
        present(navBarChooseController, animated: true, completion: nil)
    }
    
    //For price Change
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
            self.cell = self.tableView.cellForRow(at: indexPath) as? NewpostPriceCategoryLocationCell
            
            if priceText == nil {
                self.cell?.textField.text = nil
            } else {
                self.cell?.textField.text = "$\(text)"
                self.tableView.reloadData()
            }
            self.post.price = priceText
        }
        alert.addAction(cancelaction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //For Location Change
    @objc func handleLocationButton() {
        let mapController = MapViewController()
        mapController.delegate = self
        let navController = UINavigationController(rootViewController: mapController)
        present(navController, animated: true)
    }
    
    //For Images
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
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - Choose Category Delegate
extension NewPostController: ChooseCategoryDelegate {
    
    func didChooseCategory(categoryName: String) {
        let indexPath = IndexPath(row: 0, section: 3)
        self.cell = self.tableView.cellForRow(at: indexPath) as? NewpostPriceCategoryLocationCell
        cell?.textField.text = categoryName
        self.post.categoryName = categoryName
        self.tableView.reloadData()
    }
}

//MARK: - MApController Delegate Methods
extension NewPostController: MapControllerDelegate {
    
    func didTapRow(title: String, subtitle: String) {
        let indexPath = IndexPath(row: 0, section: 4)
        self.cell = self.tableView.cellForRow(at: indexPath) as? NewpostPriceCategoryLocationCell
        cell?.textField.text = "\(title) \(subtitle)"
        self.post.location = "\(title) \(subtitle)"
        self.tableView.reloadData()
    }
}
