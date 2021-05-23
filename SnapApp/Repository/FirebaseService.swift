//
//  FirebaseService.swift
//  SnapApp
//
//  Created by Daniel Mejlvang Rasmussen on 20/05/2021.
//

import Foundation
import Firebase
import FirebaseStorage
import MapKit

class FirebaseService {
    private var db = Firestore.firestore()
    private var COLLECTION_PATH = "examsnaps"
    
    var storage = Storage.storage()
    var storageRef:StorageReference?
    
    var snaps = [Snap]()
    
    var parent:Updatable?
    
    func startListener() {
        //listen to changes to collection -> get entire updated collection
        db.collection(COLLECTION_PATH).addSnapshotListener { (snap, error) in
            if let e = error {
                print("Error in fetching data: \(e)")
            } else {
                if let s = snap {
                    self.snaps.removeAll()
                    for doc in s.documents {
                        let from = doc.data()["from"] as? String ?? "Unknown"
                        
                        let location = doc.data()["location"] as! GeoPoint
                        
                        let message = doc.data()["message"] as? String ?? ""
                        
                        let snap = Snap(id: doc.documentID, from: from, latitude: location.latitude, longitude: location.longitude, message: message)
                        self.snaps.append(snap)
                    }
                    self.parent?.update(obj: nil)
                }
            }
        }
    }
    
    func saveSnap(from: String, location: CLLocationCoordinate2D, message: String, image: UIImage) {
        let doc = db.collection(COLLECTION_PATH).document()
        var data = [String:Any]()
        data["from"] = from
        data["location"] = GeoPoint(latitude: location.latitude, longitude: location.longitude)
        data["message"] = message
        doc.setData(data)
        
        uploadImage(image: image, name: doc.documentID)
    }
    
    func uploadImage(image:UIImage, name:String) {
        print("Uploading picture... This could take a while: \(image.size)")
        if let data = image.jpegData(compressionQuality: 0.5) {
            if let imageRef = storageRef?.child(COLLECTION_PATH + "/" + name + ".jpg") {
                imageRef.putData(data, metadata: nil, completion: { (metadata, error) in
                    if let e = error {
                        print("Error upload image \(e)")
                    } else {
                        print("Uploaded image")
                    }
                })
            } else {
                print("Error in storage reference.")
            }
        }
    }
    
    func deleteSnap(id: String) {
        //delete document in Firestore
        db.collection(COLLECTION_PATH).document(id).delete(){ error in
            if let error = error {
                print("Delete document: Failure = \(error.localizedDescription)")
            } else {
                print("Delete document: Success")
            }
        }
        
        //delete image in Storage
        let imageRef = storageRef?.child(COLLECTION_PATH + "/" + id + ".jpg")
        imageRef?.delete { error in
          if let error = error {
            print("Delete image: Failure = \(error.localizedDescription)")
          } else {
            print("Delete image: Success")
          }
        }
    }
}
