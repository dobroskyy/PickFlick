//
//  HistoryViewController.swift
//  PickFlick
//
//  Created by Максим Доброжинский on 03.11.2025.
//

import UIKit

class HistoryViewController: UIViewController {
    
    private var history: [ViewedMovie] {
        return MovieHistoryManager.shared.getHistory()
    }
    var networkService: NetworkService
    
    lazy var historyTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HistoryCustomCell.self, forCellReuseIdentifier: "HistoryCustomCell")
        return tableView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(historyTableView)
        view.backgroundColor = .white
        historyTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            historyTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            historyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            historyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            historyTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        historyTableView.reloadData()
    }
    
    init(networkService: NetworkService) {
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCustomCell", for: indexPath) as! HistoryCustomCell
        let viewedMovie = history[indexPath.row]
        cell.configure(with: viewedMovie, networkService: networkService)
        return cell
    }
}

extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
}
