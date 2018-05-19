//
//  VideoCell.swift
//  Youtube
//
//  Created by Che Blankenship on 7/7/17.
//  Copyright © 2017 Che Blankenship. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class VideoCell: BaseCell {
    
    var video: Video? {
        didSet {
            titleLabel.text = video?.title
            
            setupProfileImage()
            
            setupThumbnailImage()
            
            
            thumbnailImageView.image = UIImage(named: (video?.thumbnailImageName)!)
            //userProfileImageView.image = UIImage(named: (video?.channel?.profileImageName)!)
            // 値がnil にならない場合のみ実
            if let profileImageName = video?.channel?.profileImageName {
                userProfileImageView.image = UIImage(named: profileImageName)
            }
            
            if let channelName = video?.channel?.name, let numberOfViews = video?.numberOfViews {
                
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                
                subtitletextView.text = "\(String(describing: channelName)) - \(String(describing: numberFormatter.string(from: numberOfViews)!)) - 2 years ago "
            }
            
            // Measure title text
            if let videoTitle = video?.title {
                let size = CGSize(width: frame.width - 16 - 44 - 8 - 16, height: 1000)
                let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                let estimatedRect = NSString(string: videoTitle).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
                
                if estimatedRect.size.height > 20 {
                    titleLabelHeightConstraint?.constant = 44
                }
                else{
                    titleLabelHeightConstraint?.constant = 20
                }
            }
        }
    }
    
    func setupThumbnailImage() {
        if let thumbnailImageUrl = video?.thumbnailImageName {
            
            thumbnailImageView.loadImageUsingUrlString(urlString: thumbnailImageUrl)
            
        }
    }
    
    func setupProfileImage() {
        if let profileImage = video?.channel?.profileImageName {
            
            userProfileImageView.loadImageUsingUrlString(urlString: profileImage)
            
            
        }
    }
    
    var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        //imageView.backgroundColor = UIColor.blue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "taylor_swift_blank_space")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.green
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "taylor_prof")
        imageView.layer.cornerRadius = 22
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = "Taylor Swift - Blank Space"
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let separatorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(colorLiteralRed: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let subtitletextView: UITextView = {
        let textView = UITextView()
        textView.text = "TaylorSwiftVEVO - , 1,640,684,000 views - 2 years ago"
        textView.textColor = UIColor.lightGray
        textView.textContainerInset = UIEdgeInsetsMake(0,-4,0,0)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var titleLabelHeightConstraint: NSLayoutConstraint?
    
    override func setupViews() {
        addSubview(thumbnailImageView)
        addSubview(separatorView)
        addSubview(userProfileImageView)
        addSubview(titleLabel)
        addSubview(subtitletextView)
        
        //        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0]-16-[v1(1)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": thumbnailImageView, "v1": separatorView]))
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: thumbnailImageView)
        addConstraintsWithFormat(format: "H:|-16-[v0(44)]", views: userProfileImageView, titleLabel)
        /// Vertical constraints
        // 8, 44, 28 is what makes the height 80.
        // 16px space on top, 8px gap between img and titleLabel and 28px for botton
        addConstraintsWithFormat(format: "V:|-16-[v0]-8-[v1(44)]-28-[v2(1)]|", views: thumbnailImageView, userProfileImageView, separatorView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: separatorView)
        
        /// titleLabel
        // Top Constarints setting for titleLabel
        titleLabelHeightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: thumbnailImageView, attribute:  .bottom, multiplier: 1, constant: 8)
        addConstraint(titleLabelHeightConstraint!)
        // Left Constraints setting for titleLabel
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
        // Right Constraints setting for titleLabel
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0))
        // Height Constraints setting for titleLabel
        titleLabelHeightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 44)
        addConstraint(titleLabelHeightConstraint!)
        
        /// subtitileTextView
        // Top Constarints setting for titleLabel
        addConstraint(NSLayoutConstraint(item: subtitletextView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute:  .bottom, multiplier: 1, constant: 4))
        // Left Constraints setting for titleLabel
        addConstraint(NSLayoutConstraint(item: subtitletextView, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
        // Right Constraints setting for titleLabel
        addConstraint(NSLayoutConstraint(item: subtitletextView, attribute: .right, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0))
        // Height Constraints setting for titleLabel
        addConstraint(NSLayoutConstraint(item: subtitletextView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 30))
    }

    
}


