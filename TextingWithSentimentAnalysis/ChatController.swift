//
//  ChatController.swift
//  TextingWithSentimentAnalysis
//
//  Created by Prudhvi Gadiraju on 7/23/19.
//  Copyright © 2019 Prudhvi Gadiraju. All rights reserved.
//

import UIKit

class ChatController: UIViewController {
    
    fileprivate var cellIdentifier = "textCell"
    fileprivate var messages = [String]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
    }
    
    @objc func handleAdd() {
        messages.append("This is a new message wow!")
        tableView.reloadData()
    }
}

// MARK: - Helpers

extension ChatController {
    fileprivate func setupNavBar() {
        navigationItem.title = "Chat"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
    }
}

// MARK: - TableView

extension ChatController: UITableViewDelegate, UITableViewDataSource {
    fileprivate func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .interactive
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = messages[indexPath.row]
        cell.textLabel?.textAlignment = indexPath.row.isMultiple(of: 2) ? .left : .right
        return cell
    }
}
