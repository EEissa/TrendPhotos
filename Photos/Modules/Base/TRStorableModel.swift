//
//  TRStorableModel.swift
//  Photos
//
//  Created by Essam on 01/02/2022.
//


import RealmSwift
import ObjectMapper
import Realm
import Realm.Private

protocol RealmStorable   {
    static func storedObject(withPrimary key: Any) -> Self?
}

extension RealmStorable where Self: TRStorableModel {
    static func storedObject(withPrimary key: Any) -> Self? { return TRStorableModel._storedObject(withPrimary: key) }
    static func storedObjects(_ query: NSPredicate? = nil) -> [Self] { return TRStorableModel._storedObjects(query) }
}

class TRStorableModel: Object, Mappable, RealmStorable {
    required convenience public init?(map: Map) { self.init() }
    public func mapping(map: Map) {  id <- map["id"] }
    @objc dynamic var id: String = ""

    override class func primaryKey() -> String? {
        "id"
    }
    
    required convenience public init(_ value: Any) {
        self.init()
        RLMInitializeWithValue(self, value, .partialPrivateShared())
    }

    fileprivate static func _storedObject<T: TRStorableModel >(withPrimary key: Any) -> T? {
        let realm = try! Realm()
        let object = realm.object(ofType: T.self, forPrimaryKey: key)
        if let _object = object {
            return T.init(_object)
        }
        return nil
    }
    
    fileprivate static func _storedObjects<T: TRStorableModel>(_ query: NSPredicate? = nil) -> [T] {
        let realm = try! Realm()
        var results: Results<T>
        if let _query = query {  results = realm.objects(T.self).filter(_query) } else { results = realm.objects(T.self) }
        return results.map { T.init($0) }
    }
    
    func saveToRealm()  {
        let realm = try! Realm()
        try! realm.write {
            realm.add(type(of: self).init(self), update: .modified)
        }
    }
    
    func removeFromRealm() {
        if let realm = self.realm {
            try! realm.write {
                realm.delete(self)
            }
        } else {
            let realm = try! Realm()
            if let pk = type(of: self).primaryKey(), let value = self.value(forKey: pk) {
                if let objectToBeDeleted = realm.object(ofType: type(of: self), forPrimaryKey: value) {
                    if let realm = objectToBeDeleted.realm {
                        try! realm.write {
                            realm.delete(objectToBeDeleted)
                        }
                    }
                }
            }
        }
    }

    public func detached() -> Self {
        let detached = type(of: self).init(self)
        return detached
    }
}
