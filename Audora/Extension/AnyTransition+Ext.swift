//
//  AnyTransition+Ext.swift
//  Audora
//
//  Created by Rivaldo Fernandes on 23/03/25.
//

import SwiftUI

extension AnyTransition {
    static var slideUp: AnyTransition {
        .move(edge: .bottom).combined(with: .opacity)
    }
}
