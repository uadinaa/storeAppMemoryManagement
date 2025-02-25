//
//  Feed.swift
//  storeAppMemoryManagement
//
//  Created by Дина Абитова on 19.02.2025.
//
import UIKit

struct Post: Hashable, Codable {
    let id: UUID
    let authorId: UUID
    let authorInfo: String
    var content: String
    var category: String
    let price: Double
    let image: String

    // TODO: Implement Hashable
    // Consider: Which properties should be used for hashing?
    func hash(into hasher: inout Hasher){
        hasher.combine(id)
    }

    // TODO: Implement Equatable
    // Consider: When should two posts be considered equal?
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
}


class PaddedLabel: UILabel {
    var padding: UIEdgeInsets

    init(padding: UIEdgeInsets) {
        self.padding = padding
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        self.padding = .zero
        super.init(coder: coder)
    }

    override func drawText(in rect: CGRect) {
        let insets = padding
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + padding.left + padding.right,
                      height: size.height + padding.top + padding.bottom)
    }
}

class PaddedButton: UIButton {
    var padding: UIEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)

    override func contentRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}


class PostCell: UITableViewCell {
    
    private let postsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.green.cgColor
        return imageView
    }()
    
    private let imageLoader = ImageLoader()

    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    private let priceLabel: PaddedLabel = {
        let label = PaddedLabel(padding: UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6))
        label.font = .systemFont(ofSize: 14, weight: .bold)
            label.textColor = .systemGreen
            label.backgroundColor = UIColor.systemGray6
            label.layer.cornerRadius = 4
            label.clipsToBounds = true
            return label
    }()
    
    private let postsContentLabel: PaddedLabel = {
        let label = PaddedLabel(padding: UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4))
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let contactInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()

    
    private let saveButton: UIButton = {
            let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        button.setImage(UIImage(systemName: "bookmark")?.withConfiguration(config), for: .normal)
        button.tintColor = .black
        return button
    }()



    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        imageLoader.delegate = self
        
        let postInfoStack = UIStackView(arrangedSubviews: [postsContentLabel, UIView(), priceLabel])
        postInfoStack.axis = .horizontal
        postInfoStack.spacing = 4
        postInfoStack.alignment = .center
        postInfoStack.distribution = .equalSpacing //even spacing

        // Adjusting content compression resistance
        priceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        priceLabel.setContentCompressionResistancePriority(.required, for: .horizontal)


        
        let stackView = UIStackView(arrangedSubviews: [postsImage, categoryLabel, postInfoStack, contactInfoLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false

        
        contentView.addSubview(stackView)
        contentView.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            postsImage.heightAnchor.constraint(equalToConstant: 250),
    
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: -8),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            saveButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 25),
            saveButton.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with post: Post) {
        categoryLabel.text = "category: \(post.category)"
        postsContentLabel.text = post.content
        priceLabel.text = "$\(post.price)"
        contactInfoLabel.text = "contact: \(post.authorInfo)"
        if let imageUrl = URL(string: post.image) {
            imageLoader.loadImage(url: imageUrl)
        }
    }
}

    
class FeedSystem {
    // TODO: Implement cache storage
    // Consider: Which collection type is best for fast lookup?
    // Requirements: O(1) access time, storing UserProfile objects with UserID keys
    private var userCache: [UUID: UserProfile] = [:] //дикшинари

    // TODO: Implement feed storage
    // Consider: Which collection type is best for ordered data?
    // Requirements: Maintain post order, frequent insertions at the beginning
    
    private var feedPost: [Post] = [] // эррей вставска 0н, за то доступ о1, если инсертов было дофига то линкед лист был б удобнее
    // TODO: Implement hashtag storage
    // Consider: Which collection type is best for unique values?
    // Requirements: Fast lookup, no duplicates
    
    private var hashtags: Set<String> = [] // у сетов быстрый доступ и уникальность

    func addPost(_ post: Post) {
        // TODO: Implement post addition
        // Consider: Which collection operations are most efficient?
        feedPost.insert(post, at: 0)
    }
        
    func removePost(_ post: Post) {
        // TODO: Implement post removal
        // Consider: Performance implications of removal
        if let index = feedPost.firstIndex(where: { $0.id == post.id }) {
            feedPost.remove(at: index)
        }
    }
        
    func getPosts(category: String?) -> [Post] {
        if let category = category {
            return feedPost.filter { $0.category == category }
        }
        return feedPost
    }
    
    init() {
        loadSamplePosts()
    }
    
    private func loadPosts() {
        if let savedData = UserDefaults.standard.data(forKey: "savedPosts"),
            let savedPosts = try? JSONDecoder().decode([Post].self, from: savedData) {
            feedPost = savedPosts
        } else {
            loadSamplePosts()
        }
    }
    
    private func loadSamplePosts() {
        let samplePosts = [
            Post(id: UUID(), authorId: UUID(), authorInfo: "Asylbek +7 123 45 67", content: "iPhone 13, great condition", category: "electronics", price: 700, image: "https://www.stuff.tv/wp-content/uploads/sites/2/2021/10/img_5864.jpg?w=1080"),
            Post(id: UUID(), authorId: UUID(), authorInfo: "Alibek +7 098 76 54", content: "Bunker game, used couple times, in good condition", category: "games", price: 30, image: "https://static.next2u.ru/upload/cover/642-642/54/77/51/91/1a/9b/c1/b0/8d/e8/89/ef/88/46/86/a6.jpeg"),
            Post(id: UUID(), authorId: UUID(), authorInfo: "Olzhas +7 234 56 78", content: "Vintage Book Collection", category: "books", price: 50, image: "https://apollo.olx.in/v1/files/t7of0qnfgca6-IN/image;s=360x0"),
            Post(id: UUID(), authorId: UUID(), authorInfo: "Serik +7 987 65 43", content: "Alexander Julian × Designer × Leather Jacket Vintage, size M", category: "clothing", price: 86, image: "https://media-assets.grailed.com/prd/listing/temp/0fa87a46b9b84722a1ea6cdcbc41d470")
        ]
        feedPost.append(contentsOf: samplePosts)
    }
}


//  для загрузки изображения
extension PostCell: ImageLoaderDelegate {
    func imageLoader(_ loader: ImageLoader, didLoad image: UIImage) {
        postsImage.image = image
    }

    func imageLoader(_ loader: ImageLoader, didFailWith error: Error) {
        print("Failed to load image: \(error.localizedDescription)")
    }
}
