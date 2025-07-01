import Foundation

class SuggestionService{
    
    
    func getSuggestedGames(rating: [Int64: Double]) ->[SuggestedGame]{
        do{
            
            let recommender = try GamesReccomender(configuration: .init())
                
            
            let input = GamesReccomenderInput(items : rating, k: 10, restrict_: [], exclude: [])
            
            let result = try recommender.prediction(input: input)
            
            var suggestedGames = [SuggestedGame]()
            
            for suggestion in result.recommendations{
                let score = result.scores[suggestion] ?? 0
                suggestedGames.append(SuggestedGame(id: Int(suggestion), rating: score))
            }
            return suggestedGames
            
        }catch(let error){
            print(error)
            return []
        }
        
    }
}
