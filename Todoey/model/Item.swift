//
//  Item.swift
//  Todoey
//
//  Created by Bryan Barreto on 10/09/20.
//  Copyright © 2020 Bryan Barreto. All rights reserved.
//

import Foundation


class Item: Codable {
    let task:String
    var isDone:Bool
    
    init(task:String, isDone:Bool) {
        self.task = task
        self.isDone = isDone
    }
}
