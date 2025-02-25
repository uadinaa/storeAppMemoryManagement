//
//  usersAccount.swift
//  storeAppMemoryManagement
//
//  Created by Дина Абитова on 24.02.2025.
//

import Foundation

var predefinedProfiles: [String: UserProfile] = [
    "Dinka": UserProfile(
        id: UUID(),
        username: "Dinka",
        email: "ne_pishi_mne@gmail.com",
        phone: "+7 702 95 45",
        profileImageUrl: nil,
        bio: "selling things to by a new bicycle"
    ),
    "Klara": UserProfile(
        id: UUID(),
        username: "Klara",
        email: "klara_apa@gmail.com",
        phone: "+7 777 99 99",
        profileImageUrl: nil,
        bio: "i am an old woman, so i do not really need all my stuff"
    )
]
