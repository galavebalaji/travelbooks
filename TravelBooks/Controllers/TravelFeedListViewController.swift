//
//  TravelFeedListViewController.swift

import UIKit

class TravelFeedListViewController: BaseViewController {
    
    @IBOutlet private weak var tableViewTravelFeed: UITableView! {
        didSet {
            tableViewTravelFeed.delegate = self
            tableViewTravelFeed.dataSource = self
            tableViewTravelFeed.separatorStyle = .none
            tableViewTravelFeed.backgroundColor = UIColor.travelFeedTableViewBackground()
            tableViewTravelFeed.rowHeight = UITableViewAutomaticDimension
            let nib = UINib(nibName: Constant.TravelFeedListConstants.travelFeedTableCellName, bundle: nil)
            tableViewTravelFeed.register(nib,
                                         forCellReuseIdentifier: Constant.TravelFeedListConstants.travelFeedTableCellId)
        }
    }
    
    var presenter: TravelFeedListPresenterInput?
    var configurator: TravelFeedListConfigurator?
    
    fileprivate var heightForRow: [IndexPath: CGFloat] = [:]
    
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
        navigationController?.navigationBar.tintColor = UIColor.navigationTint()
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.backgroundColor = UIColor.navigationBarBackground()
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

extension TravelFeedListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRows(for: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = Constant.TravelFeedListConstants.travelFeedTableCellId
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId,
                                                       for: indexPath) as? TravelFeedTableViewCell,
            let model = presenter?.travelModel(for: indexPath.section) else {
            return UITableViewCell()
        }
        
        cell.configureCell(with: model)
        cell.indexPath = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

extension TravelFeedListViewController: TravelFeedListPresenterOutput {
    func reloadData() {
        tableViewTravelFeed.reloadData()
    }
}

extension TravelFeedListViewController: TravelFeedTableViewCellDelegate {
    
    func reloadRow(at indexPath: IndexPath) {
        tableViewTravelFeed.reloadRows(at: [indexPath], with: .fade)
    }
    
}
