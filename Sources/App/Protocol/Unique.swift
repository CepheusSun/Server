//
//  Unique.swift
//  Weibo
//
//  Created by sunny on 2017/7/5.
//
//

import Foundation

/// 判断对象是否唯一的协议
public protocol Unique {
    associatedtype Key: CustomStringConvertible
    func identifier() -> Key
}

extension Unique {
    public func string() -> String {
        return String(describing: identifier())
    }
}
