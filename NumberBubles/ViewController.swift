//
//  ViewController.swift
//  NumberBubles
//
//  Created by Дмитрий Рыбаков on 12.03.2024.
//

import UIKit

fileprivate var cellReuseIdentifier = "BubleCollectionViewCellReuseIdentifier"

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {
    
    //MARK: - Private
    private var collectionView: UICollectionView?
    private var bubleArray = [[Int]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupCollectionView()
    }
    
    private func setupData() {
        for _ in 1...100 {
            var cells = [Int]()
            for _ in 1...Int.random(in: 10...15) {
                cells.append(Int.random(in: 1..<100))
            }
            bubleArray.append(cells)
        }
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewCompositionalLayout { section, _ -> NSCollectionLayoutSection? in
            return self.layout(for: section)
        }
        let collectionView = UICollectionView(frame: view.bounds,collectionViewLayout: layout)
        collectionView.register(BubleCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)
        
        let tapGesture = UIPanGestureRecognizer(target: self, action: #selector(handleTap))
        collectionView.addGestureRecognizer(tapGesture)
        
        self.collectionView = collectionView
    }
    
    private func layout(for section: Int) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 8,
                                                     leading: 8,
                                                     bottom: 8,
                                                     trailing: 8
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .estimated(80),
                heightDimension: .estimated(80)),
            subitems: [item])
        
        let sectionLayout = NSCollectionLayoutSection(group: group)
        sectionLayout.orthogonalScrollingBehavior = .continuous
        
        return sectionLayout
    }
    
    //MARK: - Actions
    @objc private func handleTap(gesture: UITapGestureRecognizer) {
        switch gesture.state {
        case .began:
        case .ended, .cancelled:
        default:
        }
        
        
        let point = gesture.location(in: self.collectionView)
        if let indexPath = self.collectionView?.indexPathForItem(at: point),
           let cell = self.collectionView?.cellForItem(at: indexPath) {
            print("tap")
        }
    }
    
    //MARK: - UIGestureRecognizerDelegate
    
    
    
    //MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return bubleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bubleArray[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? BubleCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: bubleArray[indexPath.section][indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected")
    }
}



