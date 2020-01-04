//
//  ViewController.swift
//  AddImageTest
//
//  Created by Francis Jemuel Bergonia on 1/4/20.
//  Copyright © 2020 Xi Apps. All rights reserved.
//

import UIKit
import RealmSwift

class PhotosVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var photos: Results<Photo>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPhotos()
    }
    
    func loadPhotos() {
        if let fetchedPhotos = RealmHelper.getAllPhotos() {
            photos = fetchedPhotos
        }
        tableView.reloadData()
    }
}

extension PhotosVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numPhotos = photos {
            return numPhotos.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if let index = photos {
            let currentPhoto = index[indexPath.row]
            if let photo = currentPhoto.photoImg {
                cell.imageView?.image = UIImage(data: photo as Data)
            }
            cell.textLabel?.text = currentPhoto.photoName
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let photoToDelete = photos {
                let selectedPhoto = photoToDelete[indexPath.row]
                RealmHelper.deletePhoto(photo: selectedPhoto)
                loadPhotos()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedPhoto = photos?[indexPath.row] {
            performSegue(withIdentifier: "updatePhoto", sender: selectedPhoto)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updatePhoto" {
            if let destinationVC = segue.destination as? UpdatePhotoVC {
                if let passedPhoto = sender as? Photo {
                    destinationVC.passedPhoto = passedPhoto
                }
            }
        }
    }
}
