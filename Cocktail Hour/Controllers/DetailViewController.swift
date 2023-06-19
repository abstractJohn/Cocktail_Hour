//
//  DetailViewController.swift
//  Cocktail Hour
//
//  Created by John Nelson on 6/15/23.
//

import UIKit

class DetailViewController: UIViewController {
    
    let cocktail: CocktailDetail
    
    init(cocktail: CocktailDetail) {
        self.cocktail = cocktail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let title = PaddingLabel(frame: CGRect(origin: view.frame.origin, size: CGSize(width: view.frame.width, height: 150)))
        title.text = self.cocktail.name
        title.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        title.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(title)
        title.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        title.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        title.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        
        let bannerImage = UIImageView(frame: CGRect(origin: view.frame.origin, size: CGSize(width: view.frame.width, height: 200)))
        bannerImage.load(url: URL(string: self.cocktail.thumb)!)
        bannerImage.translatesAutoresizingMaskIntoConstraints = false
        let categoryBadge = PaddingLabel(frame: CGRect(x: bannerImage.frame.minX, y: bannerImage.frame.maxY - 40, width: 100, height: 30))
        categoryBadge.layer.cornerRadius = 15
        categoryBadge.text = self.cocktail.category.uppercased()
        categoryBadge.font = UIFont.systemFont(ofSize: 13, weight: .heavy)
        categoryBadge.backgroundColor = UIColor(named: "FigmaGreen")
        categoryBadge.textColor = .white
        categoryBadge.translatesAutoresizingMaskIntoConstraints = false
        bannerImage.addSubview(categoryBadge)
        categoryBadge.leadingAnchor.constraint(equalTo: bannerImage.leadingAnchor, constant: 20).isActive = true
        categoryBadge.bottomAnchor.constraint(equalTo: bannerImage.bottomAnchor, constant: -10).isActive = true
        let instructionsHeader = UILabel(frame: CGRect(origin: CGPoint(x: bannerImage.frame.minX, y: bannerImage.frame.maxY), size: CGSize(width: 200, height: 25)))
        instructionsHeader.text = "INSTRUCTIONS"
        instructionsHeader.textColor = UIColor(named: "FigmaGray")
        instructionsHeader.translatesAutoresizingMaskIntoConstraints = false
        let instructions = UILabel(frame: CGRect(origin: CGPoint(x: instructionsHeader.frame.minX, y: instructionsHeader.frame.maxY), size: CGSize(width: view.frame.width, height: 150)))
        instructions.text = self.cocktail.instructions
        instructions.lineBreakMode = .byWordWrapping
        instructions.translatesAutoresizingMaskIntoConstraints = false
        
        let ingredientsHeader = UILabel(frame: CGRect(origin: CGPoint(x: instructions.frame.minX, y: instructions.frame.maxY), size: CGSize(width: 200, height: 25)))
        ingredientsHeader.text = "\(self.cocktail.ingredients != nil ? self.cocktail.ingredients!.count.formatted() : "") INGREDIENTS"
        ingredientsHeader.textColor = UIColor(named: "FigmaGray")
        ingredientsHeader.translatesAutoresizingMaskIntoConstraints = false
        
        let ingredientsList = UIStackView(frame: CGRect(origin: CGPoint(x: ingredientsHeader.frame.minX, y: ingredientsHeader.frame.maxY), size: CGSize(width: view.frame.width, height: 300)))
        ingredientsList.axis = .vertical
        for ingredient in self.cocktail.ingredients! {
            let measurement = UILabel(frame: CGRect(x: 0, y: 0, width: 65, height: 25))
            measurement.text = ingredient.measure
            measurement.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            let ingredientLabel = UILabel(frame: CGRect(x: 0, y: 0, width: ingredientsList.frame.width - 65, height: 25))
            ingredientLabel.text = ingredient.name
            ingredientLabel.font = UIFont.systemFont(ofSize: 14)
            let ingredientView = UIStackView(arrangedSubviews: [measurement, ingredientLabel])
            ingredientView.axis = .horizontal
            ingredientsList.addArrangedSubview(ingredientView)
        }
        ingredientsList.translatesAutoresizingMaskIntoConstraints = false
        let glassHeader = UILabel(frame: CGRect(origin: CGPoint(x: instructions.frame.minX, y: instructions.frame.maxY), size: CGSize(width: 200, height: 25)))
        glassHeader.text = "GLASS NEEDED"
        glassHeader.textColor = UIColor(named: "FigmaGray")
        glassHeader.translatesAutoresizingMaskIntoConstraints = false
        let glass = UILabel(frame: CGRect(origin: CGPoint(x: glassHeader.frame.minX, y: glassHeader.frame.maxY), size: CGSize(width: view.frame.width, height: 25)))
        glass.text = self.cocktail.glass
        glass.font = UIFont.systemFont(ofSize: 14)
        glass.translatesAutoresizingMaskIntoConstraints = false
        let stack = UIStackView(arrangedSubviews: [bannerImage, instructionsHeader, instructions, ingredientsHeader, ingredientsList, glassHeader, glass])
        stack.axis = .vertical
        view.addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        stack.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        title.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        title.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        title.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}
