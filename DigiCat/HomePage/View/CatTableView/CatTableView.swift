//
//  CatTableView.swift
//  DigiCat
//
//  Created by Krishnarjun on 30/08/19.
//  Copyright © 2019 Krishnarjun. All rights reserved.
//

import UIKit

class CatTableView: UITableView {
    var data: [CatData] = [] {
        didSet {
            reloadData()
        }
    }
    
    var catSelectAndScrollListenerDelegate : CatSelectionAndScrollListener?
    var offsetValue = 0 {
        didSet {
            if data.count > offsetValue {
                self.scrollToRow(at: IndexPath(row: offsetValue, section: 0), at: .none, animated: false)
            }
        }
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    func sharedInit() {
        backgroundColor = .clear
        dataSource = self
        delegate = self
        register(UINib(nibName: CatTableViewCell.nameOfClass, bundle: nil), forCellReuseIdentifier: CatTableViewCell.nameOfClass)
    }
}

extension CatTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CatTableViewCell.dequeueCell(tableView, indexPath: indexPath) as? CatTableViewCell ?? CatTableViewCell()
        cell.setup(imageUrl: data[indexPath.row].url)
        cell.curveAndAddBorder()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        catSelectAndScrollListenerDelegate?.didSelectCat(id: data[indexPath.row].id)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250.0
    }
}

extension CatTableView: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        catSelectAndScrollListenerDelegate?.didReachToLastCat()
    }
}
