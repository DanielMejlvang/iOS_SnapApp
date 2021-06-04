//
//  MyImagePicker.swift
//  SnapApp
//
//  Created by Daniel Mejlvang Rasmussen on 21/05/2021.
//

import UIKit

class MyImagePicker: UIImagePickerController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var parentVC:Updatable?
    
    override func viewDidLoad() {
        //tell super controller that it has delegated work to another
        super.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //need to dismiss view before sending picture
        //as subsequent alert can't open on top of image picker
        picker.dismiss(animated: true, completion: nil)
        if let img = info[.originalImage] as? UIImage {
            parentVC?.update(obj: img) //only if object is value
            //will never throw null pointer exception
        }
    }
}
