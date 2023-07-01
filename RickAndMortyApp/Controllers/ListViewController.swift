//
//  ViewController.swift
//  RickAndMortyApp
//
//  Created by Kirill Taraturin on 27.06.2023.
//

import UIKit

final class ListViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet var mainTableView: UITableView!
    @IBOutlet var previousBarButton: UIBarButtonItem!
    @IBOutlet var nextBarButton: UIBarButtonItem!
    
    // MARK: - Private Properties
    private var rickAndMorty: RickAndMorty?
    private var currentPage = 1 {
        didSet {
            if currentPage == 1 {
                previousBarButton.isEnabled = false
            }
        }
    }
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTableView.dataSource = self
        mainTableView.delegate = self
        
        fetchCharacters(from: Links.rickAndMortyURL.rawValue)
        
        previousBarButton.isEnabled = false
        
        print(mainTableView.rowHeight)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? DetailViewController else { return }
        guard let indexPath = mainTableView.indexPathForSelectedRow else { return }
        
        detailVC.character = rickAndMorty?.results[indexPath.row]
    }
    
    // MARK: - Actions
    @IBAction func updateData(_ sender: UIBarButtonItem) {
        
        if sender.tag == 1 {
            fetchCharacters(from: rickAndMorty?.info.next ?? "")
            currentPage += 1
            
            if currentPage == 43 {
                nextBarButton.isEnabled = false
            }
            previousBarButton.isEnabled = true
        } else {
            fetchCharacters(from: rickAndMorty?.info.prev ?? "")
            if currentPage > 1 {
                currentPage -= 1
            }
        }
    }
}

// MARK: - UITableViewDataSoruce
extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rickAndMorty?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "mainCell",
                for: indexPath) as? CharacterTableViewCell else {
            return UITableViewCell()
            
        }
        
        let character = rickAndMorty?.results[indexPath.row]
        
        cell.configure(with: character)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainTableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Networking
extension ListViewController {
    private func fetchCharacters(from url: String) {
        NetworkManager.shared.fetch(RickAndMorty.self, from: url) { [weak self] result in
            switch result {
                
            case .success(let rickAndMorty):
                self?.rickAndMorty = rickAndMorty
                self?.mainTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}
