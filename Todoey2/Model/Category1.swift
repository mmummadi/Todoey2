//
//  Data.swift
//  Todoey2
//
//  Created by Anurag Guda on 7/19/20.
//

import Foundation
import RealmSwift

class Category1 : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    let items = List<Item>()
}
