//
//  User.swift
//  Weibo
//
//  Created by sunny on 2017/7/5.
//
//

// 存放 用户信息
import Vapor
import FluentProvider
import HTTP


public struct WDate {
    let year: Int
    let month: Int
    let date: Int
    
    init(year: Int,
         month: Int,
         date: Int) {
        
        self.year = year
        self.month = month
        self.date = date
    }
}

public enum Gender {
    case female, male, notSure, unKnown
}

public final class User: Model {
    public let storage = Storage()
    
    // MARK: properties and db keys
    public static let idKey = "id"
    public static let usernameKey = "username"
    public static let birthdayKey = "birthday"
    public static let nicknameKey = "nickname"
    public static let phoneNumberKey = "phoneNumber"
    public static let emailKey = "email"
    public static let genderKey = "gender"
    public static let registDateKey = "registDate"
    
    public var username: String           // 用户名
    public var birthday: WDate            // 出生日期
    public var nickname: String           // 昵称
    public var phoneNumber: String        // 电话号码
    public var email: String              // 邮箱
    public var gender: Gender = .unKnown  // 性别
    public var registDate: WDate          // 注册时间
    
    
    init(username: String,
         birthday: WDate,
         nickname: String,
         phoneNumber: String,
         email: String,
         gender: Gender = .unKnown,
         registDate: WDate) {
        
        self.username = username
        self.birthday = birthday
        self.nickname = nickname
        self.phoneNumber = phoneNumber
        self.email = email
        self.gender = gender
        self.registDate = registDate
    }
    
    // MARK: Fluent Serialization
    
    /// Initializes the Post from the
    /// database row
    public init(row: Row) throws {
        username = try row.get(User.usernameKey)
        birthday = try row.get(User.birthdayKey)
        nickname = try row.get(User.nicknameKey)
        phoneNumber = try row.get(User.phoneNumberKey)
        email = try row.get(User.emailKey)
        gender = try row.get(User.genderKey)
        registDate = try row.get(User.registDateKey)
    }
    
    // Serializes the Post to the database
    public func makeRow() throws -> Row {
        var row = Row()
        try row.set(User.usernameKey, username)
        try row.set(User.birthdayKey, birthday)
        try row.set(User.nicknameKey, nickname)
        try row.set(User.phoneNumberKey, phoneNumber)
        try row.set(User.emailKey, email)
        try row.set(User.genderKey, gender)
        try row.set(User.registDateKey, registDate)
        return row
    }
    
}

// MARK: JSON

// How the model converts from / to JSON.
// For example when:
//     - Creating a new Post (POST /posts)
//     - Fetching a post (GET /posts, GET /posts/:id)
//
extension User: JSONConvertible {
    convenience public init(json: JSON) throws {
        try self.init(
            username: json.get(User.usernameKey),
            birthday: json.get(User.birthdayKey),
            nickname: json.get(User.nicknameKey),
            phoneNumber: json.get(User.phoneNumberKey),
            email: json.get(User.emailKey),
            gender: json.get(User.genderKey),
            registDate: json.get(User.registDateKey)
        )
    }
    
    public func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(User.idKey, id)
        try json.set(User.usernameKey, username)
        try json.set(User.birthdayKey, birthday)
        try json.set(User.nicknameKey, nickname)
        try json.set(User.phoneNumberKey, phoneNumber)
        try json.set(User.emailKey, email)
        try json.set(User.genderKey, gender)
        try json.set(User.registDateKey, registDate)
        return json
    }
}


// MARK: HTTP

// This allows Post models to be returned
// directly in route closures
extension User: ResponseRepresentable {}

// MARK: Update

// This allows the Post model to be updated
// dynamically by the request.
extension User: Updateable {
    public static var updateableKeys: [UpdateableKey<User>] {
        return [
            UpdateableKey(User.nicknameKey, String.self) {user, nickname in
                user.nickname = nickname
            },
            UpdateableKey(User.phoneNumberKey, String.self) {user, phoneNumber in
                user.phoneNumber = phoneNumber
            },
            UpdateableKey(User.emailKey, String.self) {user, email in
                user.email = email
            }
        ]
    }
}








