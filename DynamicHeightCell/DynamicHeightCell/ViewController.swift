//
//  ViewController.swift
//  DynamicHeightCell
//
//  Created by Лев Бондаренко on 18.06.2024.
//

import UIKit
import SnapKit

struct Card {
    let price: Int
    let name: String
}

class ViewController: UIViewController {
    private var items: [Card] = []

    /// создаем лайаут с базовыми настройками для нашей коллекции
    private lazy var collectionViewLayout: UICollectionViewLayout = {
        UICollectionViewCompositionalLayout { _, layoutEnvironment in
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let section = NSCollectionLayoutSection.list(using: configuration,
                                                     layoutEnvironment: layoutEnvironment)
        section.interGroupSpacing = 4
        return section
      }
    }()

    // создание своей коллекции
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: collectionViewLayout
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCustomView()
        loadData()
    }

    /// метод для имитации подгрузки данных
    private func loadData() {
        /// данные подгрузятся через 2 секунды
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) { [weak self] in
          self?.items = [
                Card(price: 1000, name: "afgasasdasdlasdla;sd;ash;dha;sd;ah;sdh;ahs;dh;asndnjsbcosbdlbasldblahsdlaslblnsdadasdasdasdasdadasdasdadadsdakdna;sdnlabspbas;fbpasfpnfn"),
                Card(price: 50000, name: "Айфон"),
                Card(price: 30000, name: "sdla;sd;ash;dha;sd;ah;sdh;ahs;dh;asndnjsbcosbdlbasldblahsdlaslblnsdadasdasdasdasdadasdasdadadsdakdna;sdnlabspbas;fbpasfpnfnsdla;sd;ash;dha;sd;ah;sdh;ahs;dh;asndnjsbcosbdlbasldblahsdlaslblnsdadasdasdasdasdadasdasdadadsdakdna;sdnlabspbas;fbpasfpnfn"),
            ]
            // после их получения мы обновим ячейку
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }

        DispatchQueue.global().asyncAfter(deadline: .now() + 5) { [weak self] in
          self?.items = [
                Card(price: 1000, name: "afgasasdas"),
                Card(price: 50000, name: "Айфон"),
                Card(price: 30000, name: "sdla;sd;ash;dha;sd;ah;sdhn"),
            ]
            // после их получения мы обновим ячейку
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
}

private extension ViewController {
    func loadCustomView() {
      view.addSubview(collectionView)
      collectionView.register(CardCell.self, forCellWithReuseIdentifier: "CardCell")
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {

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

    func set(
        title: String,
        price: String
    ) {
        titleLabel.text = title
        priceLabel.text = price
    }

    // MARK: Setups

    private func setupView() {
        contentView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        contentView.layer.cornerRadius = 5
        
        [
            titleLabel,
            priceLabel
        ].forEach(contentView.addSubview)

        titleLabel.snp.makeConstraints {
          $0.edges.equalToSuperview()
        }
    }
}
