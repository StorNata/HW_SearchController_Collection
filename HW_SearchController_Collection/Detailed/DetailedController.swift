//
//  DetailedController.swift
//  HW_SearchController_Collection
//
//  Created by Nataliia Storozheva on 22.06.2020.
//  Copyright © 2020 Nataliia Storozheva. All rights reserved.
//

import UIKit

class DetailedController: UIViewController {

    var item: ItemModel?
        
        @IBOutlet var itemTitle: UILabel?
        @IBOutlet var itemText: UILabel?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            title = "News Detailed"
            
            itemTitle?.text = item?.title
            itemText?.text = item?.text
        }
    }
