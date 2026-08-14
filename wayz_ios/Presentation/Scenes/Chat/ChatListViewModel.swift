//
//  ChatListViewModel.swift
//  wayz_ios
//
//  Created by Macbook on 12/8/26.
//

import Observation
import Foundation



@Observable
final class ChatListViewModel{
    var users: [UserChat]
    var search: String
    
    init(users: [UserChat] = UserChat.mockUsers, search: String = ""){
        self.users = users;
        self.search = search;
    }
    
     var filteredChats: [UserChat] {
        guard !search.isEmpty else { return users }
        return users.filter { $0.name.localizedCaseInsensitiveContains(search) }
    }
}


