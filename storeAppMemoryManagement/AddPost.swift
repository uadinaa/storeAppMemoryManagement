//
//  AddPost.swift
//  storeAppMemoryManagement
//
//  Created by Дина Абитова on 20.02.2025.
//

//import UIKit
//
//protocol AddPostDelegate: AnyObject {
//    func didAddPost()
//}
//
//class AddPostView: UIViewController {
//    
//    weak var delegate: AddPostDelegate?
//    private let currentUserId = UUID()
//    private let categories = ["electronics", "clothing", "books", "games"]
//    
//    private let emptyLabel: UILabel = {
//        let label = UILabel()
//        label.text = "No posts yet"
//        label.textAlignment = .center
//        label.textColor = .gray
//        label.isHidden = true
//        return label
//    }()
//    
//    private func savePost(name: String, description: String, price: Double, category: String) {
//        let newPost = Post(
//            id: UUID(),
//            authorId: currentUserId,
//            authorInfo: "Sarah +7 123 45 67",
//            content: "\(name) - \(description)",
//            category: category,
//            price: price
//        )
//        
//        var posts = loadAllPosts() // Load all posts, not filtered ones
//        posts.append(newPost)   // Adds the new post
//        savePosts(posts)        // Saves updated posts
//        
//        delegate?.didAddPost()  // Notifies feed
//        dismiss(animated: true)
//        
//    }
//    
//    private func loadAllPosts() -> [Post] {
//        guard let data = UserDefaults.standard.data(forKey: "userPosts"),
//              let savedPosts = try? JSONDecoder().decode([Post].self, from: data) else {
//            return []
//        }
//        return savedPosts // ✅ Returns all posts, not filtered ones
//    }
//    
//    private func loadPosts() -> [Post] {
//        return loadAllPosts().filter { $0.authorId == currentUserId }
//    }
//    
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        title = "Add Post"
//        
//        emptyLabel.frame = view.bounds
//        view.addSubview(emptyLabel)
//        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPost))
//        
//        //    private func setupUI() {
//        //        let addButton = UIButton(type: .system)
//        //        addButton.setTitle("Add Post", for: .normal)
//        //        addButton.addTarget(self, action: #selector(addPost), for: .touchUpInside)
//        //        addButton.frame = CGRect(x: 50, y: view.bounds.height - 100, width: 200, height: 50)
//        //        view.addSubview(addPost())
//        //    }
//        //
//        //    private func setupUI() {
//        //        view.backgroundColor = .white
//        //        title = "Posts"
//        //        askForProductName
//        
//        //        tableView.frame = view.bounds
//        //        tableView.delegate = self
//        //        tableView.dataSource = self
//        //        tableView.register(PostCell.self, forCellReuseIdentifier: "PostCell")
//        //        view.addSubview(tableView)
//        
//        
//        //        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "filer", style: .plain, target: self, action: #selector(selectCategory))
//        
//        //        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openAddPostPage))
//    }
//    
//    private func savePosts(_ posts: [Post]) {
//        UserDefaults.standard.set(try? JSONEncoder().encode(posts), forKey: "userPosts")
//    }
//    
//    @objc private func addPost() {
//        askForProductName()
//    }
//    private func askForProductName() {
//        let alert = UIAlertController(title: "Product Name", message: "Enter product name", preferredStyle: .alert)
//        alert.addTextField { $0.placeholder = "Name" }
//        alert.addAction(UIAlertAction(title: "Next", style: .default) { [weak self] _ in
//            guard let productName = alert.textFields?.first?.text, !productName.isEmpty else { return }
//            self?.askForDescription(name: productName)
//        })
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
//            self?.dismiss(animated: true)
//        })
//        present(alert, animated: true)
//    }
//    
//    private func askForDescription(name: String) {
//        let alert = UIAlertController(title: "Product Description", message: "Add description", preferredStyle: .alert)
//        alert.addTextField { $0.placeholder = "Condition/Color/Discounts" }
//        alert.addAction(UIAlertAction(title: "Next", style: .default) { [weak self] _ in
//            guard let description = alert.textFields?.first?.text, !description.isEmpty else { return }
//            self?.askForPrice(name: name, description: description)
//        })
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//        present(alert, animated: true)
//    }
//    
//    private func askForPrice(name: String, description: String) {
//        let alert = UIAlertController(title: "Product Price", message: "Enter price", preferredStyle: .alert)
//        alert.addTextField { $0.placeholder = "Price in $"; $0.keyboardType = .decimalPad }
//        alert.addAction(UIAlertAction(title: "Next", style: .default) { [weak self] _ in
//            guard let priceText = alert.textFields?.first?.text, let price = Double(priceText) else { return }
//            self?.askForCategory(name: name, description: description, price: price)
//        })
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//        present(alert, animated: true)
//    }
//    
//    private func askForCategory(name: String, description: String, price: Double) {
//        let alert = UIAlertController(title: "Choose Category", message: nil, preferredStyle: .actionSheet)
//        for category in categories {
//            alert.addAction(UIAlertAction(title: category, style: .default) { [weak self] _ in
//                self?.savePost(name: name, description: description, price: price, category: category)
//            })
//        }
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//        present(alert, animated: true)
//    }
//    
//}




















