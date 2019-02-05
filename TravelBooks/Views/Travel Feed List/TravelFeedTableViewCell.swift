//
//  TravelFeedTableViewCell.swift
//  TravelBooks

import UIKit
import SDWebImage

protocol TravelFeedTableViewCellDelegate: AnyObject {
    func reloadRow(at indexPath: IndexPath, height: CGFloat)
}

class TravelFeedTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    
    @IBOutlet private weak var viewBackground: UIView! {
        didSet {
            viewBackground.rounded(10, withBorder: true, borderColor: UIColor.travelFeedCellBorder(), borderWidth: 0.7)
        }
    }
    
    @IBOutlet private weak var imageViewUserAvatar: UIImageView! {
        didSet {
            imageViewUserAvatar.rounded(imageViewUserAvatar.frame.width / 2, borderColor: .clear)
        }
    }
    @IBOutlet private weak var labelUserName: UILabel! {
        didSet {
            labelUserName.textColor = UIColor.travelFeedCellUserName()
        }
    }
    @IBOutlet private weak var labelDate: UILabel!
    @IBOutlet private weak var imageViewCoverImage: UIImageView!
    
    // Height constraint for the for Cover Image
    @IBOutlet private weak var constraintCoverImageHeight: NSLayoutConstraint!
    
    // Top space constraint of Cover Image
    @IBOutlet private weak var constraintCoverImageTop: NSLayoutConstraint!
    
    // Bottom space constraint of Cover Image
    @IBOutlet private  weak var constraintCoverImageBottom: NSLayoutConstraint!
    
    // Holds reference back to the controller
    weak var delegate: TravelFeedTableViewCellDelegate?
    
    // Inde
    var indexPath: IndexPath?
    
    // This holds the cover imageView width according to the device size
    static var coverImageViewWidth: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // Confirgures the cell with give Model
    func configureCell(with model: TravelFeedModel) {
        
        // Loads user image avatar with url and SDWebImage handles everything
        if let urlUserAvatar = model.userInformation?.urlUserAvatar {
            imageViewUserAvatar.sd_setImage(with: URL(string: urlUserAvatar), completed: nil)
        }
        
        // Loads Cover Image
        if let urlCoverImageString = model.urlCoverImage,
            let urlCoverImage = URL(string: urlCoverImageString) {
            self.imageViewCoverImage?.sd_setImage(with: urlCoverImage) { [weak self] image, error, _, imageURL in
                
                if error == nil, let image = image {
                    self?.loadedCoverImage(with: image)
                } else {
                    let url = imageURL?.absoluteString
                    Logger.log(message: "Unable to load Image from URL = \(String(describing: url))",
                               messageType: .debug)
                }
            }
        }
        
        setUserNameAndDate(with: model)
    }
    
    // Sets username and date
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
    
    // Gets called when SDWebImage loads the cover image
    // this calcualates the aspect ration of an image and depending on calculated the height of entire cells
    // the calcukated height is sent to the controller and tableview reload that particular cell only with update height
    private func loadedCoverImage(with image: UIImage) {
        
        let imageWidth = imageViewCoverImage.frame.width
        
        Logger.log(message: "imageViewCover \(String(describing: indexPath?.row)) is = \(imageWidth)",
                   messageType: .debug)
        
        // Get the height of image
        let calculatedImageHeight = (image.size.height * TravelFeedTableViewCell.coverImageViewWidth) / image.size.width
        
        if let indexPath = self.indexPath {
            
            // Calculate the height og entire cell
            let totalCellHeight = calculatedImageHeight +
                constraintCoverImageTop.constant +
                constraintCoverImageBottom.constant
            
            Logger.log(message: "Height for the row \(indexPath.row) is = \(totalCellHeight)", messageType: .debug)
            
            // Update the constraintCoverImageHeight with calculatedImageHeight and reload the cell to fit the image
            DispatchQueue.main.async { [weak self] in
                self?.constraintCoverImageHeight.constant = calculatedImageHeight
                self?.delegate?.reloadRow(at: indexPath, height: totalCellHeight)
            }
        }
        
    }
    
}
