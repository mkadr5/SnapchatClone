//
//  UserSingleton.swift
//  SnapchatClone
//
//  Created by Muhammet Kadir on 13.03.2023.
//

import Foundation
class UserSingleton{
    static let sharedUserInfo = UserSingleton()
    
    var email = ""
    var username = ""
    
    private init(){
        
    }
}
