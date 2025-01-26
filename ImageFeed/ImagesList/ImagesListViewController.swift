//
//  ViewController.swift
//  ImageFeed
//
//  Created by Anastasiia on 21.11.2024.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController, ViewControllerProtocol {
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    @IBOutlet private var tableView: UITableView!
    
    private var imageListServise = ImagesListService()
    
  //  private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    
    var photos: [Photo] = []
    
    private var alertPresenter: AlertPresenter?
    
    private var isLoading = false
    
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
        
        
        
        imageListServise.fetchImages() { [weak self] result in
            switch result {
            case .success(let photos):
                        self?.photos = photos
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }
                print("\(photos)")
            case.failure(let error):
                let alertModel = AlertModel(title: "Ошибка", message: "Не удалось загрузить изображение.", buttonText: "OK", completion: nil)
                self?.alertPresenter?.alert(alertData: alertModel)
            }
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
            let photo = photos[indexPath.row]
            
            let url = URL(string: photo.thumbImageURL)
            viewController.imageView.kf.setImage(with: url)
            
            //UIImage(named: "Stub")
//            viewController.imageView.kf.indicatorType = .image(imageData: Data()
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
        
        return imageListCell
    }
    }


extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        
        if let url = URL(string: photo.largeImageURL) {
            cell.cellImage.kf.setImage(with: url)
         
            cell.dateLabel.text = dateFormatter.string(from: Date())
            
            let isLiked = indexPath.row % 2 == 0
            let likeImage = isLiked ? UIImage(named: "Active") : UIImage(named: "NoActive")
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
        let url = URL(string: photo.largeImageURL)
        
//        guard let image = UIImage(named: photosName[indexPath.row]) else {
//            return 0
//        }
//        let photo = photos[indexPath.row]
//               guard let url = URL(string: photo.largeImageURL), let image = try? UIImage(data: Data(contentsOf: url)) else {
//                   return 0
//
//               }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight

    }
//    func loadingImage() {
//        if isLoading == true {
//        ImageLi = UIImage(named: "Stub")
//        }
//}
}
