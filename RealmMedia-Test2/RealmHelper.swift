//
//  RealmHelper.swift
//  AddImageTest
//
//  Created by Francis Jemuel Bergonia on 1/4/20.
//  Copyright © 2020 Xi Apps. All rights reserved.
//

import Foundation
import RealmSwift

class RealmHelper {
    static let realm = try! Realm()
    
    static func getAllPhotos() -> Results<Photo>? {
        var photos: Results<Photo>?
        photos = realm.objects(Photo.self)
        let sortedPhotos = photos?.sorted(byKeyPath: "photoName", ascending: true)
        return sortedPhotos
    }
    
    static func savePhoto(photo: Photo) {
        do {
            try realm.write {
                realm.add(photo)
            }
        } catch {
            print("Error Saving Photo: \(error.localizedDescription)")
        }
    }
    
    static func updatePhoto(photo: Photo) {
        let photoData = Photo()
        photoData.photoID = photo.photoID
        photoData.photoImg = photo.photoImg
        photoData.photoName = photo.photoName
        
        do {
            try realm.write {
                realm.add(photoData)
            }
        } catch {
            print("Error Updating Photos: \(error.localizedDescription)")
        }
    }
    
    static func deletePhoto(photo: Photo) {
        do {
            try realm.write {
                realm.delete(photo)
            }
        } catch {
            print("Error Deleting Photo: \(error.localizedDescription)")
        }
    }
}
