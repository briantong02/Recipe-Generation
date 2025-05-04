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
    
    func searchIngredient(query: String, completion: @escaping ([Ingredient]?) -> Void){
        let urlString = "\(Constant().baseURL)/food/ingredients/search?query=\(query)"
        
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
            completion(nil)
            return
        }
        
        
        URLSession.shared.dataTask(with: url){
            data,response,error in
            if let error = error{
                
            }
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(IngredientSearchResult.self, from: data)
                    DispatchQueue.main.async {
                        completion(decoded.results)
                    }
                } catch {
                    print("Decoding error:", error)
                    completion(nil)
                }
            } else {
                print("Network error:", error ?? "Unknown error")
                completion(nil)
            }
        }
        .resume()   
    }
    
}
