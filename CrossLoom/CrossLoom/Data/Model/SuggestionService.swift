import Foundation

class SuggestionService{
    
    
    func getSuggestedGames(rating: [Int64: Double]) async->[SuggestedGame]{
        do{
            
            let recommender = try GamesReccomender(configuration: .init())
                
            
            let input = GamesReccomenderInput(items : rating, k: 10, restrict_: [], exclude: [])
            
            let result = try await recommender.prediction(input: input)
            
            var suggestedGames = [SuggestedGame]()
            
            for suggestion in result.recommendations{
                let score = result.scores[suggestion] ?? 0
                let game = await SuggestedGame(id: Int(suggestion), rating: score)
                suggestedGames.append(game)
            }
            return suggestedGames
            
        }catch(let error){
            print(error)
            return []
        }
        
    }
}
