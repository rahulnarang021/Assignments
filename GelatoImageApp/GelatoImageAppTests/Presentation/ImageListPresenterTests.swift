//
//  ImageItemPresenterTests.swift
//  GelatoImageAppTests
//
//  Created by RN on 04/07/21.
//

import XCTest
@testable import GelatoImageApp

class ImageListPresenterTests: XCTestCase {

    func test_init_shouldNotLoadImage() {
        let sut = makeSUT()
        XCTAssertTrue(sut.loader.messageCount == 0, "Presenter is making \(sut.loader.messageCount) api calls on init but expected 0 api calls instead")
    }

    func test_init_shouldNotPassAnyMessageToView() {
        let sut = makeSUT()
        XCTAssertTrue(sut.view.messageCount == 0, "Presenter is passing \(sut.view.messages) to view but expected no message instead")
    }

    func test_loadImages_shouldMakeOnly1APICall() {
        let sut = makeSUT()
        sut.presenter.loadImages()
        XCTAssertTrue(sut.loader.messageCount == 1, "Presenter is making \(sut.loader.messageCount) api calls on loadImages but expected 1 api calls instead")
    }

    func test_loadImages_shouldPassLoadingMessageToView() {
        let sut = makeSUT()
        sut.presenter.loadImages()
        XCTAssertEqual(sut.view.messages, [.showLoader(viewModel: loadingViewModel)], "Expected Presenter to pass loading message but got \(sut.view.messages) instead")
    }

    func test_loadImage_shouldNotMakeAPICallIfOneInProgress() {
        let sut = makeSUT()
        sut.presenter.loadImages()
        sut.presenter.loadImages()
        XCTAssertTrue(sut.loader.messageCount == 1, "Presenter is making \(sut.loader.messageCount) api calls on loadImages while image loading is already in progress but expected 1 api calls instead")
    }

    func test_loadImage_shouldNotPassLoadingMessageIfOneInProgress() {
        let sut = makeSUT()
        sut.presenter.loadImages()
        sut.presenter.loadImages()

        XCTAssertEqual(sut.view.messages, [.showLoader(viewModel: loadingViewModel)], "Expected Presenter to pass loading message but got \(sut.view.messages) instead")
    }

    func test_loadImage_shouldPassDisplayMessageAfterLoad() {
        let sut = makeSUT()
        sut.presenter.loadImages()
        sut.loader.completeLoadingWithSuccess(for: [])
        XCTAssertEqual(sut.view.messages, [.showLoader(viewModel: loadingViewModel), .hideLoader, .display(images: [])], "Expected Presenter to pass display message after success but got \(sut.view.messages) instead")
    }

    func test_loadImage_shouldPassHideLoaderMessageAfterLoad() {
        let sut = makeSUT()
        sut.presenter.loadImages()
        sut.loader.completeLoadingWithSuccess(for: [])
        XCTAssertEqual(sut.view.messages, [.showLoader(viewModel: loadingViewModel), .hideLoader, .display(images: [])], "Expected Presenter to pass hideLoader message after success but got \(sut.view.messages) instead")
    }

    func test_loadImage_shouldPassCorrectResultInDisplayAfterLoad() {
        let sut = makeSUT()
        sut.presenter.loadImages()
        let imageUrl = URL(string: "https://www.dummyurl.com")!
        let imageItem = makeImageItem(url: imageUrl)
        let imageItemCellViewModel = ImageCellViewModel(image: imageUrl)
        sut.loader.completeLoadingWithSuccess(for: [imageItem])
        XCTAssertEqual(sut.view.messages, [.showLoader(viewModel: loadingViewModel), .hideLoader, .display(images: [imageItemCellViewModel]),], "Expected Presenter to pass display message after success but got \(sut.view.messages) instead")
    }

