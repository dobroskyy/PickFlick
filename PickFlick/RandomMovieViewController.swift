//
//  RandomMovieViewController.swift
//  PickFlick
//
//  Created by Максим Доброжинский on 29.10.2025.
//

import UIKit

class RandomMovieViewController: UIViewController {

    var movies: [String] = []
    let networkService = NetworkService()

    let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Loading..."
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    
    lazy var randomButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Pick a Flick", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(didButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        loadMovies()
    }

    func loadMovies() {
        activityIndicator.startAnimating()
        
        Task {
            do {
                movies = try await networkService.fetchMovieTitles()
                movieTitleLabel.text = "Tap button to pick a flick!"
            } catch {
                movieTitleLabel.text = "Error: \(error.localizedDescription)"
            }
        }
        activityIndicator.stopAnimating()
    }
    
    @objc func didButtonTapped() {
        guard let randomMovie = movies.randomElement() else {
            movieTitleLabel.text = "No movies available"
            return
        }
        movieTitleLabel.text = randomMovie
    }
    
    func setupUI() {
        view.addSubview(movieTitleLabel)
        view.addSubview(randomButton)
        view.addSubview(activityIndicator)
        
        movieTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        randomButton.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            movieTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            movieTitleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            
        ])
        NSLayoutConstraint.activate([
            randomButton.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor, constant: 20),
            randomButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200)
            
        ])
        
    }
    
}
