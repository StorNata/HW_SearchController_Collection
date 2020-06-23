//
//  ItemCollectionCell.swift
//  HW_SearchController_Collection
//
//  Created by Nataliia Storozheva on 21.06.2020.
//  Copyright © 2020 Nataliia Storozheva. All rights reserved.
//

import UIKit

class ItemCollectionCell: UICollectionViewCell {
      var item: ItemModel? {
            didSet {
                itemTitle?.text = item?.title
                itemText?.text = item?.text
            }
        }
        
        @IBOutlet var itemTitle: UILabel?
        @IBOutlet var itemText: UILabel?
        
    }

