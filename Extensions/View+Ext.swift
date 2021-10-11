//
//  View+Ext.swift
//  SwiftUI_MVVM
//
//  Created by Sam Kerridge on 28/09/21.
//


import SwiftUI

extension View {
    func eraseToAnyView() -> AnyView { AnyView(self) }
}
