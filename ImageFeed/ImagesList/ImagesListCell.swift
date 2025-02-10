//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Anastasiia on 26.11.2024.
//

import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    // MARK: - Static properties
    
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - @IBOutlet properties
    
    @IBOutlet var cellImage: UIImageView! {
        didSet {
            cellImage.backgroundColor = .ypWhiteAlpha50
        }
    }
    
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    var delegate: ImagesListCellDelegate?
    
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
    }
    
    func setIsLiked(isLiked: Bool) {
        likeButton.setImage(UIImage(named: isLiked ? "Active" : "NoActive"), for: .normal)
    }
}
