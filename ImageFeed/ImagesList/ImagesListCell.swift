//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Anastasiia on 26.11.2024.
//

import Foundation
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
    
   
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    override func prepareForReuse() {
            super.prepareForReuse()
            
            // Отменяем загрузку, чтобы избежать багов при переиспользовании ячеек
        cellImage.kf.cancelDownloadTask()
        }
    
    
     func setIsLiked(isLiked: Bool) {
        if isLiked == false {
            likeButton.setImage(UIImage(named: "Active"), for: .normal)
        } else if isLiked == true {
            likeButton.setImage(UIImage(named: "NoActive"), for: .normal)
        }
    }
}
