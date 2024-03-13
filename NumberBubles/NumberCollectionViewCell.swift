//
//  NumberCollectionViewCell.swift
//  NumberBubles
//
//  Created by Дмитрий Рыбаков on 13.03.2024.
//

import UIKit

protocol NumberCollectionViewCellDelegate: AnyObject {
    func animateTouchBegan(with: UIView)
    func animateTouchEnd(with: UIView)
}

class NumberCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Public
    weak var delegate: NumberCollectionViewCellDelegate?
    
    //MARK: - Private
    private var numberLabel = UILabel()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(numberLabel)
        
        numberLabel.layer.cornerRadius = 10
        numberLabel.layer.borderColor = UIColor.lightGray.cgColor
        numberLabel.layer.borderWidth = 2
        numberLabel.layer.masksToBounds = true
        numberLabel.textAlignment = .center
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v]-0-|", options: [], metrics: nil, views: ["v": numberLabel]).compactMap {$0})
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v]-0-|", options: [], metrics: nil, views: ["v": numberLabel]).compactMap {$0})
    }
    
    //MARK: - Public
    public func configure(with number: Int) {
        numberLabel.text = String(number)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch: UITouch = touches.first, let touchedView = touch.view else { return }
        delegate?.animateTouchBegan(with: touchedView)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch: UITouch = touches.first, let touchedView = touch.view else { return }
        delegate?.animateTouchEnd(with: touchedView)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch: UITouch = touches.first, let touchedView = touch.view else { return }
        delegate?.animateTouchEnd(with: touchedView)
    }
    
}
