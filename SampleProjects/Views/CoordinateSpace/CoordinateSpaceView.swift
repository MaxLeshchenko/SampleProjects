//
//  CoordinateSpaceView.swift
//  SampleProjects
//
//  Created by Maksym Leshchenko on 11.09.2022.
//

import SwiftUI

/// CGRect extension for getting the midpoint and origin for a rect
extension CGRect {
	var midPoint: CGPoint {
		CGPoint(x: self.midX, y: self.midY)
	}

	var topLeadingPoint: CGPoint {
		CGPoint(x: self.minX, y: self.minY)
	}
}

/// View extension for tracking the midpoint of a View
extension View {
	func setMidpointPreference() -> some View {
		self
			.overlay {
				GeometryReader { proxy in
					Color.clear.preference(key: MidpointPreferenceKey.self,
										   value: proxy.frame(in: CoordinateSpace.global).midPoint)
				}
			}
	}
}

/// PreferenceKey for tracking the origin (top-leading corner) of a View
struct SecondaryViewOriginPreferenceKey: PreferenceKey {
	static var defaultValue: CGPoint? = nil

	static func reduce(value: inout CGPoint?, nextValue: () -> CGPoint?) {
		guard let nextValue = nextValue() else { return }
		value = nextValue
	}
}

/// View extension for tracking the origin (top-leading corner) of a View
extension View {
	func setOriginPreference() -> some View {
		self
			.overlay {
				GeometryReader { proxy in
					Color.clear.preference(key: SecondaryViewOriginPreferenceKey.self,
										   value: proxy.frame(in: CoordinateSpace.global).topLeadingPoint)
				}
			}
	}
}

/// This is the main View of our app
struct CoordinateSpaceView: View {
	var body: some View {
		NavigationView {
//			Text("Primary pane")
			SecondaryView()
		}
	}
}

struct SecondaryView: View {
	// the origin (top-leading corner) of our List view, relative to the global coordinate space
	@State private var secondaryViewOrigin: CGPoint?

	// the midpoint of the View we're tracking inside the List
	@State private var trackedViewMidpoint: CGPoint?

	// the calculated position of our _orange circle_ overlay view
	@State private var overlayViewLocation: CGPoint?

	var body: some View {
		ZStack(alignment: .topLeading) {
			List {
				Text("Row 1")
				Text("Row 2")

				Color.red
					.frame(width: 20, height: 20)
					.setMidpointPreference()

				Text("Row 4")
				Text("Row 5")
			}
			.setOriginPreference()

			Circle()
				.foregroundColor(.orange)
				.frame(width: 20, height: 20)
				.offset(x: -10, y: -10)
				.offset(x: self.overlayViewLocation?.x ?? 0, y: self.overlayViewLocation?.y ?? 0)
		}
		.onPreferenceChange(SecondaryViewOriginPreferenceKey.self) { origin in
			self.secondaryViewOrigin = origin
			self.updateOverlayViewLocation()
		}
		.onPreferenceChange(MidpointPreferenceKey.self) { midpoint in
			self.trackedViewMidpoint = midpoint
			self.updateOverlayViewLocation()
		}
		.navigationTitle("Tracking rows")
		.navigationBarTitleDisplayMode(.inline)
	}

	private func updateOverlayViewLocation() {
		guard let secondaryViewOrigin = self.secondaryViewOrigin,
			  let trackedViewMidpoint = self.trackedViewMidpoint else {
			return
		}

		self.overlayViewLocation = CGPoint(x: trackedViewMidpoint.x - secondaryViewOrigin.x,
										   y: trackedViewMidpoint.y - secondaryViewOrigin.y)
	}
}

struct CoordinateSpaceView_Previews: PreviewProvider {
    static var previews: some View {
        CoordinateSpaceView()
    }
}
