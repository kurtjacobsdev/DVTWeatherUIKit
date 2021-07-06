//
//  CurrentDayCell.swift
//  DVTWeatherUIKit
//
//  Created by Kurt Jacobs
//

import UIKit

class CurrentDayCell: UITableViewCell {
    private var footerHairline = UIView()
    private var minStack = UIStackView()
    private var currentStack = UIStackView()
    private var maxStack = UIStackView()
    private var contentStack = UIStackView()
    
    private var minTextLabel = UILabel()
    private var minValueLabel = UILabel()
    
    private var currentTextLabel = UILabel()
    private var currentValueLabel = UILabel()
    
    private var maxTextLabel = UILabel()
    private var maxValueLabel = UILabel()
    
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
        minStack.addArrangedSubviews([minValueLabel, minTextLabel])
        maxStack.addArrangedSubviews([maxValueLabel, maxTextLabel])
        currentStack.addArrangedSubviews([currentValueLabel, currentTextLabel])
        
        contentStack.addArrangedSubviews([minStack, UIView(), currentStack, UIView(), maxStack])
        
        contentView.addSubview(contentStack)
        contentView.addSubview(footerHairline)
    }
    
    private func layoutUI() {
        contentStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        
        footerHairline.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
    
    private func configureUI() {
        minStack.axis = .vertical
        minStack.distribution = .fill
        minStack.alignment = .leading
        
        currentStack.axis = .vertical
        currentStack.distribution = .fill
        currentStack.alignment = .center
        
        maxStack.axis = .vertical
        maxStack.distribution = .fill
        maxStack.alignment = .trailing
        
        contentStack.axis = .horizontal
        contentStack.distribution = .fillEqually
        contentStack.alignment = .fill
        
        minTextLabel.textColor = .white
        minValueLabel.textColor = .white
        maxTextLabel.textColor = .white
        maxValueLabel.textColor = .white
        currentTextLabel.textColor = .white
        currentValueLabel.textColor = .white
        
        minValueLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        maxValueLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        currentValueLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    
    func configure(viewModel: CurrentDayViewModel) {
        minValueLabel.text = viewModel.minTemperature
        minTextLabel.text = "min"
        
        maxValueLabel.text = viewModel.maxTemperature
        maxTextLabel.text = "max"
        
        currentValueLabel.text = viewModel.currentTemperature
        currentTextLabel.text = "current"
        
        footerHairline.backgroundColor = .white
        contentView.backgroundColor = viewModel.backgroundColor
    }
}


