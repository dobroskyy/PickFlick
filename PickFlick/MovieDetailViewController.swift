//
//  MovieDetailViewController.swift
//  PickFlick
//
//  Created by Максим Доброжинский on 31.10.2025.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    let movie: Movie
    
    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    let voteAverageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        super.viewDidLoad()
        setupUI()
        Task {
            await fetchImage()
        }
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        voteAverageLabel.text = "Vote average: \(movie.voteAverage)"
        releaseDateLabel.text = "Release date: \(movie.releaseDate)"
    }
    
    func fetchImage() async {
        guard let posterURL = movie.fullPosterURL else {
            posterImageView.image = UIImage(systemName: "film")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: posterURL)
            if let image = UIImage(data: data) {
                await MainActor.run {
                    posterImageView.image = image
                }
            }
        } catch {
            await MainActor.run {
                posterImageView.image = UIImage(systemName: "film")
            }
        }
    }
    
    func setupUI() {
        view.addSubview(posterImageView)
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(voteAverageLabel)
        view.addSubview(releaseDateLabel)
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        voteAverageLabel.translatesAutoresizingMaskIntoConstraints = false
        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: 300),
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            voteAverageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            voteAverageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            releaseDateLabel.leadingAnchor.constraint(equalTo: voteAverageLabel.trailingAnchor, constant: 16),
            releaseDateLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
            overviewLabel.topAnchor.constraint(equalTo: voteAverageLabel.bottomAnchor, constant: 16),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            overviewLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
        
    }
    
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
