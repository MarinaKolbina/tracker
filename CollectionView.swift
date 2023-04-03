//
//  NewBehaviorViewController.swift
//  Tracker
//
//  Created by Marina Kolbina on 02/04/2023.
//

import Foundation
import UIKit

class EmojiCollectionView: UIViewController, UICollectionViewDelegate {
   
   var emojiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
   
   override func viewDidLoad() {
       setUp()
       applyLayOut()
   }
}

extension EmojiCollectionView {
   func setUp() {
       view.addSubview(emojiCollectionView)
       emojiCollectionView.delegate = self
       emojiCollectionView.dataSource = self //делаем контроллер источником данных (datasource) для коллекции

       emojiCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
   }
   
   func applyLayOut() {
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
       return 18
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
       cell.contentView.backgroundColor = .red
       return cell
   }

}
