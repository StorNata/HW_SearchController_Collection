//
//  SearchController.swift
//  HW_SearchController_Collection
//
//  Created by Nataliia Storozheva on 22.06.2020.
//  Copyright © 2020 Nataliia Storozheva. All rights reserved.
//

import UIKit

class SearchController: UIViewController {

    @IBOutlet var collectionView: UICollectionView?
    @IBOutlet private var searchFooterBottomConstraint: NSLayoutConstraint?
    
    private var dataSource: [ItemModel] = []
    
    var onSelectedItem: ((ItemModel)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
       self.collectionView?.register(UINib(nibName: "ItemCollectionCell", bundle: nil), forCellWithReuseIdentifier: "cell_id")
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            forName: UIResponder.keyboardWillChangeFrameNotification,
            object: nil, queue: .main) { (notification) in
                self.handleKeyboard(notification: notification)
        }
        notificationCenter.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil, queue: .main) { (notification) in
                self.handleKeyboard(notification: notification)
        }
        
    }
     private func handleKeyboard(notification: Notification) {
          // 1
          guard notification.name == UIResponder.keyboardWillChangeFrameNotification else {
            searchFooterBottomConstraint?.constant = 0
            view.layoutIfNeeded()
            return
          }

          guard
            let info = notification.userInfo,
            let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
            else {
              return
          }

          // 2
          let keyboardHeight = keyboardFrame.cgRectValue.size.height
          UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.searchFooterBottomConstraint?.constant = keyboardHeight
            self.view.layoutIfNeeded()
          })
        }

        
        func setupItems(_ items: [ItemModel]) {
            dataSource.removeAll()
            dataSource.append(contentsOf: items)
            collectionView?.reloadData()
        }

    }
//MARK: - Data Sours
extension SearchController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
       }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_id", for: indexPath)
        if let cell = cell as? ItemCollectionCell {
            cell.item = dataSource[indexPath.item]
        }
        return cell
    }
}
extension SearchController: UICollectionViewDelegateFlowLayout {

func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return spacing
}
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
           return spacing
       }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columCount = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone ? 2 : 4
        
        let cellWidth = (collectionView.frame.size.width - 2 * spacing - CGFloat((columCount - 1)) * spacing) / CGFloat(columCount)
      
        return CGSize.init(width: cellWidth, height: 0 )
}
}
extension SearchController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        // open detaild controller
        
        onSelectedItem?(dataSource[indexPath.row])
    }
}
