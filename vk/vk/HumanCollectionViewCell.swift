//
//  HumanCollectionViewCell.swift
//  vk
//
//  Created by Al Stark on 10.05.2023.
//

import UIKit

final class HumanCollectionViewCell: UICollectionViewCell {
    
    public static let reuseIdentifier = "HumanCollectionViewCell"
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
