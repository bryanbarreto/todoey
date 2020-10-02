//
//  Item.swift
//  Todoey
//
//  Created by Bryan Barreto on 24/09/20.
//  Copyright © 2020 Bryan Barreto. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var createdAt: Date?
    @objc dynamic var done: Bool = false
    
    /* inverse relationship. Declara uma variavel da categoria, informando a classe cateoria e o nome da propriedade (chave primaria) */
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
