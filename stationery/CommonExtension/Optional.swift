//
//  Optional.swift
//  Isetan
//
//  Created by Kaung Soe on 10/7/19.
//  Copyright © 2019 codigo. All rights reserved.
//

import Foundation

public extension Optional {
    
    // apply a void function if the value present
    
    func then(_ f: (Wrapped) -> Void) {
        switch self {
        case .some(let value):
            f(value)
        case .none:
            return
        }
    }
    
    static func pure(_ x: Wrapped) -> Optional {
        .some(x)
    }
    
    func apply<B>(_ f: Optional<(Wrapped) -> B>) -> Optional<B> {
        switch (f, self) {
        case let (.some(fx), _):
            return self.map(fx)
        default:
            return .none
        }
    }
    
    static func <*> <B>(_ f: Optional<(Wrapped) -> B>, x: Optional) -> Optional<B> {
        x.apply(f)
    }
    
    func orElse(_ x: Wrapped) -> Wrapped {
        switch self {
        case .none: return x
        case .some(let v): return v
        }
    }

}

public extension Optional where Wrapped == String {
    
    var orEmpty: String {
        switch self {
        case .none: return ""
        case .some(let v): return v
        }
    }
    

}

public extension Optional where Wrapped == Double {
    
    var orEmpty: Double {
        switch self {
        case .none: return 0
        case .some(let v): return v
        }
    }
}
