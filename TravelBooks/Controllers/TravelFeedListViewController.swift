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
            addRefreshControl()
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
            buttonFriends.setTitle("BUTTON_TITLE_FRIENDS".localized, for: .normal)
        }
    }
    
    @IBOutlet private weak var buttonCommunity: CustomButton! {
        didSet {
            buttonCommunity.changeStyle(isSelected: false)
            buttonCommunity.setTitle("BUTTON_TITLE_COMMUNITY".localized, for: .normal)
        }
    }
    
    @IBOutlet private weak var imageViewArrow: UIImageView! {
        didSet {
            self.imageViewArrow.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        }
    }
    
    @IBOutlet private weak var constraintTableViewTop: NSLayoutConstraint!
    
    private var refreshControl = UIRefreshControl()
    var presenter: TravelFeedListPresenterInput?
    var configurator: TravelFeedListConfigurator?
    private var selectedButtonType: FeedFilterType = .friends
    
    private var heightForRow: [IndexPath: CGFloat] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupNavigationBar()
        configurator?.configure(travelFeedListViewController: self)
        presenter?.fetchFeedList(for: selectedButtonType)
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
    
    private func addRefreshControl() {
        refreshControl = UIRefreshControl()
        if #available(iOS 10.0, *) {
            tableViewTravelFeed.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
            tableViewTravelFeed.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(pulledToRefresh), for: .valueChanged)
    }
    
    @objc
    private func pulledToRefresh() {
        presenter?.fetchFeedList(for: selectedButtonType)
    }
    
    // MARK: Actions Methods
    @IBAction private func buttonTravelBooksTapped(_ sender: UIButton) {
        hideStackViewElements(shouldHide: false)
    }
    
    @IBAction private func buttonFriendsTapped(_ sender: CustomButton) {
        hideStackViewElements(shouldHide: true)
        if selectedButtonType == .friends { return }
        selectedButtonType = .friends
        tappedButton(with: selectedButtonType)
    }
    
    @IBAction private func buttonCommunityTapped(_ sender: CustomButton) {
        hideStackViewElements(shouldHide: true)
        if selectedButtonType == .community { return }
        selectedButtonType = .community
        tappedButton(with: selectedButtonType)
    }
    
    private func hideStackViewElements(shouldHide: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.labelSortBy.isHidden = shouldHide
            self.stackViewOfButtons.isHidden = shouldHide
            self.buttonTravelBooks.isEnabled = shouldHide
            self.constraintTableViewTop.constant = shouldHide ?
                Constant.Dimension.iOSPOINTS0 : Constant.Dimension.iOSPOINTS20
            let angle = shouldHide ? (-Double.pi / 2) : (Double.pi / 2)
            self.imageViewArrow.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
        }
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
        presenter?.fetchFeedList(for: selectedButtonType)
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
            let model = presenter?.travelModel(for: indexPath.row) else {
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
            DispatchQueue.main.async { [weak self] in
                self?.tableViewTravelFeed.beginUpdates()
                self?.tableViewTravelFeed.reloadRows(
                    at: [indexPath],
                    with: .fade)
                self?.tableViewTravelFeed.endUpdates()
            }
        }
    }
    
    func stopPullToRefreshIndicator() {
        DispatchQueue.main.async { [weak self] in
            guard self?.refreshControl.isRefreshing ?? false else {
                return
            }
            self?.refreshControl.endRefreshing()
        }
    }
    
    func showLoader(shouldShow: Bool) {
        guard !refreshControl.isRefreshing else { return }
        DispatchQueue.main.async { [weak self] in
            if shouldShow {
                self?.showActivityIndicator()
            } else {
                self?.hideActivityIndicator()
            }
        }
    }
}
