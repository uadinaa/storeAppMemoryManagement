//
//  FeedView.swift
//  storeAppMemoryManagement
//
//  Created by Дина Абитова on 20.02.2025.
//
import UIKit

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView()
    private let feedSystem = FeedSystem()
    private var selectedCategory: String? = nil
    private let categories = ["electronics", "clothing", "books", "games"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

    }

    private func setupUI() {
        view.backgroundColor = .white
        title = "posts"
        
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PostCell.self, forCellReuseIdentifier: "PostCell")
    
        view.addSubview(tableView)

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPost))

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "filer", style: .plain, target: self, action: #selector(selectCategory))
    }

    @objc private func addPost() {
        askForProductName()
    }
    
    private func askForProductName() {
        let alert = UIAlertController(title: "product name", message: "enter product name", preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "name" }
        alert.addAction(UIAlertAction(title: "next", style: .default) { [weak self] _ in
            guard let productName = alert.textFields?.first?.text, !productName.isEmpty else { return }
            self?.askForDescription(name: productName)
        })
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func askForDescription(name: String) {
        let alert = UIAlertController(title: "product description", message: "add description", preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "condition/color/discounts" }
        alert.addAction(UIAlertAction(title: "next", style: .default) { [weak self] _ in
            guard let description = alert.textFields?.first?.text, !description.isEmpty else { return }
            self?.askForPrice(name: name, description: description)
        })
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func askForPrice(name: String, description: String) {
        let alert = UIAlertController(title: "product price", message: "enter price", preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "price in $"; $0.keyboardType = .decimalPad }
        alert.addAction(UIAlertAction(title: "next", style: .default) { [weak self] _ in
            guard let priceText = alert.textFields?.first?.text, let price = Double(priceText) else { return }
            self?.askForImageLink(name: name, description: description, price: price)
        })
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func askForImageLink(name: String, description: String, price: Double) {
        let alert = UIAlertController(title: "Image Link", message: "Enter the URL for the post image", preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Image URL" }
        
        alert.addAction(UIAlertAction(title: "Next", style: .default) { [weak self] _ in
            guard let imageLink = alert.textFields?.first?.text, !imageLink.isEmpty else { return }
            self?.askForCategory(name: name, description: description, price: price, image: imageLink)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    private func askForCategory(name: String, description: String, price: Double, image: String) {
        let alert = UIAlertController(title: "Choose Category", message: nil, preferredStyle: .actionSheet)
        
        for category in categories {
            alert.addAction(UIAlertAction(title: category, style: .default) { [weak self] _ in
                self?.finalizePost(name: name, description: description, price: price, image: image, category: category)
            })
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    private func finalizePost(name: String, description: String, price: Double, image: String, category: String) {
        let newPost = Post(
            id: UUID(),
            authorId: UUID(),
            authorInfo: "Dinka +7 702 95 45",
            content: "\(name) - \(description)",
            category: category,
            price: price,
            image: image // почему то тут была ссылка
        )
        
        feedSystem.addPost(newPost)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return feedSystem.getPosts(category: selectedCategory).count
        }
        
        @objc private func selectCategory() {
            let categoryPicker = UIAlertController(title: "chose category", message: nil, preferredStyle: .actionSheet)
            for category in categories {
                categoryPicker.addAction(UIAlertAction(title: category, style: .default) { [weak self] _ in
                    self?.selectedCategory = category
                    self?.tableView.reloadData()
                })
            }
            categoryPicker.addAction(UIAlertAction(title: "see all posts", style: .destructive) { [weak self] _ in
                self?.selectedCategory = nil
                self?.tableView.reloadData()
            })
            categoryPicker.addAction(UIAlertAction(title: "cancel", style: .cancel))
            present(categoryPicker, animated: true)
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        let post = feedSystem.getPosts(category: selectedCategory)[indexPath.row]
        cell.configure(with: post)
        return cell
    }
}
