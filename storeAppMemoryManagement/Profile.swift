//
//  Profile.swift
//  storeAppMemoryManagement
//
//  Created by Дина Абитова on 19.02.2025.
//
//

import Foundation
import UIKit

protocol ProfileUpdateDelegate: AnyObject {
    func profileDidUpdate(_ profile: UserProfile)
    func profileLoadingError(_ error: Error)
}

class ProfileManager {
    // TODO: Think about appropriate storage type for active profiles
    private var activeProfiles: [String: UserProfile] = [:]
    
    // TODO: Consider reference type for delegate
    weak var delegate: ProfileUpdateDelegate? // added weak here because the connection should week for delegate или это может привести к retain cycle, и что б мемори ликов не было
    
    // TODO: Think about reference management in closure
    var onProfileUpdate: ((UserProfile) -> Void)?
    
    init(delegate: ProfileUpdateDelegate) {
        // TODO: Implement initialization
        
        self.delegate = delegate // используется в иницилизаторе что б присвоить свойста делегейт значение класса, которые передается как параметр
    }
    
    func loadProfile(id: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        // TODO: Implement profile loading
        // Consider: How to avoid retain cycle in completion handler?
        if let profile = activeProfiles[id] {
            completion(.success(profile))  // Если профиль есть, передаем его в completion
        } else {
            completion(.failure(NSError(domain: "ProfileNotFound", code: 404, userInfo: nil)))
        }
    }
    
}

class ProfileViewController: UIViewController {
    private let imageView = UIImageView()
    
    private let urlTextField = UITextField()
    private let loadButton = UIButton(type: .system)
    private var imageLoader = ImageLoader()

    private var profileImages: [String: UIImage] = [:] // Кэш для загруженных картинок

    private var nameLabel = UILabel()
    private var emailLabel = UILabel()
    private var phoneLabel = UILabel()
    private var bioLabel = UILabel()
    
    private var switchProfileButton = UIButton(type: .system)
    
    private var profileManager: ProfileManager?
    private var currentProfile: UserProfile?
    
    // Заранее заданные профили
    private var predefinedProfiles: [String: UserProfile] = [
        "Dinka": UserProfile(
            id: UUID(),
            username: "Dinka",
            email: "ne_pishi_mne@gmail.com",
            phone: "+7 702 95 45",
            profileImageUrl: "https://i.pinimg.com/736x/21/f7/ef/21f7efe2ca665baff1cebb4b196d550b.jpg",
            bio: "selling things to by a new bicycle"
        ),
        "Klara": UserProfile(
            id: UUID(),
            username: "Klara",
            email: "klara_apa@gmail.com",
            phone: "+7 777 99 99",
            profileImageUrl: "https://www.thesprucepets.com/thmb/A5Rkkt4HDWLAtUOk4gYybcX02mM=/1080x0/filters:no_upscale():strip_icc()/30078352_448703938920062_6275637137232625664_n-5b0de8c443a1030036f9e15e.jpg",
            bio: "i am an old woman, so i do not really need all my stuff"
        )
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        profileManager = ProfileManager(delegate: self)
        loadProfile(with: "Dinka") // Загружаем профиль по умолчанию
        imageLoader.delegate = self
    }

    
    private func setupUI() {
        
        urlTextField.placeholder = "paste the URL here"
        urlTextField.borderStyle = .roundedRect
        urlTextField.autocapitalizationType = .none

        loadButton.setTitle("upload", for: .normal)
        loadButton.addTarget(self, action: #selector(loadImage), for: .touchUpInside)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        imageView.layer.backgroundColor = UIColor.systemGray6.cgColor
        

        let imageStackView = UIStackView(arrangedSubviews: [urlTextField, loadButton, imageView])
        imageStackView.axis = .vertical
        imageStackView.spacing = 10
        imageStackView.translatesAutoresizingMaskIntoConstraints = false
                                   
        
        nameLabel.font = .systemFont(ofSize: 20, weight: .bold)
        phoneLabel.textColor = .systemBlue
        bioLabel.font = .systemFont(ofSize: 17)
        bioLabel.numberOfLines = 0
        bioLabel.textAlignment = .center
    
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        switchProfileButton.translatesAutoresizingMaskIntoConstraints = false
        switchProfileButton.setTitle("Switch Profile", for: .normal)
        switchProfileButton.addTarget(self, action: #selector(switchProfile), for: .touchUpInside)
        
        
        let stackView = UIStackView(arrangedSubviews: [imageStackView, nameLabel, emailLabel, phoneLabel, bioLabel, switchProfileButton])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
    }
    
    private func loadProfile(with username: String) {
        if let profile = predefinedProfiles[username] {
            currentProfile = profile
            DispatchQueue.main.async {
                self.updateUI(with: profile)
            }
        } else {
            let error = NSError(domain: "ProfileError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Profile not found"])
            self.profileLoadingError(error) // Вызов метода напрямую
        }
    }


    @objc private func loadImage() {
        guard let urlString = urlTextField.text, let url = URL(string: urlString) else {
            print("wrong URL")
            return
        }
        imageLoader.loadImage(url: url)
    }
    
    private func updateUI(with profile: UserProfile) {
        nameLabel.text = profile.username
        emailLabel.text = profile.email
        phoneLabel.text = profile.phone
        bioLabel.text = profile.bio
        
        // load stored image if available
        if let savedImage = profileImages[profile.username] {
            imageView.image = savedImage
        } else {
            imageView.image = nil // clear the image if there's no saved one
        }
    }
        

    @objc private func switchProfile() {
        let newProfile = (currentProfile?.username == "Dinka") ? "Klara" : "Dinka"
        loadProfile(with: newProfile)
    }

    
    private func loadUserPosts(for userId: UUID) {
        print("Loading posts for user: \(userId)")
    }
}


extension ProfileViewController: ProfileUpdateDelegate {
    func profileDidUpdate(_ profile: UserProfile) {
        DispatchQueue.main.async {
            self.updateUI(with: profile)
            self.loadUserPosts(for: profile.id) // Reload posts on profile update
        }
    }
    
    func profileLoadingError(_ error: Error) {
        print("Profile loading error: \(error.localizedDescription)")
    }
}


extension ProfileViewController: ImageLoaderDelegate {
    func imageLoader(_ loader: ImageLoader, didLoad image: UIImage) {
        DispatchQueue.main.async {
            guard let currentProfile = self.currentProfile else { return }
            self.profileImages[currentProfile.username] = image
            self.imageView.image = image
        }
    }


    func imageLoader(_ loader: ImageLoader, didFailWith error: Error) {
        print("error in uploading image:", error.localizedDescription)
    }
}
