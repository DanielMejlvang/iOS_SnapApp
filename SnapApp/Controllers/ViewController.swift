//
//  ViewController.swift
//  SnapApp
//
//  Created by Daniel Mejlvang Rasmussen on 20/05/2021.
//

import UIKit
import MapKit

let fbs = FirebaseService()
var dataSource = SnapTableView()

class ViewController: UIViewController, CLLocationManagerDelegate, Updatable {
    @IBOutlet weak var snapTableView: UITableView!
    @IBOutlet weak var userTextField: UITextField!
    
    var myImagePicker = MyImagePicker()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        snapTableView.dataSource = dataSource
        
        fbs.parent = self
        fbs.storageRef = fbs.storage.reference()
        fbs.startListener()
        
        myImagePicker.parent_view_controller = self
        
        setupLocationManager()
    }
    
    //MARK: Segue
    //segue to specific snap from tableview
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? SnapDetail {
            let snapIndex = snapTableView.indexPathForSelectedRow?.row ?? 0
            dest.snap = fbs.snaps[snapIndex]
        }
    }
    
    //MARK: Update
    func update(obj: NSObject?) {
        //gets UIImage object when MyImagePicker returns with an image
        if let img = obj as? UIImage {
            attachMessageToPicture(img: img)
        } else {
            snapTableView.reloadData()
        }
    }
    
    //MARK: - Snap picture methods
    @IBAction func snapPicture(_ sender: UIButton) {
        myImagePicker.sourceType = .photoLibrary
        present(myImagePicker, animated: true)
    }
    
    //alert message to get user input for snap message
    func attachMessageToPicture(img: UIImage) {
        let alert = UIAlertController(title: "New snap\n\n\n\n\n\n\n\n\n\n",
                                      message: "Write a message with your snap",
                                      preferredStyle: .alert)
        
        //put image into alert
        let imageView = UIImageView(frame: CGRect(x: 40, y: 60, width: 200, height: 200))
        //ensure image is scaled, not stretched, to fit
        imageView.contentMode = .scaleAspectFit
        imageView.image = img
        alert.view.addSubview(imageView)
        //add constraint so to center image
        alert.view.addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy:  .equal, toItem: alert.view, attribute: .centerX, multiplier: 1, constant: 0))
        
        alert.addTextField { (textField) in
            textField.placeholder = "Message"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let saveAction = UIAlertAction(title: "Send", style: .default) { _ in
            let message = alert.textFields![0].text ?? ""
            let username = self.getUsername()
            let location = self.locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
            
            fbs.saveSnap(from: username, location: location, message: message, image: img)
        }
        alert.addAction(saveAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //get username from bottom label, return "Unknown" if blank
    func getUsername() -> String {
        var username: String
        if var checkUsername = userTextField.text {
            if checkUsername == "" {
                checkUsername = "Unknown"
            }
            username = checkUsername
        } else {
            username = "Unknown"
        }
        return username
    }
    
    //MARK: - Setup location manager
    func setupLocationManager() {
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
}
