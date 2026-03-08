import UIKit
import Combine

class ListDoorsViewController: UIViewController {
    private let viewModel = ListDoorsViewModel()
    private var cancellables = Set<AnyCancellable>()
    private var doors: [DoorModel] = []
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = NSLocalizedString("search_door_placeholder", comment: "")
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "DoorCell")
        return table
    }()
    
    private let loadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        observeState()
        Task {
            await viewModel.getDoors()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func observeState() {
        viewModel.$state
            .sink { [weak self] state in
                self?.handleState(state)
            }
            .store(in: &cancellables)
    }
    
    private func handleState(_ state: ListDoorsState) {
        switch state {
        case .idle:
            loadingView.stopAnimating()
        case .loading:
            loadingView.startAnimating()
        case .success(let doors):
            loadingView.stopAnimating()
            self.doors = doors
            tableView.reloadData()
        case .failure(let error):
            loadingView.stopAnimating()
            showError(error)
        }
    }
    
    private func showError(_ error: DoorError) {
        let alert = UIAlertController(title: "Error",
                                      message: error.localizedMessage,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension ListDoorsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoorCell", for: indexPath)
        cell.textLabel?.text = doors[indexPath.row].name
        return cell
    }
}

extension ListDoorsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Task {
            if searchText.isEmpty {
                await viewModel.getDoors()
            } else {
                await viewModel.findDoorByName(searchText)
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
