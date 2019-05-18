//
//  Item.swift
//  Todoey
//
//  Created by Thomas Bouges on 2019-05-16.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date? 
    
    // we create our reverse relationships
//    in order we used LinkingObjects and add type Category.self and String that is the name of other relationships
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
