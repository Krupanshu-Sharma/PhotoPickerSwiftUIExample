//
//  ContentView.swift
//  PhotosPickerSwiftUI
//
//  Created by Krupanshu Sharma on 25/01/23.
//

import SwiftUI
import PhotosUI

class GalleryItem: ObservableObject {
    var PhotoData: Data?
}

struct ContentView: View {
    
    // 1.
    @State private var photosPickerItem: PhotosPickerItem?
    @ObservedObject var photoItem: GalleryItem
    @MainActor @State private var isLoading = false
    
    let filter: PHPickerFilter = .not(.videos)

    var body: some View {
        VStack {
            PhotosPicker(selection: $photosPickerItem, matching: <#T##PHPickerFilter?#>) {
              Label("Select Photo", systemImage: "photo")
            }
            
            PhotoView(photoData: photoItem.PhotoData)
                .padding()
            
            if isLoading {
              ProgressView()
                .tint(.accentColor)
            }
        }
        .padding()
        .onChange(of: photosPickerItem) { selectedPhotosPickerItem in
          guard let selectedPhotosPickerItem else {
            return
          }

          Task {
            isLoading = true
            await updatePhotosPickerItem(with: selectedPhotosPickerItem)
            isLoading = false
          }
        }
    }
    
    // MARK: Private Functions
    private func updatePhotosPickerItem(with item: PhotosPickerItem) async {
      photosPickerItem = item

      if let photoData = try? await item.loadTransferable(type: Data.self) {
        photoItem.PhotoData = photoData
      }
    }
}

struct PhotoView: View {
    var photoData: Data?
    // MARK: Body
    var body: some View {
      if let photoData,
        let uiImage = UIImage(data: photoData) {
          let imageSize = 150.00

        Image(uiImage: uiImage)
          .resizable()
          .frame(width: imageSize, height: imageSize)
          .cornerRadius(10)
      } else {
          let imageSize = 100.00

        Image(systemName: "photo")
          .foregroundColor(.accentColor)
          .font(.system(size: imageSize))
      }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(photoItem: GalleryItem())
    }
}
