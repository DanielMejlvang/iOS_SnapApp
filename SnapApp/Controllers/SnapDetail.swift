//
//  SnapDetail.swift
//  SnapApp
//
//  Created by Daniel Mejlvang Rasmussen on 21/05/2021.
//

import Foundation
import UIKit
import MapKit

class SnapDetail: UIViewController {
    var parent_view_controller:ViewController? = nil
    var snap = Snap(id: "", from: "", latitude: 0, longitude: 0, message: "")
    
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fromLabel.text = "From \(snap.from ?? "Unknown")"
        messageLabel.text = snap.message
        
        setupMapView()
        loadImageFromFirebase()
    }
    
    func setupMapView() {
        let marker = MKPointAnnotation()
        marker.title = "Sent from here"
        let sentLocation = CLLocationCoordinate2D(latitude: snap.latitude ?? 0, longitude: snap.longitude ?? 0)
        marker.coordinate = sentLocation
        mapView.addAnnotation(marker)
        mapView.centerCoordinate = sentLocation
    }
    
    func loadImageFromFirebase(){
        let imageRef = fbs.storageRef?.child("examsnaps" + "/" + snap.id + ".jpg")
        
        imageRef?.downloadURL { (url, error) in
            if error != nil {
                print((error?.localizedDescription)!)
                print("This snap doesn't have a picture")
                return
            } else {
                self.setImage(url: url!)
            }
        }
    }
    
    func setImage(url: URL) {
        print(url.absoluteString)
        //just to not cause a deadlock in UI
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url)
            else {
                print("URL was somehow not an image")
                return
            }
            
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("you gettin deleted")
    }
}
