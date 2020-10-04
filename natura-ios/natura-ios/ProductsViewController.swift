//
//  ProductsViewController.swift
//  natura-ios
//
//  Created by livetouch on 04/10/20.
//  Copyright © 2020 livetouch. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let reuseHeader = "header"
private let categoryHeader = "headerCategory"

class ProductHeader: UICollectionReusableView {

    let textLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        textLabel.text = "Categoria"
        addSubview(textLabel)
    }

    func configure(text: String, hidden: Bool) {
        textLabel.isHidden = hidden
        textLabel.text = text.uppercased()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel.frame = bounds
    }
}

class ProductsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var categoria : ProductCategory = .cabelo
    var data: [ProductCategory : [Product]] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.backgroundColor = .clear
        self.collectionView.register(UINib(nibName: "ProductViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)

        self.collectionView!.register(ProductHeader.self, forSupplementaryViewOfKind: categoryHeader, withReuseIdentifier: reuseHeader)

        data = DataModel.shared.data
        collectionView.reloadData()
    }

    init() {
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in

            let section : NSCollectionLayoutSection

            if sectionNumber == 0 {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets.trailing = 20
                item.contentInsets.bottom = 20

                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.42), heightDimension: .fractionalHeight(0.5)), subitems: [item])
                group.contentInsets.top = 20

                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous

            } else {

                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets.trailing = 20

                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.37), heightDimension: .fractionalHeight(0.35)), subitems: [item])

                group.contentInsets.top = 20
                group.interItemSpacing = .none

                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = .leastNonzeroMagnitude
            }

            section.boundarySupplementaryItems = [
                .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30)), elementKind: categoryHeader, alignment: .topLeading)
            ]

            section.contentInsets.leading = UIScreen.main.bounds.width * 0.06
            section.contentInsets.trailing = UIScreen.main.bounds.width * 0.06 - 20

            return section
        }

        super.init(collectionViewLayout: layout)
    }

    required convenience init?(coder: NSCoder) {
        self.init()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let categorias = data.keys.count
        let produtos = data[categoria]?.count ?? 0
        return section == 0 ? categorias : produtos
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        if let cell = cell as? ProductViewCell {
            if indexPath.section != 0 {
                let produto = data[self.categoria]![indexPath.row]
                cell.configure(product: produto)
            } else {
                 let produtos = data[categoria]?.count ?? 0
                cell.configure(category: self.categoria, count: produtos)
            }

        }
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseHeader, for: indexPath)

        let texto = indexPath.section == 0 ? "Nossos Produtos" : categoria.title

        if let header = header as? ProductHeader {
            header.configure(text: texto, hidden: false)
        }
        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

}
