//
//  ListViewModel.swift
//  MWMApp
//
//  Created by RAHUL on 20/06/20.
//  Copyright © 2020 MWM. All rights reserved.
//

import Foundation

class ChordsViewModel {
    weak var view: ChordView?
    var client: ChordClient

    var selectedIndex: Int {
        didSet {
            loadChordsOfSelectedIndex()
        }
    }

    var chordResult: ChordResult? {
        didSet {
            keyViewModel = chordResult?.allkeys.map({ $0.name })
        }
    }

    var keyViewModel: [String]? { // could have been separate viewModel
        didSet {
            view?.reloadKeys(withKeys: keyViewModel ?? [])
        }
    }

    var selectedChords: [String]? { // could have been separate viewModel
        didSet {
            view?.reloadChords(withChords: selectedChords ?? [])
        }
    }

    init(defaultSelectedIndex: Int, client: ChordClient) {
        self.client = client
        self.selectedIndex = defaultSelectedIndex
    }

    private func loadChordsOfSelectedIndex() {
        guard let result = chordResult else {
            return
        }
        if let chordList = chordResult?.allchords {
            let chordFilterList = result.allkeys[selectedIndex].keychordids
            let keySet: Set<Int> = Set(chordFilterList) // converted this to set for O(1) searching
            selectedChords = chordList.filter( { keySet.contains($0.chordid)} )
                                      .map({ $0.suffix })
        }
    }
}

extension ChordsViewModel: ChordVM {
    func viewDidLoad() {
        view?.showLoader()
        loadChords()
    }

    private func loadChords() {
        client.loadResults(completion: {[weak self] (result: ChordResult?, error: String?) in
            guard let weakSelf = self else { return }
            if let chordResult = result {
                weakSelf.handleResult(result: chordResult)
            } else if let errorMessage = error {
                weakSelf.handleError(error: errorMessage)
            }
        })
    }

    private func handleResult(result: ChordResult) {
        self.chordResult = result
        loadChordsOfSelectedIndex()
        view?.hideLoader()
    }

    private func handleError(error: String) {
        view?.showErrorMessage(withTitle: "Error", message: error)
        view?.hideLoader()
    }

    func getTotalKeys() -> Int {
        return (chordResult?.allkeys.count ?? 0)
    }

    func getTotalChords() -> Int {
        return (selectedChords?.count ?? 0)
    }


    func didSelectItem(at index: Int) {
        selectedIndex = index
    }
}
