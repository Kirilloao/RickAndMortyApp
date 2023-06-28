//
//  CharacterTableViewCell.swift
//  RickAndMortyApp
//
//  Created by Kirill Taraturin on 27.06.2023.
//

import UIKit

final class CharacterTableViewCell: UITableViewCell {
    
    // MARK: - IB Outlets
    @IBOutlet var characterImageView: UIImageView! {
        didSet {
            characterImageView.layer.cornerRadius = characterImageView.frame.width / 2
        }
    }
    
    @IBOutlet var characterNameLabel: UILabel!
    
    // MARK: - Public Methods
    func configure(with character: Character?) {
        characterNameLabel.text = character?.name
        
        NetworkManager.shared.fetchImage(from: character?.image ?? "") { [weak self] result in
            switch result {
                
            case .success(let image):
                self?.characterImageView.image = UIImage(data: image)
            case .failure(let error):
                print(error)
            }
        }
    }
}
