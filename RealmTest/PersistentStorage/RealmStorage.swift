//
//  RealmStorage.swift
//  RealmTest
//
//  Created by Jaewon on 2022/06/22.
//

import Foundation
import RealmSwift

final class RealmStorage {
    
    private var realm: Realm
    
    init() {
        self.realm = try! Realm()
        
        print(realm.configuration.fileURL!)
    }
    
    func save(item: Item) {
        try! realm.write {
            realm.add(item)
        }
    }
    
    func bindTo(behavior: @escaping (Results<Item>) -> Void) -> NotificationToken {
        let items = realm.objects(Item.self)
        
        return items.observe { changes in
            switch changes {
            case .initial(let items):
                behavior(items)
            case .update(let items, let deletions, let insertions, let modifications):
                behavior(items)
                
                print("Deleted indices: ", deletions)
                print("Inserted indices: ", insertions)
                print("Modified modifications: ", modifications)
            case .error(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
}
