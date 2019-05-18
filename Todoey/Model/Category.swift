//
//  Category.swift
//  Todoey
//
//  Created by Thomas Bouges on 2019-05-16.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import Foundation
import RealmSwift
 //inherit from Object Class
class Category: Object {
    @objc dynamic var name : String = ""
    
    //create a relationships on utilise List Array from realm
    let items = List<Item>()
}
