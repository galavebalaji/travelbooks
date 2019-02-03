//
//  TravelFeedTableViewCell.swift
//  TravelBooks

import UIKit
import SDWebImage

protocol TravelFeedTableViewCellDelegate: AnyObject {
    func reloadRow(at indexPath: IndexPath, height: CGFloat)
}

class TravelFeedTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var viewBackground: UIView! {
        didSet {
            viewBackground.layer.borderWidth = 0.7
            viewBackground.layer.cornerRadius = 10
            viewBackground.layer.borderColor = UIColor.travelFeedCellBorder().cgColor
            viewBackground.clipsToBounds = true
        }
    }
    
    @IBOutlet private weak var imageViewUserAvatar: CustomImageView! {
        didSet {
            imageViewUserAvatar.roundedImage(imageViewUserAvatar.frame.width / 2, color: .clear)
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
    @IBOutlet private weak var constraintCoverImageTop: NSLayoutConstraint!
    
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
        
        if let urlCoverImageString = model.urlCoverImage, let urlCoverImage = URL(string: urlCoverImageString) {
            self.imageViewCoverImage?.sd_setImage(with: urlCoverImage) { [weak self] (image, _, _, _) in
                if let image = image {
                    self?.loadedCoverImage(with: image)
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
        Logger.log(message: "Height for the row \(indexPath?.row) is = \(calculateHeight + constraintCoverImageTop.constant)", messageType: .debug)
        if let indexPath = self.indexPath {
            delegate?.reloadRow(at: indexPath, height: calculateHeight + constraintCoverImageTop.constant)
        }
        imageViewCoverImage.image = image
    }
    
}