//    private func savePost(name: String, description: String, price: Double, category: String) {
//        let newPost = Post(
//            id: UUID(),
//            authorId: UUID(),
//            authorInfo: "Sarah +7 123 45 67",
//            content: "\(name) - \(description)",
//            category: category,
//            price: price
//        )
//
//        var posts = loadPosts()
//        posts.append(newPost)
//        savePosts(posts)
//
//        dismiss(animated: true)
//    }

//    private func loadPosts() -> [Post] {
//        
////        emptyLabel.isHidden = !posts.isEmpty
//        
//        if let savedData = UserDefaults.standard.data(forKey: "savedPosts"),
//           let decoded = try? JSONDecoder().decode([Post].self, from: savedData) {
//            return decoded
//        }
//        return []
//    }
//
//    private func savePosts(_ posts: [Post]) {
//        if let encoded = try? JSONEncoder().encode(posts) {
//            UserDefaults.standard.set(encoded, forKey: "savedPosts")
//        }
//    }
    





//
////FOR THE FUTURE
//class FeedViewController: UIViewController {
//    private let tableView = UITableView()
//    private let emptyLabel = UILabel()
//    private let feedSystem = FeedSystem()
//    private var selectedCategory: String = ""
//    private var posts: [Post] = []
//    private let currentUserId = UUID() // Simulating a unique user ID
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        setupUI()
//        loadPosts()
//    }
//    
//    private func setupUI() {
//        // UI setup code
//    }
//
//@objc private func addPost() {
//        let addPostVC = AddPostView()
//        addPostVC.delegate = self
//        navigationController?.pushViewController(addPostVC, animated: true)
//    }
//    
//    private func loadPosts() {
//        posts = feedSystem.getPosts(category: selectedCategory, excludingUserId: currentUserId)
//        tableView.reloadData()
//        emptyLabel.isHidden = !posts.isEmpty
//    }
//}
//
//// MARK: - AddPostDelegate Implementation
//extension FeedViewController: AddPostDelegate {
//    func didAddPost() {
//        loadPosts()
//    }
//}
//
//// MARK: - Feed System
//class FeedSystem {
//    func getPosts(category: String, excludingUserId: UUID) -> [Post] {
//        guard let data = UserDefaults.standard.data(forKey: "posts"),
//              let allPosts = try? JSONDecoder().decode([Post].self, from: data) else {
//            return []
//        }
//        return allPosts.filter { $0.category == category && $0.authorId != excludingUserId }
//    }
//}
//

import UIKit


class ImageLoaderViewController: UIViewController {
    private let imageView = UIImageView()
    private let urlTextField = UITextField()
    private let loadButton = UIButton(type: .system)
    private var imageLoader = ImageLoader()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        imageLoader.delegate = self
    }

    private func setupUI() {
        view.backgroundColor = .white

        urlTextField.placeholder = "paste the URL of your profile picture here"
        urlTextField.borderStyle = .roundedRect
        urlTextField.autocapitalizationType = .none

        loadButton.setTitle("upload", for: .normal)
        loadButton.addTarget(self, action: #selector(loadImage), for: .touchUpInside)

        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray

        let imageStackView = UIStackView(arrangedSubviews: [urlTextField, loadButton, imageView])
        imageStackView.axis = .vertical
        imageStackView.spacing = 10
        imageStackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(imageStackView)

        NSLayoutConstraint.activate([
            imageStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 200)

        ])
    }

    @objc private func loadImage() {
        guard let urlString = urlTextField.text, let url = URL(string: urlString) else {
            print("wrong URL")
            return
        }
        imageLoader.loadImage(url: url)
    }
}

// Расширение для обработки загрузки изображения
extension ImageLoaderViewController: ImageLoaderDelegate {
    func imageLoader(_ loader: ImageLoader, didLoad image: UIImage) {
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }

    func imageLoader(_ loader: ImageLoader, didFailWith error: Error) {
        print("error in uploading image:", error.localizedDescription)
    }
}




















