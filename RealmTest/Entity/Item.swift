//
//  Item.swift
//  RealmTest
//
//  Created by Jaewon on 2022/06/22.
//

import Foundation
import RealmSwift

final class Item: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var content: String
    
    convenience init(content: String) {
        self.init()
        self.content = content
    }
}
