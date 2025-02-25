//
//  User.swift
//  storeAppMemoryManagement
//
//  Created by Дина Абитова on 20.02.2025.
//

import Foundation

//хэшибл добавила, потому что
struct UserProfile : Hashable, Codable{
    let id: UUID
    let username: String
    let email: String
    let phone: String  // Make sure it's Optional if not always available
    let profileImageUrl: String?
    var bio: String
    
//    let profileImageUrl: String
//    var followers: Int
    
    // TODO: Implement Hashable
    // Consider: Which properties should be used for hashing?
    // Remember: Only use immutable properties

    func hash(into hasher: inout Hasher) {
        hasher.combine(id) //тут у нас берется значение айди и обновляет текущее значение хэшиера(он же алгоритм который берет данные и преврашает их у уникальный хэш валью
    }
    
    // TODO: Implement Equatable
    // Consider: Which properties determine equality?
    static func == (lhs: UserProfile, rhs: UserProfile) -> Bool {
        return lhs.id == rhs.id // if accounts have same id, it means they are equal
    }
    
}


class User: ProfileUpdateDelegate {
    func profileDidUpdate(_ profile: UserProfile) {
        print("profile updated: \(profile.username)")
    }
    
    func profileLoadingError(_ error: any Error) {
        print("error in loading profile: \(error.localizedDescription)")
    }
    
    
    // TODO: Consider reference type for these properties
    var profileManager: ProfileManager? // сильная ссылка
    var imageLoader: ImageLoader?
    
    func setupProfileManager() {
        // TODO: Implement setup
        // Think: What reference type should be used in closure?§
        profileManager = ProfileManager(delegate: self)
        profileManager?.onProfileUpdate = { [weak self] profile in //тут уик что б юзер контреллер и профайл мэнэджер не удерживали друг другаб при удалении котроллера он коректно освобождается
            guard let self = self else { return }
            print("profile updated: \(profile.username)")
        }
    }
    
    func updateProfile() {
        // TODO: Implement profile update
        // Consider: How to handle closure capture list?
        let profileId = "your-profile-id-here"
        profileManager?.loadProfile(id: profileId) { [weak self] result in //тут что б что б мэнеджер не захватил селф и не было утечки памяти
            guard let self = self else { return } // если селфа нет, он не будет выполнить код в замыкании
            switch result {
//            case .success(let profile):
//                
//                var updatedProfile = profile
//                updatedProfile.bio = "Updated bio"
//                self.profileManager?.onProfileUpdate?(updatedProfile)
            case .success(let profile):
                print("Loaded profile: \(profile.username)")
                
            case .failure(let error):
                print("Error loading profile: \(error)")
            }
        }
    }
}


