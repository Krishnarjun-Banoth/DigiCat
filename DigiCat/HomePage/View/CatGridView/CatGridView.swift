//
//  CatGridView.swift
//  DigiCat
//
//  Created by Krishnarjun on 27/08/19.
//  Copyright © 2019 Krishnarjun. All rights reserved.
//


import Foundation
import UIKit


class CatGridView: UICollectionView {

    var data: [CatData] = [] {
        didSet {
            reloadData()
        }
    }
    var offsetValue = 0 {
        didSet {
            if numberOfSections(in: self) > offsetValue {
                self.layoutIfNeeded()
                DispatchQueue.main.async {
                   self.scrollToItem(at: IndexPath(item: 0, section: self.offsetValue), at: .centeredHorizontally, animated: true)
                }
            }
        }
    }
    var catSelectAndScrollListenerDelegate : CatSelectionAndScrollListener?
    func setup() {
        dataSource = self
        isScrollEnabled = true
        delegate = self
        setCollectionViewLayout(UICollectionViewFlowLayout(), animated: true)
        backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9607843137, blue: 0.968627451, alpha: 1)
        alwaysBounceVertical = true
        registerNib(CatGridCell.self)
    }
    

}


extension CatGridView: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        catSelectAndScrollListenerDelegate?.didReachToLastCat()
    }
}
extension CatGridView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {

    // MARK: - Collection view methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // Every row in this collectionView is designed to be a section.
        return Int(ceil(Double(data.count) / Double(SizeProvider.CatGridSizes.numberOfItemsPerRow)))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (section + 1) * SizeProvider.CatGridSizes.numberOfItemsPerRow <= data.count {
            return SizeProvider.CatGridSizes.numberOfItemsPerRow
        } else {
            // For last row.
            return data.count % SizeProvider.CatGridSizes.numberOfItemsPerRow
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = CatGridCell.dequeueReusableCell(collectionView, indexPath: indexPath) as? CatGridCell ?? CatGridCell()
        
        if let cellData = getDataFrom(IndexPath: indexPath) {
            cell.setup(imageUrl: cellData.url)
        }
        cell.curveAndAddBorder()
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cellData = getDataFrom(IndexPath: indexPath) {
            catSelectAndScrollListenerDelegate?.didSelectCat(id: cellData.id)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacingBetweenItems: CGFloat = SizeProvider.CatGridSizes.gridInterItemSpacing * 2
        let totalInnerInsets: CGFloat = SizeProvider.CatGridSizes.gridCollectionViewRightInset + SizeProvider.CatGridSizes.gridCollectionViewLeftInset

        let totalSpacing = totalSpacingBetweenItems + totalInnerInsets

        return CGSize(width: (collectionView.bounds.width - totalSpacing) / CGFloat(SizeProvider.CatGridSizes.numberOfItemsPerRow),
                      height: SizeProvider.CatGridSizes.heightOfItemInGrid)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return SizeProvider.CatGridSizes.gridInterItemSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: SizeProvider.CatGridSizes.gridCollectionViewTopInsetForSection,
                            left: SizeProvider.CatGridSizes.gridCollectionViewLeftInset,
                            bottom: SizeProvider.CatGridSizes.gridCollectionViewBottomInsetForSection,
                            right: SizeProvider.CatGridSizes.gridCollectionViewRightInset)
    }
    
    /**
     Gives the catDataObject from IndexPath.
     */
    func getDataFrom(IndexPath indexPath: IndexPath) -> CatData? {
        let lookupIndex = (indexPath.section * SizeProvider.CatGridSizes.numberOfItemsPerRow) + indexPath.row
        return data[lookupIndex]
    }
}
