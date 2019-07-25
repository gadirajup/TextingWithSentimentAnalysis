//
//  ChatController.swift
//  TextingWithSentimentAnalysis
//
//  Created by Prudhvi Gadiraju on 7/23/19.
//  Copyright © 2019 Prudhvi Gadiraju. All rights reserved.
//

import UIKit

class ChatController: UIViewController {
    
    // MARK: - Properties
    
    fileprivate var tableViewBotConstraint: NSLayoutConstraint!
    
    fileprivate var cellIdentifier = "textCell"
    fileprivate var messages = [String]()
    fileprivate let sentimentService = SentimentService()
    
    override var inputAccessoryView: UIView? { return chatToolbar }
    override var canBecomeFirstResponder: Bool { return true }
    
    // MARK: - UI Elements
    
    fileprivate lazy var chatToolbar: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        containerView.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    fileprivate lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Type here"
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 4
        textField.delegate = self
        textField.setPadding(left: 8, right: 8)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    fileprivate lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SEND", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: 60).isActive = true
        return button
    }()
    
    fileprivate let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservers()
        setupNavBar()
        setupTableView()
        setupChat()
    }
    
    deinit {
        removeObservers()
    }
}

// MARK: - Helpers & Handlers

extension ChatController {
    fileprivate func setupNavBar() {
        navigationItem.title = "Chat"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.backgroundColor = .white
    }
    
    fileprivate func setupChat() {
        let chatStack = UIStackView(arrangedSubviews: [textField, sendButton])
        chatStack.axis = .horizontal
        chatStack.alignment = .center
        chatStack.distribution = .fillProportionally
        chatStack.translatesAutoresizingMaskIntoConstraints = false
        chatToolbar.addSubview(chatStack)
        chatStack.anchor(top: chatToolbar.topAnchor, leading: chatToolbar.leadingAnchor, bottom: chatToolbar.bottomAnchor, trailing: chatToolbar.trailingAnchor, padding: .init(top: 4, left: 8, bottom: 4, right: 8))
    }
    
    @objc fileprivate func handleSend(){
        guard textField.hasText else { return }
        add(message: textField.text!)
        textField.text = ""
    }
    
    @objc fileprivate func add(message: String) {
        messages.insert(message, at: 0)
        tableView.reloadData()
    }
}

// MARK: - Chat

extension ChatController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}

// MARK: - Observers

extension ChatController {
    fileprivate func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardChange), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardChange), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardChange), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    }
    
    fileprivate func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    }
    
    @objc fileprivate func handleKeyboardChange(notification: Notification) {
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject
        let keyboardHeight = keyboardFrame.cgRectValue.height
        tableViewBotConstraint.constant = keyboardHeight == 0 ? 0 : -keyboardHeight
        view.layoutIfNeeded()
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
        tableViewBotConstraint = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        tableViewBotConstraint.isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        cell.textLabel?.text = messages[indexPath.row]
        cell.textLabel?.textAlignment = .right
        
        let sentiment = sentimentService.predictSentiment(of: messages[indexPath.row])
        cell.textLabel?.text?.append(sentiment.emoji)
        
        return cell
    }
}
