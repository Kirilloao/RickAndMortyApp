//
//  DetailViewController.swift
//  RickAndMortyApp
//
//  Created by Kirill Taraturin on 27.06.2023.
//

import UIKit

final class DetailViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet var infoTableView: UITableView!
    @IBOutlet var characterImageView: UIImageView! {
        didSet {
            characterImageView.layer.cornerRadius = characterImageView.frame.height / 2
        }
    }
    
    // MARK: - Private Properties
    private var info = [String]()
    
    // MARK: - Public Properties
    var character: Character!
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchImage()
        
        info = [
            character.name,
            character.gender,
            character.status,
            character.species
        ]

        infoTableView.dataSource = self
        infoTableView.delegate = self
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let episodeVC = segue.destination as? EpisodesViewController else { return }
        episodeVC.character = character
    }
}

// MARK: - Networking
extension DetailViewController {
    private func fetchImage() {
        NetworkManager.shared.fetchImage(from: character.image) { [weak self] result in
            switch result {
                
            case .success(let image):
                self?.characterImageView.image = UIImage(data: image)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension DetailViewController: UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        info.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = infoTableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath)
       
        var content = cell.defaultContentConfiguration()
        
        let oneInfo = info[indexPath.row]
        
        if indexPath.row == 0 {
            content.image = UIImage(systemName: "person.text.rectangle")
        } else if indexPath.row == 1 {
            content.image = UIImage(systemName: "person")
        } else if indexPath.row == 2 {
            content.image = UIImage(systemName: "heart")
        } else {
            content.image = UIImage(systemName: "person.fill.questionmark")
        }
        
        content.text = oneInfo
       
        cell.contentConfiguration = content
        
        return cell
    }
}
