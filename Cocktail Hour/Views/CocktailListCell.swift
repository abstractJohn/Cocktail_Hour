//
//  CocktailListCell.swift
//  Cocktail Hour
//
//  Created by John Nelson on 6/15/23.
//

import UIKit
import Foundation
import ImageIO

class CocktailListCell: UICollectionViewListCell {
    var cocktail: Cocktail?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    func setupView(cocktail: Cocktail) {
        self.cocktail = cocktail
        
        let title = UILabel(frame: self.contentView.frame)
        title.text = cocktail.name
        title.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        title.textColor = .black
        
        let category = UILabel(frame: self.contentView.frame)
        category.text = cocktail.category.uppercased()
        category.font = UIFont.systemFont(ofSize: 14, weight: .light)
        category.textColor = UIColor(named: "FigmaGray")
        
        let instructions = UILabel(frame: self.contentView.frame)
        instructions.text = cocktail.instructions
        instructions.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        instructions.numberOfLines = 2
        instructions.lineBreakMode = .byTruncatingTail
        var thumb: UIView
        if cocktail.thumb != "" {
            thumb = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
            (thumb as! UIImageView).contentMode = .scaleAspectFill
            (thumb as! UIImageView).load(url: URL(string: cocktail.thumb)!)
            (thumb as! UIImageView).makeRounded()
            
        } else {
            thumb = UILabel(frame: CGRect(origin: self.contentView.frame.origin, size: CGSize(width: self.contentView.frame.height, height: self.contentView.frame.height)))
            (thumb as! UILabel).text = "No Image"
            (thumb as! UILabel).font = UIFont.systemFont(ofSize: 12)
        }
        thumb.translatesAutoresizingMaskIntoConstraints = false
        thumb.heightAnchor.constraint(equalToConstant: 45).isActive = true
        thumb.widthAnchor.constraint(equalToConstant: 45).isActive = true
        let textStack = UIStackView(frame: self.contentView.frame)
        textStack.axis = .vertical
        textStack.addArrangedSubview(title)
        textStack.addArrangedSubview(category)
        textStack.addArrangedSubview(instructions)
        let viewStack = UIStackView(frame: self.contentView.frame)
        viewStack.axis = .horizontal
        viewStack.addArrangedSubview(thumb)
        viewStack.addArrangedSubview(textStack)
        self.contentView.addSubview(viewStack)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
    func makeRounded() {
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
        layer.masksToBounds = true
    }
    
    
}
