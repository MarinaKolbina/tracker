//
//  NewBehaviorViewController.swift
//  Tracker
//
//  Created by Marina Kolbina on 02/04/2023.
//

import Foundation
import UIKit

class EmojiCollectionView: UIViewController, UICollectionViewDelegate {
    
    private let emojis = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪",
    ]
   
   var emojiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
   
   override func viewDidLoad() {
       setUp()
       applyLayOut()
       emojiCollectionView.allowsMultipleSelection = false
   }
}

extension EmojiCollectionView {
   func setUp() {
//       view.addSubview(emojiCollectionView)
       emojiCollectionView.delegate = self
       emojiCollectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
       emojiCollectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")

       emojiCollectionView.dataSource = self //делаем контроллер источником данных (datasource) для коллекции

//       emojiCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
   }
   
   func applyLayOut() {
       
       [emojiCollectionView].forEach { item in
           item.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(item)
       }
       
       NSLayoutConstraint.activate([
           emojiCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
           emojiCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
           emojiCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
           emojiCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
       ])
   }
}

extension EmojiCollectionView: UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? EmojiCollectionViewCell
        
        cell?.titleLabel.text = emojis[indexPath.row]
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String                                      // 1
        switch kind {                                       // 2
        case UICollectionView.elementKindSectionHeader:     // 3
            id = "header"
        case UICollectionView.elementKindSectionFooter:     // 4
            id = "footer"
        default:
            id = ""                                         // 5
        }
        
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? SupplementaryView
        else {
            return UICollectionReusableView()
        }
        
        view.titleLabel.text = "Emoji"
        view.titleLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 19.0)
        return view
    }
}

extension EmojiCollectionView: UICollectionViewDelegateFlowLayout {                              // 1
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {       // 2
        
        let indexPath = IndexPath(row: 0, section: section)         // 3
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)                   // 4
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height),
                                                         withHorizontalFittingPriority: .required,
                                                         verticalFittingPriority: .fittingSizeLevel)           // 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { // 1
        return CGSize(width: collectionView.bounds.width / 7, height: 40)   // 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.backgroundColor = UIColor(named: "grey_for_textField")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell
        cell?.backgroundColor = .white
    }


//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 12
//    }
}
