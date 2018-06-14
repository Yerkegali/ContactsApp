//
//  ContactCell.swift
//  ContactsApp
//
//  Created by Yerkegali Abubakirov on 11.06.2018.
//  Copyright © 2018 Yerkegali Abubakirov. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    
    var link: ViewController?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let starButton = UIButton(type: .system)
        starButton.setImage(#imageLiteral(resourceName: "fav_star"), for: .normal)
        starButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        starButton.tintColor = .red
        starButton.addTarget(self, action: #selector(handleFavoriteMark), for: .touchUpInside)
        accessoryView = starButton
        
    }
    
    @objc private func handleFavoriteMark() {
        link?.someMethod(cell: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
