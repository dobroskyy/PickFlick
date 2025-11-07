//
//  HistoryCustomCell.swift
//  PickFlick
//
//  Created by Максим Доброжинский on 03.11.2025.
//

import UIKit

class HistoryCustomCell: UITableViewCell {
    
    var currentTask: Task<Void, Never>?
    
    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .white
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        return label
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .gray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        currentTask?.cancel()
        posterImageView.image = UIImage(systemName: "film")
        
    }
    
    func setupUI() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            posterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 50),
            posterImageView.heightAnchor.constraint(equalToConstant: 75),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            dateLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 12),
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with viewedMovie: ViewedMovie, networkService: NetworkService) {
        titleLabel.text = viewedMovie.movie.title
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ru_RU")
        dateLabel.text = formatter.string(from: viewedMovie.viewedDate)
        guard let posterURL = viewedMovie.movie.fullPosterURL else {
            posterImageView.image = UIImage(systemName: "film")
            return
        }
        currentTask = Task {
            do {
                let imageData = try await networkService.fetchPosterData(posterURL: posterURL)
                await MainActor.run {
                    posterImageView.image = UIImage(data: imageData)
                }
            } catch {
                await MainActor.run {
                    posterImageView.image = UIImage(systemName: "film")
                }
            }
        }
    }
}
