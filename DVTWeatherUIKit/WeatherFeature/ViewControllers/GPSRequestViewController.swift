//
//  GPSRequestViewController.swift
//  DVTWeatherUIKit
//
//  Created by Kurt Jacobs
//

import UIKit

class GPSRequestViewController: UIViewController {
    private var gpsService: GPSService
    
    private var backgroundImage = UIImageView()
    private var text = UILabel()
    private var result = UILabel()
    private var access = UIButton()
    private var headerImage = UIImageView()
    
    private var stack = UIStackView()
    
    init(service: GPSService) {
        self.gpsService = service
        super.init(nibName: nil, bundle: nil)
        addObservables()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        layoutUI()
        configureUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc private func didBecomeActive() {
        switch gpsService.locationStatus {
        case .restricted, .denied:
            result.text = "Please update the settings to allow location based services!"
        case .authorizedAlways, .authorizedWhenInUse:
            dismiss(animated: true, completion: nil)
        default:
            result.text = ""
        }
    }
    
    private func addObservables() {
        gpsService.locationAuthDidUpdateObservable.add { [weak self] auth in
            switch auth {
            case .authorizedWhenInUse, .authorizedAlways:
                self?.dismiss(animated: true, completion: nil)
            default:
                self?.setResultLabel()
            }
        }
    }
    
    private func setupUI() {
        stack.addArrangedSubviews([
            headerImage,
            text,
            access,
            result
        ])
        
        view.addSubview(stack)
    }
    
    private func layoutUI() {
        stack.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        headerImage.snp.makeConstraints {
            $0.height.equalTo(150)
            $0.width.equalTo(150)
        }
    }
    
    private func configureUI() {
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 15
        
        access.setTitle("Request", for: .normal)
        access.addTarget(self, action: #selector(refreshLocation), for: .touchUpInside)
        
        text.text = "We would like to access your location for weather services."
        text.numberOfLines = 0
        text.textAlignment = .center
        
        setResultLabel()
        result.numberOfLines = 0
        result.textAlignment = .center
        
        headerImage.image = UIImage(systemName: "location.circle.fill")?.withRenderingMode(.alwaysTemplate)
        headerImage.tintColor = .white
        
        view.backgroundColor = .systemGreen
    }
    
    @objc func refreshLocation() {
        gpsService.refreshLocation()
    }
    
    private func setResultLabel() {
        switch gpsService.locationStatus {
        case .restricted, .denied:
            result.text = "Please update the settings to allow location based services!"
        default:
            result.text = ""
        }
    }

}
