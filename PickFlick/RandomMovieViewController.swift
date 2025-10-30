//
//  RandomMovieViewController.swift
//  PickFlick
//
//  Created by Максим Доброжинский on 29.10.2025.
//

import UIKit

class RandomMovieViewController: UIViewController {

    var movies: [Movie] = []
    let pageCounts = [1, 5, 10]
    let networkService = NetworkService()

    let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    let posterOfMovie: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "film")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let currentFilmCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    
    lazy var randomButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Pick a Flick", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(showRandomMovie), for: .touchUpInside)
        return button
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: pageCounts.map { pageValue in
            return String(pageValue)
        })
        control.selectedSegmentIndex = 2
        control.addTarget(self, action: #selector(loadMovies), for: .valueChanged)
        return control
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        loadMovies()
    }

    @objc func loadMovies() {
        activityIndicator.startAnimating()
        
        Task {
            
            defer { activityIndicator.stopAnimating() }
            
            do {
                movies = try await networkService.fetchMovies(pageCount: pageCounts[segmentedControl.selectedSegmentIndex])
                currentFilmCountLabel.text = "Showing \(movies.count) films"
                //showRandomMovie()
            } catch {
                movieTitleLabel.text = "Error: \(error.localizedDescription)"
            }
        }
        
    }
    
    @objc func showRandomMovie() {
        guard let randomMovie = movies.randomElement() else {
            movieTitleLabel.text = "No movies available"
            return
        }
        movieTitleLabel.text = randomMovie.title
        
        
        guard let posterURL = randomMovie.fullPosterURL else {
            posterOfMovie.image = UIImage(systemName: "film")
            return
        }
        
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: posterURL)
                if let image = UIImage(data: data) {
                    await MainActor.run {
                        posterOfMovie.image = image
                    }
                }
            } catch {
                await MainActor.run {
                    posterOfMovie.image = UIImage(systemName: "film")
                }
            }
        }
        
    }
    
    func setupUI() {
        view.addSubview(movieTitleLabel)
        view.addSubview(randomButton)
        view.addSubview(activityIndicator)
        view.addSubview(segmentedControl)
        view.addSubview(currentFilmCountLabel)
        view.addSubview(posterOfMovie)
        
        movieTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        randomButton.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        currentFilmCountLabel.translatesAutoresizingMaskIntoConstraints = false
        posterOfMovie.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            posterOfMovie.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            posterOfMovie.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            posterOfMovie.widthAnchor.constraint(equalToConstant: 200),
            posterOfMovie.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            movieTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            movieTitleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200)
            
        ])
        NSLayoutConstraint.activate([
            randomButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            randomButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 400)
            
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200)
            
        ])
        
        NSLayoutConstraint.activate([
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedControl.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -350)
            
        ])
        
        NSLayoutConstraint.activate([
            currentFilmCountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentFilmCountLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -300)
            
        ])
        
    }
    
}
