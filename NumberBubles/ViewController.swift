//
//  ViewController.swift
//  NumberBubles
//
//  Created by Дмитрий Рыбаков on 12.03.2024.
//

import UIKit

fileprivate var cellReuseIdentifier = "NumberCollectionViewCellReuseIdentifier"

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NumberCollectionViewCellDelegate {

    
    //MARK: - Private
    private var collectionView: UICollectionView?
    private var contentArray = [[Int]]()
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupCollectionView()
        setupTimer()
    }
    
    private func setupData() {
        for _ in 1...100 {
            var cells = [Int]()
            for _ in 1...Int.random(in: 10...15) {
                cells.append(Int.random(in: 1..<100))
            }
            contentArray.append(cells)
        }
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewCompositionalLayout { section, _ -> NSCollectionLayoutSection? in
            return self.layout(for: section)
        }
        let collectionView = UICollectionView(frame: view.bounds,collectionViewLayout: layout)
        collectionView.register(NumberCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)
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
    
    private func addMoreCells() {
        for _ in 1...30 {
            var cells = [Int]()
            for _ in 1...Int.random(in: 10...15) {
                cells.append(Int.random(in: 1..<100))
            }
            contentArray.append(cells)
        }
        collectionView?.reloadData()
    }
    
    //MARK: - Timer
    private func setupTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func updateTimer() {
        guard let visibleCellsIndexPaths = collectionView?.indexPathsForVisibleItems,
              let randomIndexPath = visibleCellsIndexPaths.randomElement()
        else {
            return
        }
        
        if let cell = collectionView?.cellForItem(at: randomIndexPath) as? NumberCollectionViewCell {
            cell.configure(with: Int.random(in: 1..<100))
        }
        
        
    }
    
    //MARK: - NumberCollectionViewCellDelegate (Animations)
    func animateTouchBegan(with view: UIView) {
        if nil != view.layer.animation(forKey: "began") {
            view.layer.removeAnimation(forKey: "began")
        }
        
        let sizeAnimation = CABasicAnimation(keyPath: "transform")
        sizeAnimation.toValue = CATransform3DMakeScale(0.8, 0.8, 1)
        sizeAnimation.duration = 0.2
        sizeAnimation.autoreverses = false
        sizeAnimation.fillMode = .forwards
        sizeAnimation.isRemovedOnCompletion = false
        view.layer.add(sizeAnimation, forKey: "began")
    }
    
    func animateTouchEnd(with view: UIView) {
        if nil != view.layer.animation(forKey: "end") {
            view.layer.removeAnimation(forKey: "end")
        }
        
        let sizeAnimation = CABasicAnimation(keyPath: "transform")
        sizeAnimation.toValue = CATransform3DMakeScale(1, 1, 1)
        sizeAnimation.duration = 0.2
        sizeAnimation.autoreverses = false
        sizeAnimation.fillMode = .forwards
        sizeAnimation.isRemovedOnCompletion = false
        view.layer.add(sizeAnimation, forKey: "end")
    }
    
    //MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionView = collectionView else { return }
        let currentPosY = scrollView.contentOffset.y
        let contentTriggerHeight = scrollView.contentSize.height - collectionView.frame.size.height - 150
        if currentPosY > 0, contentTriggerHeight > 0, currentPosY >= contentTriggerHeight {
            addMoreCells()
        }
    }
    
    //MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return contentArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentArray[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? NumberCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: contentArray[indexPath.section][indexPath.row])
        cell.delegate = self
        return cell
    }
}



