//
//  TravelFeedListViewController.swift

import UIKit

class TravelFeedListViewController: BaseViewController {
    
    @IBOutlet private weak var collectionViewTravelBook: UICollectionView! {
        didSet {
            collectionViewTravelBook.clipsToBounds = true
            collectionViewTravelBook.isScrollEnabled = true
            collectionViewTravelBook.dataSource = self
            collectionViewTravelBook.delegate = self
        }
    }
    
    var presenter: TravelFeedListPresenterInput?
    var configurator: TravelFeedListConfigurator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupNavigationBar()
        configurator?.configure(travelFeedListViewController: self)
        presenter?.fetchFeedList()
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
        let searchButton = UIBarButtonItem(image: #imageLiteral(resourceName: "search_icon"), style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = searchButton
    }
    
    private func setupSettingsButton() {
        let settingsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "gear-purple"), style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = settingsButton
    }
    
}

extension TravelFeedListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
}

extension TravelFeedListViewController: TravelFeedListPresenterOutput {
    
}
