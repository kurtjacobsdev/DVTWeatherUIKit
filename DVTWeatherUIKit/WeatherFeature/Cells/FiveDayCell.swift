//
//  ForecastCell.swift
//  DVTWeatherUIKit
//
//  Created by Kurt Jacobs
//

import UIKit

class ForecastCell: UITableViewCell {
    private var dayLabel = UILabel()
    private var conditionImageView = UIImageView()
    private var temperatureLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        layoutUI()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(dayLabel)
        contentView.addSubview(conditionImageView)
        contentView.addSubview(temperatureLabel)
    }
    
    private func layoutUI() {
        conditionImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(44)
            $0.height.equalTo(44)
        }
        
        dayLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        
        temperatureLabel.snp.makeConstraints {
            $0.right.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func configureUI() {
        dayLabel.textColor = .white
        temperatureLabel.textColor = .white
        
        dayLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        temperatureLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    
    func configure(viewModel: ForecastViewModel) {
        dayLabel.text = viewModel.day
        conditionImageView.image = viewModel.image
        temperatureLabel.text = viewModel.temperature
        
        contentView.backgroundColor = viewModel.backgroundColor
    }
}

