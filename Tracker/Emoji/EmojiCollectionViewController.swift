//
//  EmojiCollectionViewController.swift
//  Tracker
//
//  Created by Marina Kolbina on 02/04/2023.
//

import Foundation
import UIKit

class EmojiCollectionViewController: UIViewController, UICollectionViewDelegate {
    
    let emojis = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪",
    ]
   
   var emojiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
   
   override func viewDidLoad() {
       view.addSubview(emojiCollectionView)
       emojiCollectionView.delegate = self
       emojiCollectionView.dataSource = self
       emojiCollectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
       emojiCollectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
       
       emojiCollectionView.allowsMultipleSelection = false
       emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
       
       [emojiCollectionView].forEach { item in
           item.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(item)
       }
       
       NSLayoutConstraint.activate([
           emojiCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
           emojiCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           emojiCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
           emojiCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
       ])
   }
}
 
 
extension EmojiCollectionViewController: UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? EmojiCollectionViewCell
        
        cell?.titleLabel.text = emojis[indexPath.row]
        cell?.titleLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 30.0)
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = "header"
        case UICollectionView.elementKindSectionFooter:
            id = "footer"
        default:
            id = ""
        }
        
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? SupplementaryView
        else {
            return UICollectionReusableView()
        }
        
        view.titleLabel.text = "Emoji"
        view.titleLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 19.0)
        
        NSLayoutConstraint.activate([
            view.titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 14)
            ])
//        view.titleLabel.leadingAnchor.constraint(equalTo: 28)
        return view
    }
}
 
extension EmojiCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height),
                                                         withHorizontalFittingPriority: .required,
                                                         verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 7, height: 40)
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
 
//Этот код создает экран с коллекцией эмодзи, который позволяет выбрать одну. Внутри класса определяется массив emojis, содержащий набор эмодзи, которые будут отображаться на экране. Также определяется переменная emojiCollectionView, которая является экземпляром UICollectionView с заданным фреймом и раскладкой UICollectionViewFlowLayout. В методе viewDidLoad настраивается экран, добавляется emojiCollectionView на view, устанавливаются его свойства делегата и источника данных, регистрируется ячейка EmojiCollectionViewCell и дополнительное представление SupplementaryView (шапка). Далее задаются свойства размещения элементов на экране и активируются NSLayoutConstraint. Расширение EmojiCollectionViewController: UICollectionViewDataSource реализует необходимые методы источника данных коллекции, которые определяют количество элементов в коллекции, создание ячейки и добавление заголовка для разделов. Расширение EmojiCollectionViewController: UICollectionViewDelegateFlowLayout содержит методы делегата, которые определяют размеры ячеек и дополнительных представлений, а также обрабатывают выбор и снятие выделения с ячейки.
