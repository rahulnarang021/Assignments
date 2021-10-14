//
//  ImageListSnapshotTests.swift
//  GelatoImageAppTests
//
//  Created by RN on 12/07/21.
//

import XCTest
@testable import GelatoImageApp

class ImageListSnapshotTests: XCTestCase {

    func test_loadImage_screenShouldDisplayLoaderCorrect() {
        let sut = makeSUT()
        sut.showLoader(viewModel: LoadingViewModel(message: "Loading Images"))
        assert(viewController: sut, name: "LOAD_IMAGE_ITEMS")
    }

    func test_emptyImage_screenShouldDisplayCorrectly() {
        let sut = makeSUT()
        sut.display(images: [])
        sut.hideLoader()
        assert(viewController: sut, name: "EMPTY_IMAGE_ITEMS")
    }

    func test_imageList_screenShouldDisplayCorrectly() {
        let sut = makeSUT()
        let dummyController1 = createDummyImageListCellController()
        let dummyController2 = createDummyImageListCellController()

        sut.display(images: [dummyController1.cellController, dummyController2.cellController])
        sut.simulateCollectionViewReloadData()
        
        let dummyImageData1 = dummyImageData(color: .green)
        let dummyImageData2 = dummyImageData(color: .blue)

        dummyController1.spy.makeImageLoadSuccess(with: dummyImageData1)
        dummyController2.spy.makeImageLoadSuccess(with: dummyImageData2)

        sut.hideLoader()
        let exp = expectation(description: "Image Item Reload")
        DispatchQueue.main.async { [weak self] in
            self?.assert(viewController: sut, name: "IMAGE_ITEMS")
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.5)
    }

    func test_imageList_screenShouldDisplayErrorCorrectly() {
        let sut = makeSUT()
        sut.hideLoader()
        sut.displayError(viewModel: ErrorViewModel(message: "Couldn't load images from server"))
        let exp = expectation(description: "Image Item Reload")
        DispatchQueue.main.async { [weak self] in
            self?.assert(viewController: sut, name: "ERROR_SCREEN")
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.5)
    }

    private func createDummyImageListCellController() -> (cellController: ImageListCellController, spy: ImageDataCompressionLoaderSpy) {
        let spy = ImageDataCompressionLoaderSpy()
        let imageListCellController = ImageListCellController(viewModel: ImageCellViewModel(image: anyURL), imageDataCompressionLoader: spy)
        return (cellController: imageListCellController, spy: spy)
    }

    private func makeSUT() -> ImageListViewController {
        let presenter = ImageListPresenterSpy()
        let imageListController: ImageListViewController = ImageListViewController.instantiate()
        imageListController.presenter = presenter
        imageListController.loadViewIfNeeded()
        return imageListController
    }

    private class ImageListPresenterSpy: ImageListPresenterInputProtocol {

        func loadImages() {

        }

        func cellDidLoad(at indexPath: IndexPath) {

        }

        func cellDidClick(at indexPath: IndexPath) {

        }


    }

    private class ImageDataCompressionLoaderSpy: ImageDataCompressionLoader {

        var message: (url: URL, size: CGSize?, completion: (Result<Data, Error>) -> Void)?

        func load(url: URL, compressionSize: CGSize?, completion: @escaping (Result<Data, Error>) -> Void) -> LoaderTask {
            message = (url: url, size: compressionSize, completion: completion)
            return RemoteLoaderTaskSpy()
        }

        func makeImageLoadSuccess(with imageData: Data) {
            message?.completion(.success(imageData))
        }
    }

    private class RemoteLoaderTaskSpy: LoaderTask {
        var canncelledMessageCount: Int = 0
        func cancel() {
            canncelledMessageCount += 1
        }
    }

}
