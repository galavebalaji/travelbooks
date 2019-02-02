//
//  TravelFeedTableViewCell.swift
//  TravelBooks

import UIKit

protocol TravelFeedTableViewCellDelegate: AnyObject {
    func reloadRow(at indexPath: IndexPath)
}

class TravelFeedTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var viewBackground: UIView! {
        didSet {
            viewBackground.layer.borderWidth = 0.7
            viewBackground.layer.cornerRadius = 10
            viewBackground.layer.borderColor = UIColor.travelFeedCellBorder().cgColor
            viewBackground.clipsToBounds = true
//            viewBackground.backgroundColor = .white
//            viewBackground.layer.shadowColor = UIColor.black.cgColor
//            viewBackground.layer.shadowOffset = CGSize(width: 0, height: 1.0)
//            viewBackground.layer.shadowOpacity = 0.2
//            viewBackground.layer.shadowRadius = 4.0
        }
    }
    
    @IBOutlet private weak var imageViewUserAvatar: CustomImageView! {
        didSet {
            imageViewUserAvatar.layer.cornerRadius = imageViewUserAvatar.frame.width / 2
            imageViewUserAvatar.clipsToBounds = true
        }
    }
    @IBOutlet private weak var labelUserName: UILabel! {
        didSet {
            labelUserName.textColor = UIColor.travelFeedCellUserName()
        }
    }
    @IBOutlet private weak var labelDate: UILabel!
    @IBOutlet private weak var imageViewCoverImage: CustomImageView!
    @IBOutlet private weak var constraintCoverImageHeight: NSLayoutConstraint!
    
    weak var delegate: TravelFeedTableViewCellDelegate?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureCell(with model: TravelFeedModel) {
        
        if let urlUserAvatar = model.userInformation?.urlUserAvatar {
            imageViewUserAvatar.loadImage(urlString: urlUserAvatar)
        }
        
        if let urlCoverImage = model.urlCoverImage {
            imageViewCoverImage.loadImage(urlString: urlCoverImage) { [weak self] image in
                if let coverImage = image {
                    self?.loadedCoverImage(with: coverImage)
                }
            }
        }
        
        setUserNameAndDate(with: model)
    }
    
    private func setUserNameAndDate(with model: TravelFeedModel) {
        var userName = ""
        if let firstName = model.userInformation?.userFirstName {
            userName.append(firstName)
        }
        
        if let lastName = model.userInformation?.userLastName {
            userName.append(" " + lastName)
        }
        
        labelUserName.text = userName
        
        if let date = model.publishedDate {
            labelDate.text = "\(date.getMMM.uppercased())\n\(date.getYYYY)"
        }
    }
    
    private func loadedCoverImage(with image: UIImage) {
        
        let calculateHeight = (imageViewCoverImage.frame.width * image.size.height) / image.size.width
        constraintCoverImageHeight.constant = calculateHeight
        imageViewCoverImage.image = image
        
        if let indexPath = self.indexPath {
            delegate?.reloadRow(at: indexPath)
        }
    }
    
}
