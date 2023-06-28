//
//  EpisodesViewController.swift
//  RickAndMortyApp
//
//  Created by Kirill Taraturin on 27.06.2023.
//

import UIKit

final class EpisodesViewController: UITableViewController {
    
    // MARK: - Public Properties
    var character: Character!
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episodes"
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let episodeInfoVC = segue.destination as? EpisodeInfoViewController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        episodeInfoVC.episode = character.episode[indexPath.row]
    }
    
    // MARK: - UITableViewDataSoruce
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        character.episode.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "episodeCell", for: indexPath)
        
        let episode = character.episode[indexPath.row]
        
        var abbreviatedText: String?
        
        if let lastSlashRange = episode.range(of: "/", options: .backwards, range: nil, locale: nil) {
            let startIndex = lastSlashRange.upperBound
            abbreviatedText = String(episode[startIndex...])
        }
        
        var content = cell.defaultContentConfiguration()
        
        content.text = "Episode: \(abbreviatedText ?? "")"
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    // MARK: - TableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
