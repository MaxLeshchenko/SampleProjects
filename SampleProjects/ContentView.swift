//
//  ContentView.swift
//  SampleProjects
//
//  Created by Maksym Leshchenko on 11.09.2022.
//

import SwiftUI

struct ContentView: View {
	var body: some View {
		NavigationView {
			List {
				NavigationLink("Coordinate Space", destination: CoordinateSpaceView())
			}
		}
		.navigationTitle("Code Samples")
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
