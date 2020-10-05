//
//  ProductViewCell.swift
//  natura-ios
//
//  Created by livetouch on 04/10/20.
//  Copyright © 2020 livetouch. All rights reserved.
//

import UIKit

class ProductViewCell: UICollectionViewCell {

    @IBOutlet weak var productsCount: UILabel!
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var productName: UILabel!

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        cardView.layer.cornerRadius = CGFloat.defaultRadius * 2
    }

    func configure(product: Product) {
        productsCount.isHidden = true
        categoryTitle.isHidden = true
        descriptionLabel.isHidden = false
        productName.isHidden = false

        productName.text = product.name
        descriptionLabel.text = product.description

        handleSelection()
    }

    func configure(category: ProductCategory, count: Int) {
        productsCount.isHidden = false
        categoryTitle.isHidden = false
        descriptionLabel.isHidden = false
        productName.isHidden = true

        productsCount.text = "\(count) produtos".uppercased()
        categoryTitle.text = category.title
        descriptionLabel.text = category.description

        handleSelection()
    }

    func handleSelection() {
        if isSelected {
            cardView.layer.borderColor = UIColor(named: "yellow")!.cgColor
            cardView.layer.borderWidth = 1
            cardView.generateShadow()
        } else {
            cardView.layer.borderWidth = 0
            cardView.generateShadow(color: UIColor.systemGray2)
        }

    }
}
