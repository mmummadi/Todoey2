//
//  Item.swift
//  Todoey2
//
//  Created by Anurag Guda on 7/20/20.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var date = Date()
    var parent = LinkingObjects(fromType: Category1.self, property: "items")
}
