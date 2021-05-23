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
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        snapTableView.dataSource = dataSource
        
        fbs.parent = self
        fbs.storageRef = fbs.storage.reference()
        fbs.startListener()
        
        myImagePicker.parentVC = self
        
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? SnapDetail {
            let snapIndex = snapTableView.indexPathForSelectedRow?.row ?? 0
            dest.snap = fbs.snaps[snapIndex]
            dest.parent_view_controller = self
        }
    }
    
    func update(obj: NSObject?) {
        if let img = obj as? UIImage {
            attachMessageToPicture(img: img)
        }
        snapTableView.reloadData()
    }
    
    var myImagePicker = MyImagePicker()
    @IBAction func snapPicture(_ sender: UIButton) {
        myImagePicker.sourceType = .photoLibrary
        myImagePicker.allowsEditing = true
        present(myImagePicker, animated: true)
    }
    
    //alert message to get user input for snap message
    func attachMessageToPicture(img: UIImage) {
        let annotationAlert = UIAlertController(title: "New snap", message: "Write a message with your snap", preferredStyle: .alert)
        annotationAlert.addTextField { (textField) in
            textField.placeholder = "Message"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            let message = annotationAlert.textFields![0].text ?? ""
            let username = self.getUsername()
            let location = self.locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
            
            fbs.saveSnap(from: username, location: location, message: message, image: img)
        }
        annotationAlert.addAction(cancelAction)
        annotationAlert.addAction(saveAction)
        present(annotationAlert, animated: true, completion: nil)
    }
    
    //grab username from bottom label, return "Unknown" if blank
    func getUsername() -> String {
        var username = "Unknown"
        if var checkUsername = userTextField.text {
            if checkUsername == "" {
                checkUsername = "Unknown"
            }
            username = checkUsername
        }
        return username
    }
}
