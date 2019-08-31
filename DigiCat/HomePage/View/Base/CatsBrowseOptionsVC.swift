//
//  CatsBrowseOptionsVC.Swift
//  DigiCat
//
//  Created by Krishnarjun on 26/08/19.
//  Copyright © 2019 Krishnarjun. All rights reserved.
//

import Foundation
import MaterialComponents
import UIKit


enum ListingMode {
    case TABLE
    case GRID
}

protocol CatSelectionAndScrollListener {
    func didSelectCat(id: String)
    func didReachToLastCat()
}

protocol SortClickListener {
    func sortClicked(_ sortBy: SortingLogic)
}

protocol FilterClickListener {
    func filterClicked(_ filterBy: FilterWidget, _ name: String)
}

/** Single view controller that handles browsing between Table view and GridView.
 Consists of a container view which gets populated based on the user selection. */
class CatsBrowseOptionsVC: UIViewController {
    @IBOutlet weak var tableViewLabel: UILabel!
    @IBOutlet weak var gridViewLabel: UILabel!
    @IBOutlet weak var sortyByLabel: UILabel!
    @IBOutlet weak var filterByLabel: UILabel!
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var optionsView: UIView!

    static let CATEGORY_VIEW_TAG = 1231
    static let BRAND_VIEW_TAG = 12312

    var catsData: [CatData] = [CatData]()
    let viewModel = CatsHomeViewModel()
  
    var listingMode = ListingMode.TABLE
    var bottomSheetController: MDCBottomSheetController = MDCBottomSheetController()
    
    convenience init() {
        self.init(nibName: CatsBrowseOptionsVC.nameOfClass, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        optionsView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        contentView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9607843137, blue: 0.968627451, alpha: 1)
        view.backgroundColor = UIColor.white
        loadFilterData()
        loadData()

        let tableViewTapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(switchToTableViewMode))
        tableViewTapRecognizer.delegate = self
        tableViewLabel.addGestureRecognizer(tableViewTapRecognizer)
        
