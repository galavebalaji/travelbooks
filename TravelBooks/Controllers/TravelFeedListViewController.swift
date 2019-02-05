//
//  TravelFeedListViewController.swift

import UIKit

/*
 This controller is responsible for displaying List of Travel Feed information
 */

class TravelFeedListViewController: BaseViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet private weak var tableViewTravelFeed: UITableView! {
        didSet {
            tableViewTravelFeed.delegate = self
            tableViewTravelFeed.dataSource = self
            tableViewTravelFeed.prefetchDataSource = self
            tableViewTravelFeed.separatorStyle = .none
            tableViewTravelFeed.backgroundColor = UIColor.travelFeedTableViewBackground()
            let nib = UINib(nibName: Constant.TravelFeedListConstants.travelFeedTableCellName, bundle: nil)
            tableViewTravelFeed.register(nib,
                                         forCellReuseIdentifier: Constant.TravelFeedListConstants.travelFeedTableCellId)
            addRefreshControl()
        }
    }
    
    @IBOutlet private weak var labelSortBy: UILabel!
    
    // This holds both Friends and Community buttons together
    @IBOutlet private weak var stackViewOfButtons: UIStackView!
    
    // this button expands/collapse views
    @IBOutlet private weak var buttonTravelBooks: UIButton! {
        didSet {
            buttonTravelBooks.isEnabled = true
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
            self.imageViewArrow.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        }
    }
    
    @IBOutlet private weak var constraintTableViewTop: NSLayoutConstraint!
    
    // MARK: UI Elements
    private var refreshControl = UIRefreshControl()
    
    // MARK: All Variable
    
    // Presenter is responsible for getting data
    var presenter: TravelFeedListPresenterInput!
    
    // configures/instantiats  all with usercase service and all
    var configurator: TravelFeedListConfigurator?
    
    // This holds the type of sort by/filter you have selected. By default it holds friends type
    private var selectedButtonType: FeedFilterType = .friends
    
    // This keeps track of view expanded to show sort by filter view
    private var isExpandedFilterView = true
    
    // This tracks the page we loaded from pagination
    private var currentPage = 1
    
    // Store the height of particular cell against IndexPath, it reduces the calculating the height of cell everytime it reloads
    private var heightForRow: [IndexPath: CGFloat] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupNavigationBar()
        configurator?.configure(travelFeedListViewController: self)
        presenter?.fetchFeedList(for: selectedButtonType, page: currentPage)
        
        // This helps to know what exact size of Cover imageview in the table view by substracting this leading and trailing depending on device size
        TravelFeedTableViewCell.coverImageViewWidth = tableViewTravelFeed.frame.width - (2 * Constant.Dimension.iOSPOINTS16)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // Setup NavigationBar and its color
    private func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor.navigationTint()
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.backgroundColor = UIColor.navigationBarBackground()
        setupSearchButton()
        setupSettingsButton()
    }
    
    // Setup left nav bar button
    private func setupSearchButton() {
        let searchButton = UIBarButtonItem(image: #imageLiteral(resourceName: "search_icon"), style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = searchButton
    }
    
    // Setup right nav bar button
    private func setupSettingsButton() {
        let settingsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "gear-purple"), style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = settingsButton
    }
    
    // adds refresh view control to the tablview
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
        currentPage = 1
        presenter?.fetchFeedList(for: selectedButtonType, page: currentPage)
    }
    
    // MARK: Actions Methods
    @IBAction private func buttonTravelBooksTapped(_ sender: UIButton) {
        hideStackViewElements(shouldHide: isExpandedFilterView)
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
    
    // Hides and shows sort by view with animation
    private func hideStackViewElements(shouldHide: Bool) {
        
        isExpandedFilterView = !shouldHide
        
        UIView.animate(withDuration: 0.25) {
            self.labelSortBy.isHidden = shouldHide
            self.stackViewOfButtons.isHidden = shouldHide
            self.constraintTableViewTop.constant = shouldHide ?
                Constant.Dimension.iOSPOINTS0 : Constant.Dimension.iOSPOINTS20
            
            // Rotate image up and down arrow
            let angle = shouldHide ? (Double.pi / 2) : (-Double.pi / 2)
            self.imageViewArrow.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
        }
    }
    
    // This access lasted data for selected sort by type for first page
    // changes the friends and community button design
    private func tappedButton(with type: FeedFilterType) {
        currentPage = 1
        presenter.resetTravelFeedList()
        switch type {
        case .friends:
            buttonFriends.changeStyle(isSelected: true)
            buttonCommunity.changeStyle(isSelected: false)
        case .community:
            buttonFriends.changeStyle(isSelected: false)
            buttonCommunity.changeStyle(isSelected: true)
        }
        presenter?.fetchFeedList(for: selectedButtonType, page: currentPage)
    }
    
}

// MARK: UITableViewDelegate and UITableViewDataSource methods

extension TravelFeedListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
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
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRow[indexPath] ?? UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRow[indexPath] ?? UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // Configure next cells to display
        if let model = presenter?.travelModel(for: indexPath.row),
            let travelFeedBackCell = cell as? TravelFeedTableViewCell {
            travelFeedBackCell.configureCell(with: model)
        }
        // Keeps track of last cells and calls API for getting data of next page
        if indexPath.row == presenter.numberOfFeeds - 2, presenter.hasMoreFeeds {
            currentPage += 1
            presenter.fetchFeedList(for: selectedButtonType, page: currentPage)
        }
    }
    
}

// MARK: UITableViewDataSourcePrefetching methods

extension TravelFeedListViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        // Fetch the next images and get ready to display once user scrolls ups and down
        for indexPath in indexPaths {
            if let model = presenter.travelModel(for: indexPath.row),
                let urlCoverImageString = model.urlCoverImage {
                let imageView = UIImageView()
                imageView.sd_setImage(with: URL(string: urlCoverImageString), completed: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        
    }
    
}

extension TravelFeedListViewController: TravelFeedListPresenterOutput {
    
    func reloadData() {
        // Reloads the table view data
        tableViewTravelFeed.reloadData()
        
        // Once you select another category and data gets fetched from it
        // so scroll up to the first cell to show data for new sort type that you selected
        if currentPage == 1, presenter.numberOfFeeds > 0 {
            tableViewTravelFeed.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
}

// MARK: TravelFeedTableViewCellDelegate methods

extension TravelFeedListViewController: TravelFeedTableViewCellDelegate {
    
    // reloas rows at perticular index and save the height for indexPath for future use
    // if we already have height then dont need to reload the cell
    func reloadRow(at indexPath: IndexPath, height: CGFloat) {
        if heightForRow[indexPath] == nil {
            heightForRow[indexPath] = height
            self.tableViewTravelFeed.beginUpdates()
            self.tableViewTravelFeed.reloadRows(
                at: [indexPath],
                with: .none)
            self.tableViewTravelFeed.endUpdates()
        }
    }
    
    // Stops pull to refresh indicator once we get a data
    func stopPullToRefreshIndicator() {
        DispatchQueue.main.async { [weak self] in
            guard self?.refreshControl.isRefreshing ?? false else {
                return
            }
            self?.refreshControl.endRefreshing()
        }
    }
    
    // Show and hide the activity indicator
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