    func test_loadImage_shouldNotPassShowOrHideLoaderMessageOnSecondTimeLoadAfterSuccess() {
        let sut = makeSUT()
        sut.presenter.loadImages()
        let imageUrl = URL(string: "https://www.dummyurl.com")!
        let imageItem = makeImageItem(url: imageUrl)
        let imageItemCellViewModel = ImageCellViewModel(image: imageUrl)

        sut.loader.completeLoadingWithSuccess(for: [imageItem])

        sut.presenter.loadImages()
        let secondImageItem = makeImageItem()
        let secondImageItemCellViewModel = ImageCellViewModel(image: secondImageItem.download_url)
        let finalViewModels = [
            secondImageItemCellViewModel]

        sut.loader.completeLoadingWithSuccess(for: [secondImageItem])
        XCTAssertEqual(sut.view.messages, [.showLoader(viewModel: loadingViewModel), .hideLoader, .display(images: [imageItemCellViewModel]), .display(images: finalViewModels)], "Expected Presenter to pass display message after success but got \(sut.view.messages) instead")

    }

    func test_cellDidLoad_shouldDownloadImageAgainWhenLastRowIsVisible() {
        let sut = makeSUT()
        sut.presenter.loadImages()
        let imageUrl = URL(string: "https://www.dummyurl.com")!
        let imageItem = makeImageItem(url: imageUrl)
        sut.loader.completeLoadingWithSuccess(for: [imageItem])

        sut.presenter.cellDidLoad(at: IndexPath(item: 0, section: 1))
        XCTAssertEqual(sut.loader.messageCount, 2, "Extected to load image items again")

    }

    func test_cellDidLoad_shouldNotDownloadImageAgainWhenLastRowIsNotVisible() {
        let sut = makeSUT()
        sut.presenter.loadImages()
        let imageUrl = URL(string: "https://www.dummyurl.com")!
        let imageItem = makeImageItem(url: imageUrl)
        sut.loader.completeLoadingWithSuccess(for: [imageItem, imageItem])

        sut.presenter.cellDidLoad(at: IndexPath(item: 0, section: 1))
        XCTAssertEqual(sut.loader.messageCount, 1, "Extected to load image items again")

    }

    func test_cellDidClick_shouldPassShareSheetMessageWithCorrectItem() throws {
        let sut = makeSUT()
        sut.presenter.loadImages()
        let imageUrl = URL(string: "https://www.dummyurl.com")!
        let imageItem = makeImageItem(url: imageUrl)
        sut.loader.completeLoadingWithSuccess(for: [imageItem, imageItem])

        let clickedIndexPath = IndexPath(item: 0, section: 1)
        sut.presenter.cellDidClick(at: clickedIndexPath)

        let lastMessage = try XCTUnwrap(sut.view.messages.last, "Expected messages passed opn view but got \(sut.view.messages) instead")

        XCTAssertEqual(lastMessage, .shareSheet(indexPath: clickedIndexPath, imageURL: imageUrl), "Expected Presenter to pass share message after cellDidClick but got \(lastMessage) instead")
    }
    // MARK: - Helper Methods
    private func makeSUT() -> (view: ImageListPresenterOutputSpy, loader: ImageItemLoaderSpy, presenter: ImageListPresenter) {
        let listView = ImageListPresenterOutputSpy()
        let loader = ImageItemLoaderSpy()

        let presenter = ImageListPresenter(imageListView: listView, loader: loader)
        testMemoryLeak(presenter)
        testMemoryLeak(loader)
        testMemoryLeak(listView)
        return (view: listView, loader: loader, presenter: presenter)
    }

    private class ImageListPresenterOutputSpy: ImageListPresenterOutput {
        enum LoaderMessage: Equatable {
            case display(images: [ImageCellViewModel])
            case displayError(viewModel: ErrorViewModel)
            case showLoader(viewModel: LoadingViewModel)
            case hideLoader
            case shareSheet(indexPath: IndexPath, imageURL: URL)
        }
        var messages: [LoaderMessage] = []
        var messageCount: Int {
            return messages.count
        }

        func display(images: [ImageCellViewModel]) {
            messages.append(.display(images: images))
        }

        func displayError(viewModel: ErrorViewModel) {
            messages.append(.displayError(viewModel: viewModel))
        }

        func showLoader(viewModel: LoadingViewModel) {
            messages.append(.showLoader(viewModel: viewModel))
        }

        func hideLoader() {
            messages.append(.hideLoader)
        }

        func showShareSheet(from indexPath: IndexPath, imageURL: URL) {
            messages.append(.shareSheet(indexPath: indexPath, imageURL: imageURL))
        }

    }

    private var loadingViewModel: LoadingViewModel {
        return LoadingViewModel(message: "Loading Data")
    }
}
