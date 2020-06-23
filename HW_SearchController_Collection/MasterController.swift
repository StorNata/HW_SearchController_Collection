//
//  MasterController.swift
//  HW_SearchController_Collection
//
//  Created by Nataliia Storozheva on 21.06.2020.
//  Copyright © 2020 Nataliia Storozheva. All rights reserved.
//

import UIKit

let spacing: CGFloat = 10

class MasterController: UIViewController {
    @IBOutlet var collectionView: UICollectionView?
    
    private let dataSource: [ItemModel] = ItemModel.itemData()
    private var searchController: UISearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "News"
        
        self.collectionView?.register(UINib(nibName: "ItemCollectionCell", bundle: nil), forCellWithReuseIdentifier: "cell_id")
        
        
        
        //MARK: - Search
        
        let searchResultsController = self.storyboard?.instantiateViewController(withIdentifier: "SearchController") as? SearchController
        searchResultsController?.onSelectedItem = { [weak self] item in
            //self?.didSelectItem(item)
            self?.didSelectItem(item)
        }
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController?.searchResultsUpdater = self
        
        // 2
        searchController?.obscuresBackgroundDuringPresentation = true
        // 3
        searchController?.searchBar.placeholder = "Search news"
        // 5
        self.definesPresentationContext = true
        
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = searchController
        } else {
            self.navigationItem.titleView = searchController?.searchBar
        }
        
        if let searchbar = searchController?.searchBar {
            collectionView?.contentOffset = CGPoint(x: 0, y: searchbar.frame.size.height)
        }
        
    }
    private func didSelectItem(_ item: ItemModel) {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "DetailedController") as? DetailedController {
            controller.item = item
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
//MARK: - Data Sours
extension MasterController: UICollectionViewDataSource {
    
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
//MARK: - Delegate Flow Layout
extension MasterController: UICollectionViewDelegateFlowLayout {
    
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
        let columCount = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone ? 1 : 2
        
        let cellWidth = (collectionView.frame.size.width - 2 * spacing - CGFloat((columCount - 1)) * spacing) / CGFloat(columCount)
        
        return CGSize.init(width: cellWidth, height: collectionView.frame.size.height)
    }
}
//MARK: - Delegat
extension MasterController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        // open detaild controller
        
        didSelectItem(dataSource[indexPath.item])
    }
}
//MARK: - Search Results Updating
extension MasterController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let seachText = searchController.searchBar.text else {
            return
        }
        
        let filterDataSource = dataSource.filter { (element) -> Bool in
            return element.title.lowercased().contains(seachText.lowercased())
        }
        
        if let resultController = searchController.searchResultsController as? SearchController {
            resultController.setupItems(filterDataSource)
        }
    }
}
