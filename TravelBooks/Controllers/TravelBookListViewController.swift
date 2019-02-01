//
//  TravelBookListViewController.swift

import UIKit

class TravelBookListViewController: BaseViewController {
    
    @IBOutlet private weak var collectionViewTravelBook: UICollectionView! {
        didSet {
            collectionViewTravelBook.clipsToBounds = true
            collectionViewTravelBook.isScrollEnabled = true
            collectionViewTravelBook.dataSource = self
            collectionViewTravelBook.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupNavigationBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor.navigationTintColor()
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.backgroundColor = UIColor.navigationBarBackgroundColor()
        setupSearchButton()
        setupSettingsButton()
    }
    
    private func setupSearchButton() {
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "search_icon"), style: .plain, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = backButton
        backButton.isAccessibilityElement = true
    }
    
    private func setupSettingsButton() {
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "gear-purple"), style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = backButton
        backButton.isAccessibilityElement = true
    }
    
}

extension TravelBookListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
}
