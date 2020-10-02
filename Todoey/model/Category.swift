//
//  Category.swift
//  Todoey
//
//  Created by Bryan Barreto on 24/09/20.
//  Copyright © 2020 Bryan Barreto. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name:String = ""
    @objc dynamic var color:String = ""
    let items: List<Item> = List<Item>()
}
