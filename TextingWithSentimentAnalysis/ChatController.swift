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
    fileprivate let sentimentService = SentimentService()
    
    private lazy var chatToolbar: UIView = {
        let containerView = UIView()
        //containerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        containerView.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        containerView.addSubview(textField)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Type here"
        //textField.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        setupChat()
    }
    
    override var inputAccessoryView: UIView? { return chatToolbar }
    override var canBecomeFirstResponder: Bool { return true }
    
    @objc func handleAdd() {
        messages.append("This is a new message wow!")
        tableView.reloadData()
    }
}

// MARK: - Helpers

extension ChatController {
    fileprivate func setupNavBar() {
        navigationItem.title = "Chat"
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
        navigationController?.navigationBar.backgroundColor = .white
    }
    
    fileprivate func setupChat() {
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
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        cell.textLabel?.text = messages[indexPath.row]
        cell.textLabel?.textAlignment = indexPath.row.isMultiple(of: 2) ? .left : .right
        
        let sentiment = sentimentService.predictSentiment(of: "This is a new message wow!")
        cell.backgroundColor = sentiment.color
        
        return cell
    }
}
