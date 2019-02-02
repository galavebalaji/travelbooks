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
            tableViewTravelFeed.estimatedRowHeight = 247
            let nib = UINib(nibName: Constant.TravelFeedListConstants.travelFeedTableCellName, bundle: nil)
            tableViewTravelFeed.register(nib,
                                         forCellReuseIdentifier: Constant.TravelFeedListConstants.travelFeedTableCellId)
        }
    }
    
    @IBOutlet private weak var labelSortBy: UILabel!
    @IBOutlet private weak var stackViewOfButtons: UIStackView!
    
    @IBOutlet private weak var buttonTravelBooks: UIButton! {
        didSet {
            buttonTravelBooks.isEnabled = false
        }
    }
    
    @IBOutlet private weak var buttonFriends: CustomButton! {
        didSet {
            buttonFriends.changeStyle(isSelected: true)
        }
    }
    
    @IBOutlet private weak var buttonCommunity: CustomButton! {
        didSet {
            buttonCommunity.changeStyle(isSelected: false)
        }
    }
    
    var presenter: TravelFeedListPresenterInput?
    var configurator: TravelFeedListConfigurator?
    private var selectedButtonType: FeedFilterType = .friends
    
    private var heightForRow: [IndexPath: CGFloat] = [:]
    
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
    
    // MARK: Actions Methods
    @IBAction private func buttonTravelBooksTapped(_ sender: UIButton) {
        hideStackViewElements(shouldHide: false)
    }
    
    @IBAction private func buttonFriendsTapped(_ sender: CustomButton) {
        selectedButtonType = .friends
        hideStackViewElements(shouldHide: true)
    }
    
    @IBAction private func buttonCommunityTapped(_ sender: CustomButton) {
        selectedButtonType = .community
        hideStackViewElements(shouldHide: true)
    }
    
    private func hideStackViewElements(shouldHide: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.labelSortBy.isHidden = shouldHide
            self.stackViewOfButtons.isHidden = shouldHide
            self.buttonTravelBooks.isEnabled = shouldHide
        }
        tappedButton(with: selectedButtonType)
    }
    
    private func tappedButton(with type: FeedFilterType) {
        
        switch type {
        case .friends:
            buttonFriends.changeStyle(isSelected: true)
            buttonCommunity.changeStyle(isSelected: false)
        case .community:
            buttonFriends.changeStyle(isSelected: false)
            buttonCommunity.changeStyle(isSelected: true)
        }
        
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
        cell.indexPath = indexPath
        cell.delegate = self
        cell.configureCell(with: model)
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
    
    func reloadRow(at indexPath: IndexPath, height: CGFloat) {
        if heightForRow[indexPath] == nil {
            heightForRow[indexPath] = height
            DispatchQueue.main.async {
                self.tableViewTravelFeed.beginUpdates()
                self.tableViewTravelFeed.reloadRows(
                    at: [indexPath],
                    with: .fade)
                self.tableViewTravelFeed.endUpdates()
            }
        }
    }
    
}
