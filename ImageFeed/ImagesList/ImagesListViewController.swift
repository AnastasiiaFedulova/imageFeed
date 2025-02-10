//
//  ViewController.swift
//  ImageFeed
//
//  Created by Anastasiia on 21.11.2024.
//

import UIKit
import Kingfisher
import ProgressHUD

final class ImagesListViewController: UIViewController, ViewControllerProtocol {
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    @IBOutlet private var tableView: UITableView!
    
    var photos: [Photo] = []
    
    var imageListService = ImagesListService.shared
    
    private var alertPresenter: AlertPresenter?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        alertPresenter = AlertPresenter()
        alertPresenter?.setup(delegate: self)
        
        
        NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                
                updateTableViewAnimated()
            }
        fetchImages()
    }
    
    private func fetchImages() {
        imageListService.fetchPhotosNextPage() { [weak self] result in
            switch result {
            case .success(let photos):
                return
            case .failure(_):
                let alertModel = AlertModel(title: "Ошибка", message: "Не удалось загрузить изображения.", buttonText: "OK", completion: nil)
                self?.alertPresenter?.alert(alertData: alertModel)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == photos.count - 1 {
            fetchImages()
        }
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imageListService.photos.count
        photos = imageListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            guard indexPath.row < photos.count else {
                assertionFailure("Index out of bounds for photos array")
                return
            }
            
            let photo = photos[indexPath.row]
            
            guard !photo.largeImageURL.isEmpty, let url = URL(string: photo.largeImageURL) else {
                assertionFailure("Invalid or empty URL for image")
                return
            }
            
            viewController.imageURL = url
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let imageListCell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier,
            for: indexPath
        ) as? ImagesListCell else {
            return UITableViewCell()
        }
        configCell(for: imageListCell, with: indexPath)
        imageListCell.delegate = self
        
        return imageListCell
    }
    
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        let isPhotoLiked = !photo.isLiked
        
        imageListService.changeLike(photoId: photo.id, isLike: isPhotoLiked) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    guard let self = self else { return }
                    
                    if let index = self.photos.firstIndex(where: { $0.id == photo.id }) {
                        self.photos[index].isLiked = isPhotoLiked
                    }
                    
                    cell.setIsLiked(isLiked: isPhotoLiked)
                    UIBlockingProgressHUD.dismiss()
                case .failure:
                    print("Error")
                    UIBlockingProgressHUD.dismiss()
                }
            }
        }
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        
        if let url = URL(string: photo.largeImageURL) {
            
            cell.cellImage.kf.indicatorType = .activity
            let placeholder = UIImage(named: "vvv")
            cell.cellImage.contentMode = .center
            
            cell.cellImage.kf.setImage(
                with: url,
                placeholder: placeholder,
                options: nil,
                progressBlock: nil
            ) { [weak self] result in
                switch result {
                case .success:
                    
                    DispatchQueue.main.async {
                        cell.cellImage.contentMode = .scaleAspectFill
                        self?.tableView.beginUpdates()
                        self?.tableView.endUpdates()
                    }
                case .failure(let error):
                    print("Error loading image: \(error)")
                }
            }
            
            cell.dateLabel.text = dateFormatter.string(from: Date())
            
            let likeImage = UIImage(named: photo.isLiked ? "Active" : "NoActive")
            cell.likeButton.setImage(likeImage, for: .normal)
        }
    }
}
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = photos[indexPath.row]
        _ = URL(string: photo.largeImageURL)
        
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
        
    }
    
}

