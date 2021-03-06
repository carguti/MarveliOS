//
//  SplashScreenPresenter.swift
//  MarveliOS
//
//  Created by Carlos Gutierrez Casado on 10/05/2020.
//  Copyright © 2020 Carlos Gutierrez Casado. All rights reserved.
//

import Foundation

protocol SplashScreenPresenterDelegate: class {
    func goToCharactersList(characters: [Character]?)
}

class SplashScreenPresenter {
    let splashScreenProtocol: SplashScreenProtocol
    weak var delegate: SplashScreenPresenterDelegate?
    let searchService = SearchService()
    public var arrCharacters: [Character] = []
    private let limit = 100
    private var offset = 0
    var progress: Double = 0
    
    init(splashScreenProtocol: SplashScreenProtocol, delegate: SplashScreenPresenterDelegate?) {
        self.splashScreenProtocol = splashScreenProtocol
        self.delegate = delegate
    }
    
    func splashScreenShown() {
        searchService.getCharacters(name: nil, limit: limit, offset: offset) { characters in
            guard let charactersList = characters.data?.results else { return }
            self.arrCharacters.append(contentsOf: charactersList)
            self.offset = self.offset + self.limit
            self.progress = self.progress + 0.072
            self.splashScreenProtocol.progressUpdated(progress: self.progress)
            guard let total = characters.data?.total else { return }
            if self.offset <= total {
                self.splashScreenShown()
            } else {
                CharactersManager.shared.arrCharacters = self.arrCharacters
                self.delegate?.goToCharactersList(characters: self.arrCharacters)
            }
        }
    }
}
