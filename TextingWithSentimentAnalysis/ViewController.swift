//
//  ViewController.swift
//  TextingWithSentimentAnalysis
//
//  Created by Prudhvi Gadiraju on 7/22/19.
//  Copyright © 2019 Prudhvi Gadiraju. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    fileprivate var cellIdentifier = "textCell"
    fileprivate var messages = [String]()
    
    private lazy var chatContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 80)
        return view
    }()
    
    private let chatLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservers()
        setupTableView()
        setupChatLabel()
    }
    
    deinit {
        removeObservers()
    }
}

// MARK: - Chat Stuff

extension ViewController {
    
}

// MARK: - Observers

extension ViewController {
    
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
    }
    
    @objc func handleKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let moveUp = (notification.name == UIResponder.keyboardWillShowNotification)
        
//        baseConstraint.constant = moveUp ? -keyboardHeight : 0
        
//        UIView.animate(duration, delay: 0, options: options,
//                                   animations: {
//                                    self.view.layoutIfNeeded()
//        },
//                                   completion: nil
//        )
    }
}

// MARK: - TableView

extension ViewController {
    fileprivate func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = messages[indexPath.row]
        cell.textLabel?.textAlignment = indexPath.row.isMultiple(of: 2) ? .left : .right
        return cell
    }
}
