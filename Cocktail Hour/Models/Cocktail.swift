//
//  Cocktail.swift
//  Cocktail Hour
//
//  Created by John Nelson on 6/13/23.
//

import Foundation

class Cocktail {
    var id: String
    var name: String
    var category: String
    var thumb: String
    var instructions: String
    
    init(id: String, name: String, category: String, thumb: String, instructions: String){
        self.id = id
        self.name = name
        self.category = category
        self.thumb = thumb
        self.instructions = instructions
    }
    
    init?(json: [String: Any]) {
        self.id = json["idDrink"] as? String ?? "0"
        self.name = json["strDrink"] as? String ?? "Cocktail"
        self.category = json["strCategory"] as? String ?? "Cocktail"
        self.instructions = json["strInstructions"] as? String ?? "Mix the ingredients"
        self.thumb = json["strDrinkThumb"] as? String ?? "No Image"
    }
    
    
    

    static func cocktails(matching query: String, completion: @escaping ([Cocktail]) -> Void) {
        let searchString = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=\(query)"
        let searchURL = URL(string: searchString)

        let task = URLSession.shared.dataTask(with: searchURL!) { data, response, error in
            var cocktails: [Cocktail] = []

            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                for case let result in json["drinks"] as! Array<[String: Any]> {
                    if let cocktail = Cocktail(json: result) {
                        cocktails.append(cocktail)
                    }
                }
            }
            print("cocktails loaded")
            completion(cocktails)
        }
        task.resume()
    }
}

class CocktailDetail: Cocktail {
    var ingredients: [Ingredient]?
    var glass: String?
    
    var image: String?
    
    struct Ingredient {
        var name: String
        var measure: String
    }
    
    override init?(json: [String: Any]) {
        super.init(json: json)
        self.glass = json["strGlass"] as? String ?? "Highball Glass"
        self.image = json["strImageSource"] as? String ?? "No Image"
        self.ingredients = []
        for i in 1...15 {
            if let name = json["strIngredient\(i)"] as? String {
                if let measure = json["strMeasure\(i)"] as? String {
                    self.ingredients?.append(Ingredient(name: name, measure: measure))
                } else {
                    self.ingredients?.append(Ingredient(name: name, measure: ""))
                }
            } else {
                continue
            }
        }
    }
    
    static func load(from id: String, completion: @escaping (CocktailDetail) -> Void) {
        let lookupString = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=\(id)"
        let lookupUrl = URL(string: lookupString)
        let task = URLSession.shared.dataTask(with: lookupUrl!) { data, response, error in

            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                for case let result in json["drinks"] as! Array<[String: Any]> {
                    if let cocktail = CocktailDetail(json: result) {
                        
                        DispatchQueue.main.async {
                            completion(cocktail)
                        }
                    }
                }
            }
        }
        
        task.resume()
    }
}
