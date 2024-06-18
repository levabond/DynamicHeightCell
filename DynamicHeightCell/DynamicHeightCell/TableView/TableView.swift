//
//  TableView.swift
//  DynamicHeightCell
//
//  Created by Лев Бондаренко on 18.06.2024.
//

import UIKit

struct Card {
    let price: Int
    let name: String
}

final class TestCollectionView: UICollectionView {
    
    private var items: [Card] = []
    private let cardDummyCell = CardCell()
    
    override init(
        frame: CGRect,
        collectionViewLayout layout: UICollectionViewLayout
    ) {
        super.init(frame: frame, collectionViewLayout: layout)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(items: [Card]) {
        self.items = items
        reloadData()
    }
        // Мы добавили новую функцию, которая помогает в настроике коллекции
    private func configureView() {
        dataSource = self
        
        register(CardCell.self, forCellWithReuseIdentifier: "CardCell")
    }
}

extension TestCollectionView: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        items.count
    }
    
    func collectionView(
            _ collectionView: UICollectionView,
            cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CardCell", for: indexPath
        ) as? CardCell else { fatalError("isn't registred") }
        let item = items[indexPath.item]
        cell.set(title: item.name, price: "\(item.price)")
        
        return cell
    }
}

extension TestCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = items[indexPath.item]
        cardDummyCell.set(title: item.name, price: "\(item.price)")
        let cellHeight = cardDummyCell.sizeThatFits(CGSize(width: bounds.width, height: .greatestFiniteMagnitude)).height
        
        return CGSize(width: frame.width, height: cellHeight)
    }
}

final class CardCell: UICollectionViewCell {
    enum Constants {
        static let horizontalOffsets = 16.0
        static let verticalOffsets = 8.0
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayoutAndGetHeight()
    }
    
    func set(
        title: String,
        price: String
    ) {
        titleLabel.text = title
        priceLabel.text = price
        
        setNeedsLayout()
    }
    
    @discardableResult
    func setupLayoutAndGetHeight() -> CGFloat {
        let textWidth = contentView.bounds.width - Constants.horizontalOffsets * 2
        let titleHeight = titleLabel.sizeThatFits(
            CGSize(
                width: textWidth,
                height: .greatestFiniteMagnitude
            )
        ).height
        titleLabel.frame = CGRect(
            x: Constants.horizontalOffsets,
            y: Constants.verticalOffsets,
            width: textWidth,
            height: titleHeight
        )
        
        let priceWidth = contentView.bounds.width - Constants.horizontalOffsets * 2
        let priceHeight = priceLabel.sizeThatFits(
            CGSize(
                width: textWidth,
                height: .greatestFiniteMagnitude
            )
        ).height
        priceLabel.frame = CGRect(
            x: Constants.horizontalOffsets,
            y: titleLabel.frame.maxY + 8.0,
            width: priceWidth,
            height: priceHeight
        )
        
        return priceLabel.frame.maxY + Constants.verticalOffsets
    }
    
    // MARK: Setups
    
    private func setupView() {
        [
            titleLabel,
            priceLabel
        ].forEach(contentView.addSubview)
        
        contentView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        contentView.layer.cornerRadius = 5
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.frame.size.width = size.width
        let height = setupLayoutAndGetHeight()
        
        return CGSize(width: size.width, height: height)
    }
}
