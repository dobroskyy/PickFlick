//
//  RandomMovieViewController.swift
//  PickFlick
//
//  Created by Максим Доброжинский on 29.10.2025.
//

import UIKit

class RandomMovieViewController: UIViewController {
    
    var movies: Set<Movie> = []
    var currentMovie: Movie?
    let networkService = NetworkService()
    
    let infoAlert: UIAlertController = {
        let alert = UIAlertController()
        alert.message = "Список пуст"
        alert.addAction(.init(title: "Назад", style: .cancel))
        return alert
    }()
    
    let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
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
    
    lazy var moreDetailsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("More Details", for: .normal)
        button.addTarget(self, action: #selector(showMoreDetails), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    lazy var showHistoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Посмотреть историю", for: .normal)
        button.addTarget(self, action: #selector(showViewedHistory), for: .touchUpInside)
        
        return button
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
                movies = try await Set(networkService.fetchMovies())
                currentFilmCountLabel.text = "Загружено \(movies.count) фильмов"
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
        
        moreDetailsButton.isHidden = false
        movieTitleLabel.text = randomMovie.title
        currentMovie = randomMovie
        MovieHistoryManager.shared.saveViewedMovie(ViewedMovie(movie: randomMovie, viewedDate: Date()))
        movies.remove(randomMovie)
        currentFilmCountLabel.text = "Загружено \(movies.count) фильмов"
        
        guard let posterURL = randomMovie.fullPosterURL else {
            posterOfMovie.image = UIImage(systemName: "film")
            return
        }
        Task {
            do {
                let imageData = try await networkService.fetchPosterData(posterURL: posterURL)
                await MainActor.run {
                    posterOfMovie.image = UIImage(data: imageData)
                }
            } catch {
                await MainActor.run {
                    posterOfMovie.image = UIImage(systemName: "film")
                }
            }
        }
    }
    
    @objc func showMoreDetails() {
        guard let currentMovie = currentMovie else {
            return
        }
        
        let vc = MovieDetailViewController(movie: currentMovie)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showViewedHistory() {
        
        guard !MovieHistoryManager.shared.getHistory().isEmpty else {
            self.present(infoAlert, animated: true)
            return
        }
        
        let vc = HistoryViewController(networkService: networkService)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupUI() {
        view.addSubview(movieTitleLabel)
        view.addSubview(randomButton)
        view.addSubview(activityIndicator)
        view.addSubview(currentFilmCountLabel)
        view.addSubview(posterOfMovie)
        view.addSubview(moreDetailsButton)
        view.addSubview(showHistoryButton)
        
        movieTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        randomButton.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        currentFilmCountLabel.translatesAutoresizingMaskIntoConstraints = false
        posterOfMovie.translatesAutoresizingMaskIntoConstraints = false
        moreDetailsButton.translatesAutoresizingMaskIntoConstraints = false
        showHistoryButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            showHistoryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showHistoryButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200),
            moreDetailsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            moreDetailsButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 170),
            posterOfMovie.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            posterOfMovie.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            posterOfMovie.widthAnchor.constraint(equalToConstant: 200),
            posterOfMovie.heightAnchor.constraint(equalToConstant: 300),
            movieTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            movieTitleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200),
            randomButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            randomButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 300),
            randomButton.widthAnchor.constraint(equalToConstant: 100),
            randomButton.heightAnchor.constraint(equalToConstant: 50),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200),
            currentFilmCountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentFilmCountLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -250)
            
        ])
        
    }
    
}
