//
//  TRPhoto.swift
//  Photos
//
//  Created by Essam on 01/02/2022.
//

import RealmSwift
import ObjectMapper

class TRPhoto: TRStorableModel {
    @objc dynamic var urlFull: String = ""
    @objc dynamic var urlThumb: String = ""

    @objc dynamic var height: Double = 0.0
    @objc dynamic var width: Double = 0.0
    @objc dynamic fileprivate  var favorited: Bool = false
    
    var isFavorite: Bool {
        get {
            TRPhoto.storedObject(withPrimary: id)?.favorited ?? false
        } set {
            self.favorited = newValue
            self.saveToRealm()
        }
    }
    
    required convenience init?(map: Map) { self.init() }
    override func mapping(map: Map) {
        super.mapping(map: map)
        id     <-  map["id"]
        urlFull    <-  map["urls.raw"]
        urlThumb    <-  map["urls.thumb"]
        height <-  map["height"]
        width  <- map["width"]
        
        favorited = TRPhoto.storedObject(withPrimary: id)?.favorited ?? false
    }
}
