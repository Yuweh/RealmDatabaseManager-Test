//
//  UpdatePhotoVC.swift
//  AddImageTest
//
//  Created by Francis Jemuel Bergonia on 1/4/20.
//  Copyright © 2020 Xi Apps. All rights reserved.
//

import UIKit

class UpdatePhotoVC: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoText: UITextField!
    
    var passedPhoto: Photo?
    var pickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard2()
        pickerController.delegate = self
        if let photo = passedPhoto {
            if let image = photo.photoImg {
                photoImageView.image = UIImage(data: image as Data)
            }
            photoText.text = photo.photoName
        }
    }
    
    @IBAction func mediaBtnPressed(_ sender: UIBarButtonItem) {
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true) {
        }
    }
    
    @IBAction func camerBtnPressed(_ sender: UIBarButtonItem) {
        pickerController.sourceType = .camera
        present(pickerController, animated: true) {
        }
    }
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        if let photo = passedPhoto {
            let updatePhoto = Photo()
            updatePhoto.photoID = photo.photoID
            if let image = photoImageView.image?.jpegData(compressionQuality: 0.5) {
                updatePhoto.photoImg = image as NSData
            }
            if let title = photoText.text {
                 updatePhoto.photoName = title
            }
            RealmHelper.updatePhoto(photo: updatePhoto)
            navigationController?.popViewController(animated: true)
        }
    }
}


extension UpdatePhotoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            photoImageView.image = image
        }
        pickerController.dismiss(animated: true, completion: nil)
    }
}

extension UIViewController {
    func hideKeyboard2()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard2))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard2()
    {
        view.endEditing(true)
    }
}
