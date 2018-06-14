//
//  ExpandableNames.swift
//  ContactsApp
//
//  Created by Yerkegali Abubakirov on 11.06.2018.
//  Copyright © 2018 Yerkegali Abubakirov. All rights reserved.
//

import Foundation
import Contacts

struct ExpandableNames {
    
    var isExpanded: Bool
    var names: [FavoritableContact]
}

struct FavoritableContact {
    let contact: CNContact
    var hasFavorited: Bool
}
