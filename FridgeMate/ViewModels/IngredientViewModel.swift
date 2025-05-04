//
//  IngredientViewModel.swift
//  FridgeMate
//
//  Created by Rujeet Prajapati on 04/05/2025.
//

import Foundation

class IngredientViewModel: ObservableObject{
    
    @Published var ingredients: [Ingredient] = []
    
    let session  = URLSession(configuration: .default)
    
    func searchIngredient(query: String){
        let url = URL(string: "\(Constant().baseURL)/food/ingredients/search?query=\(query)")
        
        let task = session.dataTask(with: url!){
            (data,response,error) in
            if let error = error{
                
            }
            if let safeData = data{
                self.parseJson(ingredientData: data!["results"])
            }
        }
        task.resume()
    }
    
    func parseJson(ingredientData: Data){
        let decoder =  JSONDecoder()
        do{
            let decodedData = try decoder.decode(Ingredient.self, from: ingredientData)
            DispatchQueue.main.async{
                self.ingredients = decodedData
            }
        }catch{
            print(error)
        }
    }
}
