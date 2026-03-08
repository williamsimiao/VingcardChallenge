import UIKit
import Combine

class ListDoorsViewController: UIViewController {
    private let viewModel = ListDoorsViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.placeholder = NSLocalizedString("search_door_placeholder", comment: "")
        controller.obscuresBackgroundDuringPresentation = false
        return controller
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
        
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        view.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
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
        case .success:
            loadingView.stopAnimating()
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
        return viewModel.doors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoorCell", for: indexPath)
        cell.textLabel?.text = viewModel.doors[indexPath.row].name
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height - 100 {
            Task {
                await viewModel.loadMoreDoors()
            }
        }
    }
}

extension ListDoorsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        Task {
            if searchText.isEmpty {
                await viewModel.getDoors()
            } else {
                await viewModel.findDoorByName(searchText)
            }
        }
    }
}
