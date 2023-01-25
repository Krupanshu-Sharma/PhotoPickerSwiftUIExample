//
//  PhotosPickerSwiftUIApp.swift
//  PhotosPickerSwiftUI
//
//  Created by Krupanshu Sharma on 25/01/23.
//

import SwiftUI

@main
struct PhotosPickerSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(photoItem: GalleryItem())
        }
    }
}
