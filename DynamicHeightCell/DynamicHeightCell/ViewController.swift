//
//  ViewController.swift
//  DynamicHeightCell
//
//  Created by Лев Бондаренко on 18.06.2024.
//

import UIKit

class ViewController: UIViewController {
    
    /// создаем лайаут с базовыми настройками для нашей коллекции
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumLineSpacing = 4
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.itemSize = CGSize(width: view.frame.width, height: 100)
        
        return collectionViewLayout
    }()
    
    // создание своей коллекции
    private lazy var collectionView: TestCollectionView = {
        let collectionView = TestCollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayout
        )
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    /// метод для имитации подгрузки данных
    private func loadData() {
        /// данные подгрузятся через 2 секунды
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            let items = [
                Card(price: 1000, name: "Унитаз"),
                Card(price: 50000, name: "Айфон"),
                Card(price: 30000, name: "Андроид"),
            ]
            
            // после их получения мы обновим ячейку
            DispatchQueue.main.async {
                self.collectionView.set(items: items)
            }
        }
    }
    
    
}