        let gridViewTapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(switchToGridViewMode))
        gridViewTapRecognizer.delegate = self
        gridViewLabel.addGestureRecognizer(gridViewTapRecognizer)
        
        let sortByTapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sortTapped))
        sortByTapRecognizer.delegate = self
        sortyByLabel.addGestureRecognizer(sortByTapRecognizer)
        
        let filterByTapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(filterTapped))
        filterByTapRecognizer.delegate = self
        filterByLabel.addGestureRecognizer(filterByTapRecognizer)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        for subview in view.subviews {
            if subview is UICollectionView {
                (subview as? UICollectionView)?.reloadData()
                (subview as? UICollectionView)?.collectionViewLayout.invalidateLayout()
            }
            if subview is UITableView {
                (subview as? UITableView)?.reloadData()
            }
        }
    }
    
    @objc func switchToTableViewMode() {
        setupCatsTableView()
        tableViewLabel.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        gridViewLabel.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        listingMode = .TABLE
    }
    
    @objc func switchToGridViewMode() {
        setupCatsGridView()
        tableViewLabel.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        gridViewLabel.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        listingMode = .GRID
    }
    
    @objc func sortTapped() {
        let bottomSheetVC = SortingTableBottomSheet()
        bottomSheetVC.sortClickListener = self
        bottomSheetVC.sortIndex = viewModel.sortBy == SortingLogic.ASC.rawValue ? 0 : 1
        bottomSheetController = MDCBottomSheetController(contentViewController: bottomSheetVC)
        presentBottomSheet(vc: bottomSheetController)
    }
    
    @objc func filterTapped() {
        let bottomSheetVC = FilterByBottomSheet()
        bottomSheetVC.filterData = viewModel.filterData
        bottomSheetVC.filterClickListener = self
        bottomSheetController = MDCBottomSheetController(contentViewController: bottomSheetVC)
        presentBottomSheet(vc: bottomSheetController)
    }
    
    func presentBottomSheet(vc: MDCBottomSheetController) {
        vc.preferredContentSize = CGSize(width: self.preferredContentSize.width, height: min(CGFloat(120 + SortingLogic.allCases.count * 34), UIScreen.main.bounds.height - 50))
        present(vc, animated: true, completion: nil)
    }
    
    func loadFilterData() {
        viewModel.loadCategories()
        viewModel.loadBreeds()
    }
    
    func loadData() {
        contentView.showLoadingAnimation()
        viewModel.loadData { success in
            self.contentView.hideLoadingAnimation()
            if success {
                self.catsData = self.viewModel.catsData
                if self.listingMode == .TABLE {
                    self.switchToTableViewMode()
                } else {
                    self.switchToGridViewMode()
                }
            } else {
                // Something went wrong! Log and exit.
            }
        }
    }
    
   
    /** Programmatically sets up the category collection view within the container view. */
    func setupCatsGridView() {
        _ = contentView.removeView(CatsBrowseOptionsVC.BRAND_VIEW_TAG)
        let catCollectionView = CatGridView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        catCollectionView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9607843137, blue: 0.968627451, alpha: 1)
        catCollectionView.setup()
        catCollectionView.data = catsData
        catCollectionView.offsetValue = (self.viewModel.pageNo * Constants.LIMIT / SizeProvider.CatGridSizes.numberOfItemsPerRow)
        catCollectionView.catSelectAndScrollListenerDelegate = self
        catCollectionView.translatesAutoresizingMaskIntoConstraints = false
        catCollectionView.tag = CatsBrowseOptionsVC.CATEGORY_VIEW_TAG
        setupWithinContainer(catCollectionView)
    }

    /** Programmatically sets up the brand table view within container view. */
    func setupCatsTableView() {
        _ = contentView.removeView(CatsBrowseOptionsVC.CATEGORY_VIEW_TAG)
        let catTableView = CatTableView(frame: CGRect.zero, style: .grouped)
        catTableView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9607843137, blue: 0.968627451, alpha: 1)
        catTableView.separatorStyle = .none
        catTableView.sectionIndexColor = #colorLiteral(red: 0.08235294118, green: 0.3411764706, blue: 0.7490196078, alpha: 1)
        catTableView.sectionIndexBackgroundColor = .clear
        catTableView.sectionIndexTrackingBackgroundColor = .clear
        catTableView.catSelectAndScrollListenerDelegate = self
        catTableView.data = catsData
        catTableView.offsetValue = self.viewModel.pageNo * (Constants.LIMIT - 1)
        catTableView.translatesAutoresizingMaskIntoConstraints = false
        catTableView.tag = CatsBrowseOptionsVC.BRAND_VIEW_TAG

        contentView.addSubview(catTableView)
        catTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        catTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        catTableView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        catTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
    }

    func setupWithinContainer(_ childView: UIView) {
        contentView.addSubview(childView)
        childView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        childView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        childView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        childView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}


extension CatsBrowseOptionsVC: CatSelectionAndScrollListener {
    func didReachToLastCat() {
        loadData()
    }
    
    func didSelectCat(id: String) {
        let viewController = CatDetailsViewController()
        viewController.catId = id
        navigationController?.pushViewController(viewController, animated: false)
    }
}


extension CatsBrowseOptionsVC: SortClickListener {
    func sortClicked(_ sortBy: SortingLogic) {
        viewModel.sortBy = sortBy.rawValue
        viewModel.catsData = []
        viewModel.pageNo = 0
        loadData()
    }
}

extension CatsBrowseOptionsVC: FilterClickListener {
    func filterClicked(_ filterBy: FilterWidget, _ name: String) {
        viewModel.catsData = []
        viewModel.pageNo = 0
        viewModel.filterType = filterBy
        viewModel.filterName = name
        loadData()
    }
}

extension CatsBrowseOptionsVC: UIGestureRecognizerDelegate {
    
}
