//
//  ViewController.swift
//  DVTWeatherUIKit
//
//  Created by Kurt Jacobs
//

import UIKit
import SnapKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    private var tableView = UITableView()
    private var tableViewHeader = TableViewWeatherHeaderView()
    private var container: UIView = UIView()
    private var loader = UIActivityIndicatorView()
    weak var coordinatorDelegate: WeatherViewControllerCoordinatorDelegate?
    
    private var weatherController: WeatherController
    
    init(weatherController: WeatherController) {
        self.weatherController = weatherController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewHeader()
        
        setupUI()
        layoutUI()
        configureUI()
        refreshUI()
        addObservables()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presentGPSOverlayIfNeeded()
    }
    
    private func presentGPSOverlayIfNeeded() {
        if weatherController.shouldPresentGPSOverlay() {
            coordinatorDelegate?.presentGPSOverlay()
        } else {
            loader.startAnimating()
            weatherController.refresh()
        }
    }
    
    private func addObservables() {
        weatherController.weatherDidUpdate.add { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    self?.refreshUI()
                }
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: "An Error Occured, Please Try Again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    private func refreshUI () {
        tableView.backgroundColor = weatherController.current.backgroundColor
        tableViewHeader.configure(degrees: weatherController.current.currentTemperature,
                                  condition: weatherController.current.weatherType.title,
                                  background: weatherController.current.weatherType.headerImage)
        tableView.reloadData()
        loader.stopAnimating()
    }
    
    private func setupTableViewHeader() {
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(tableViewHeader)
        
        tableView.tableHeaderView = container
        
        tableViewHeader.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        container.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(300)
        }
        
        tableView.tableHeaderView?.layoutIfNeeded()
        tableView.tableHeaderView = tableView.tableHeaderView
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(loader)
    }
    
    private func layoutUI() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        loader.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func configureUI() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CurrentDayCell.self, forCellReuseIdentifier: CurrentDayCell.reuseName)
        tableView.register(ForecastCell.self, forCellReuseIdentifier: ForecastCell.reuseName)
        
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return weatherController.forecast.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let viewModel = weatherController.current
            let cell = CurrentDayCell()
            cell.configure(viewModel: viewModel)
            return cell
        } else {
            let viewModel = weatherController.forecast[indexPath.row]
            let cell = ForecastCell()
            cell.configure(viewModel: viewModel)
            return cell
        }
    }
}

// MARK: - UIScrollViewDelegate
extension WeatherViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = min(0, tableView.contentOffset.y)
        container.snp.updateConstraints {
            $0.top.equalToSuperview().offset(contentOffsetY)
            $0.width.equalToSuperview().offset(-contentOffsetY)
        }
        
        tableViewHeader.snp.updateConstraints {
            $0.bottom.equalToSuperview().offset(-contentOffsetY)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // we ask for a refresh of the data if the user pulls down to refresh. We could use a uirefresh control but I've opted to manually do it because of the bouncy image view. In theory one could add a view that alpha changes as the content offset increases.
        let contentOffsetY = min(0, tableView.contentOffset.y)
        if abs(contentOffsetY) > 120 {
            loader.startAnimating()
            weatherController.refresh()
        }
    }
}
