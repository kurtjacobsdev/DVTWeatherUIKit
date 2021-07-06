//
//  TableViewWeatherHeaderView.swift
//  DVTWeatherUIKit
//
//  Created by Kurt Jacobs
//

import UIKit

class TableViewWeatherHeaderView: UIView {
    private var backgroundImage = UIImageView()
    
    private var degreesLabel = UILabel()
    private var conditionsLabel = UILabel()
    
    private var contentStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        layoutUI()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentStack.addArrangedSubviews([degreesLabel, conditionsLabel])
        
        addSubview(backgroundImage)
        addSubview(contentStack)
    }
    
    private func layoutUI() {
        backgroundImage.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        contentStack.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
    
    private func configureUI() {
        contentStack.alignment = .center
        contentStack.distribution = .fill
        contentStack.axis = .vertical
        
        degreesLabel.font = UIFont.systemFont(ofSize: 40, weight: .heavy)
        conditionsLabel.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        
        degreesLabel.textColor = .white
        conditionsLabel.textColor = .white
    }
    
    func configure(degrees: String, condition: String, background: UIImage?) {
        degreesLabel.text = degrees
        conditionsLabel.text = condition
        backgroundImage.image = background
    }
}
