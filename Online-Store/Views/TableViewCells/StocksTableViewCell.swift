//
//  StocksTableViewCell.swift
//  Online-Store
//
//  Created by Aibatyr on 03.07.2024.
//

import UIKit
import SnapKit

final class StocksTableViewCell: UITableViewCell {
    
    let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "star")
        button.setImage(image, for: .normal)
        button.tintColor = .yellow
        return button
    }()
    
    var favoriteTapped: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        favoriteButton.addTarget(self, action: #selector(handleFavoriteTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(symbolLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(favoriteButton)
        
        symbolLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(8)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(symbolLabel.snp.bottom).offset(4)
            make.bottom.equalToSuperview().offset(-4)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
    }
    
    @objc private func handleFavoriteTapped() {
        favoriteTapped?()
    }
    
    func configure(symbol: String, subtitle: String, isFavorite: Bool) {
        symbolLabel.text = symbol
        subTitleLabel.text = subtitle
        let imageName = isFavorite ? "star.fill" : "star"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        self.layer.cornerRadius = 15
        
    }

}
