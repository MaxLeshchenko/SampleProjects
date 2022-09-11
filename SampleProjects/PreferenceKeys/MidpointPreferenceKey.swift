//
//  MidpointPreferenceKey.swift
//  SampleProjects
//
//  Created by Maksym Leshchenko on 11.09.2022.
//

import SwiftUI

/// PreferenceKey for tracking the midpoint of a View
struct MidpointPreferenceKey: PreferenceKey {
	static var defaultValue: CGPoint? = nil

	static func reduce(value: inout CGPoint?, nextValue: () -> CGPoint?) {
		guard let nextValue = nextValue() else { return }
		value = nextValue
	}
}
