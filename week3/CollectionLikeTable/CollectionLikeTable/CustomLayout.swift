//
//  CustomLayout.swift
//  CollectionLikeTable
//
//  Created by 12dot on 27.08.2020.
//  Copyright © 2020 12dot. All rights reserved.
//

import UIKit

class CustomLayout: UICollectionViewFlowLayout {
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let layoutAttributes = super.layoutAttributesForElements(in: rect) else { return nil }

        let sectionsToAdd = NSMutableIndexSet()
        var newLayoutAttributes = [UICollectionViewLayoutAttributes]()

        for layoutAttributesSet in layoutAttributes {
            if layoutAttributesSet.representedElementCategory == .cell {
                newLayoutAttributes.append(layoutAttributesSet)

                sectionsToAdd.add(layoutAttributesSet.indexPath.section)

            } else if layoutAttributesSet.representedElementCategory == .supplementaryView {
                sectionsToAdd.add(layoutAttributesSet.indexPath.section)
            }
        }

        for section in sectionsToAdd {
            let indexPath = IndexPath(item: 0, section: section)

            if let sectionAttributes = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath) {
                newLayoutAttributes.append(sectionAttributes)
            }
        }

        return newLayoutAttributes
    }

   
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let layoutAttributes = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath) else { return nil }
        guard let boundaries = boundaries(forSection: indexPath.section) else { return layoutAttributes }
        guard let collectionView = collectionView else { return layoutAttributes }

        let contentOffsetY = collectionView.contentOffset.y
        var frameForSupplementaryView = layoutAttributes.frame

        let minimum = boundaries.minimum - frameForSupplementaryView.height
        let maximum = boundaries.maximum - frameForSupplementaryView.height

        if contentOffsetY < minimum {
            frameForSupplementaryView.origin.y = minimum
        } else if contentOffsetY > maximum {
            frameForSupplementaryView.origin.y = maximum
        } else {
            frameForSupplementaryView.origin.y = contentOffsetY
        }

        layoutAttributes.frame = frameForSupplementaryView

        return layoutAttributes
    }

    func boundaries(forSection section: Int) -> (minimum: CGFloat, maximum: CGFloat)? {

        var result = (minimum: CGFloat(0.0), maximum: CGFloat(0.0))

        guard let collectionView = collectionView else { return result }

        let numberOfItems = collectionView.numberOfItems(inSection: section)

        guard numberOfItems > 0 else { return result }

        if let firstItem = layoutAttributesForItem(at: IndexPath(item: 0, section: section)),
           let lastItem = layoutAttributesForItem(at: IndexPath(item: (numberOfItems - 1), section: section)) {
            result.minimum = firstItem.frame.minY
            result.maximum = lastItem.frame.maxY

            result.minimum -= headerReferenceSize.height
            result.maximum -= headerReferenceSize.height

            result.minimum -= sectionInset.top
            result.maximum += (sectionInset.top + sectionInset.bottom)
        }
        
        return result
    }
 

    /*
    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }
        
        let availableWidth = collectionView.bounds.width
        let maxNumColumns = 1
        let cellWidth = (availableWidth / CGFloat(maxNumColumns)).rounded(.down)
        
        self.itemSize = CGSize(width: cellWidth, height: cellWidth)
        self.sectionInset = UIEdgeInsets(top: self.minimumInteritemSpacing, left: 0.0, bottom: 0.0, right: 0.0)
        self.sectionInsetReference = .fromSafeArea
    }
 */
    
}
