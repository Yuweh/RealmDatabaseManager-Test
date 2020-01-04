//
//  AddPhotoVC.swift
//  AddImageTest
//
//  Created by Francis Jemuel Bergonia on 1/4/20.
//  Copyright © 2020 Xi Apps. All rights reserved.
//

import UIKit

class AddPhotoVC: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoText: UITextField!
    
    var pickerController = UIImagePickerController()
    
    func saveImageInDocsDir() {
        let image: UIImage? = photoImageView.image
        if !(image == nil) {
            // get the documents directory url
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentsDirectory = paths[0] // Get documents folder
            let dataPath = URL(fileURLWithPath: documentsDirectory).appendingPathComponent("ImagesFolder").absoluteString //Set folder name
            print(dataPath)
            //Check is folder available or not, if not create
            if !FileManager.default.fileExists(atPath: dataPath) {
                try? FileManager.default.createDirectory(atPath: dataPath, withIntermediateDirectories: true, attributes: nil) //Create folder if not
            }
            // Make unique name
            let uuid = UUID().uuidString
            
            // create the destination file url to save your image
            let fileURL = URL(fileURLWithPath:dataPath).appendingPathComponent("\(uuid).jpg")//Your image name
            print(fileURL)
            // get your UIImage jpeg data representation
            let data = photoImageView.image?.jpegData(compressionQuality: 0.5)//Set image quality here
            do {
                // writes the image data to disk
                try data?.write(to: fileURL, options: .atomic)
            } catch {
                print("error:", error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        pickerController.delegate = self
    }
    
    @IBAction func mediaBtnPressed(_ sender: UIBarButtonItem) {
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true) {
        }
    }
    
    @IBAction func cameraBtnPressed(_ sender: UIBarButtonItem) {
        pickerController.sourceType = .camera
        present(pickerController, animated: true) {
        }
    }
    
    @IBAction func saveBtnPressed(_ sender: UIBarButtonItem) {
        let newPhoto = Photo()
        if let title = photoText.text {
            newPhoto.photoName = title
        }
        if let image = photoImageView.image?.jpegData(compressionQuality: 0.5) {
            newPhoto.photoImg = image as NSData
        }
        RealmHelper.savePhoto(photo: newPhoto)
        navigationController?.popViewController(animated: true)
    }
}

extension AddPhotoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            photoImageView.image = image
        }
        pickerController.dismiss(animated: true, completion: nil)
    }
}

extension UIViewController {
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
