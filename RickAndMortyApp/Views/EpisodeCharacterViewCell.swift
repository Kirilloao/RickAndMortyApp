//
//  EpisodeCharacterViewCell.swift
//  RickAndMortyApp
//
//  Created by Kirill Taraturin on 28.06.2023.
//

import UIKit

final class EpisodeCharacterViewCell: UITableViewCell {
    
    // MARK: - IB Outlets
    @IBOutlet var characterImageView: UIImageView! {
        didSet {
            characterImageView.layer.cornerRadius = characterImageView.frame.width / 2
        }
    }
    @IBOutlet var characterNameLabel: UILabel!
    
    // MARK: - Public Methods
    func configure(_ characterURL: String) {
        
        NetworkManager.shared.fetch(Character.self, from: characterURL) { [weak self] result in
            switch result {
                
            case .success(let character):
                self?.characterNameLabel.text = character.name
                
                NetworkManager.shared.fetchImage(from: character.image) { [weak self] result in
                    switch result {
                        
                    case .success(let image):
                        self?.characterImageView.image = UIImage(data: image)
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
