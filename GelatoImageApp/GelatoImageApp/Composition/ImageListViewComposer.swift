//
//  ImageListViewComposer.swift
//  GelatoImageApp
//
//  Created by RN on 12/07/21.
//

import Foundation

class ImageListViewComposer {
    class func composeImageListViewController() -> ImageListViewController {
        let client = HTTPSessionClient()
        let remoteImageLoader = RemoteLoader<[ImageItem]>(url: URL(string: "https://picsum.photos/v2/list")!, client: client, mapper: ImageItemParser.parseData)

        let storage = UserdefaultsImageItemStore()

        let fileStorageURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("AppImages")
        makeSureURLExits(at: fileStorageURL)
        let localImageStore = LocalFileStore(storeURL: fileStorageURL)
        let localImageDataLoader = LocalImageDataLoader(store: localImageStore)


        let remoteImageDataLoader = RemoteLoader(client: client, mapper: ImageDataParser.parseData)


        let cacheImageDecorator = ImageDataLoaderCacheDecorator(loader: remoteImageDataLoader, storage: localImageStore)

        let imageLoaderFallback = ImageDataLoaderFallbackDecorator(primary: localImageDataLoader, fallback: cacheImageDecorator)

        let localItemLoader = LocalImageItemLoader(storage: storage)

        let cacheItemLoader = ImageItemLoaderCacheDecorator(loader: remoteImageLoader, storage: localItemLoader)

        let fallbackLoader = ImageItemLoaderFallbackDecorator(primary: localItemLoader, fallback: cacheItemLoader)

        let controller = ImageListViewController.instantiate()

        let weakController = WeakRefAdapter(controller)

        let imageDataCompressionLoader = ImageDataCompresionDecorator(imageDataLoader: imageLoaderFallback)

        let adapter = ImageListPresenterAdapter(weakController, imageDataLoader: imageLoaderFallback, imageDataCompressionLoader: imageDataCompressionLoader)


        let mainQueueAdapter = MainQueueAdapter(adapter)

        let presenter = ImageListPresenter(imageListView: mainQueueAdapter, loader: fallbackLoader)

        controller.presenter = presenter
        return controller

    }

    class func makeSureURLExits(at url: URL) {
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print(error)
            // handle error user-case here
        }
    }
}
