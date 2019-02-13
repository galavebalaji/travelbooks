//
//  BaseViewController.swift
//  TravelBooks

import UIKit

class BaseViewController: UIViewController {

    private var loadingIndicatorView: UIView?
    private var isShowingLoder: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func showActivityIndicator(xOffset: CGFloat = 0, yOffset: CGFloat = 0) {
        guard !isShowingLoder else {
            return
        }
        // Box config:
        let loadingIndicatorHeight: CGFloat = 80
        let loadingIndicatorWidth: CGFloat = 80
        let xOrigin: CGFloat = (xOffset > 0) ? xOffset : (self.view.frame.width - 80) / 2
        let yOrigin: CGFloat = (yOffset > 0) ? yOffset : (self.view.frame.height - 80) / 2
        loadingIndicatorView = UIView(frame: CGRect(x: xOrigin,
                                           y: yOrigin,
                                           width: loadingIndicatorWidth,
                                           height: loadingIndicatorHeight))
        loadingIndicatorView?.backgroundColor = UIColor.black
        loadingIndicatorView?.alpha = 0.9
        loadingIndicatorView?.layer.cornerRadius = 10
        print(self.view.frame.height)
        // Spin config:
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityView.frame = CGRect(x: 20, y: 12, width: 40, height: 40)
        activityView.startAnimating()
        
        // Text config:
        let textLabel = UILabel(frame: CGRect(x: 0, y: 50, width: 80, height: 30))
        textLabel.textColor = UIColor.white
        textLabel.textAlignment = .center
        textLabel.font = UIFont(name: textLabel.font.fontName, size: 13)
        textLabel.text = NSLocalizedString("LOADING_INDICATOR_TEXT", comment: "") + "..."
        
        // Activate:
        loadingIndicatorView?.addSubview(activityView)
        loadingIndicatorView?.addSubview(textLabel)
        
        if let view = loadingIndicatorView {
            self.view.addSubview(view)
            isShowingLoder = true
        }
        
    }
    
    func hideActivityIndicator() {
        loadingIndicatorView?.removeFromSuperview()
        isShowingLoder = false
    }

}
