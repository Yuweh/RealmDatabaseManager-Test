//
//  Photo.swift
//  AddImageTest
//
//  Created by Francis Jemuel Bergonia on 1/4/20.
//  Copyright © 2020 Xi Apps. All rights reserved.
//

import Foundation
import RealmSwift

class Photo: Object {
    @objc dynamic var photoID = UUID().uuidString
    @objc dynamic var photoName = ""
    @objc dynamic var photoImg: NSData? = nil
    
    override static func primaryKey() -> String? {
        return "photoID"
    }
}
