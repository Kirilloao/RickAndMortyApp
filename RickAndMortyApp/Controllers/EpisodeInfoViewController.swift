//
//  EpisodeInfoViewController.swift
//  RickAndMortyApp
//
//  Created by Kirill Taraturin on 28.06.2023.
//

import UIKit

final class EpisodeInfoViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet var charactersTableView: UITableView!
    @IBOutlet var episodeInfoTextView: UITextView!
    
    // MARK: - Private Properties
    private var characters: [String]?
    
    // MARK: - Public Properties
    var episode: String!
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        charactersTableView.dataSource = self
        charactersTableView.delegate = self
        
        fetchEpisode(from: episode)
    }
}

// MARK: - UITableViewDataSource
extension EpisodeInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        characters?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = charactersTableView.dequeueReusableCell(
                withIdentifier: "episodeInfoCell",
                for: indexPath) as? EpisodeCharacterViewCell else {
            return UITableViewCell()
            
        }
        
        let characterURL = characters?[indexPath.row] ?? ""
        
        cell.configure(characterURL)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Characters in the episode"
    }
}

// MARK: - UITableViewDelegate
extension EpisodeInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        charactersTableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Networking
extension EpisodeInfoViewController {
    private func fetchEpisode(from url: String) {
        NetworkManager.shared.fetch(Episode.self, from: url) { [weak self] result in
            switch result {
                
            case .success(let episode):
                self?.episodeInfoTextView.text =
                                      """
                                      Episod name: \(episode.name)
                                      Release date: \(episode.airDate)
                                      Series number: \(episode.episode)
                                      """
                self?.characters = episode.characters
                self?.charactersTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}
