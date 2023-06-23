//enum Categories: String, CaseIterable, Codable {
//
//    case BakingNDesserts = "Baking\nDesserts"
//    case SoupsNBroths = "Soups\nBroths"
//    case SaladsNAppetizers = "Salads\nAppetizers"
//    case MainNCourses = "Main\nCourses"
//    case BeveragesNCocktails = "Beverages\nCocktails"
//    case SaucesNCreams = "Sauces\nCreams"
//}
//    func getAllRecipes() -> [Recipe] {
//
//        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
//        do {
//            let recipes = try context.fetch(fetchRequest)
//            return recipes
//        } catch {
//            print("Failed to fetch recipes groups: \(error.localizedDescription)")
//            return []
//        }
//    }
//
//    func getDeletedRecipes() -> [Recipe] {
//        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "deletedDate != nil")
//        do {
//            let recipes = try context.fetch(fetchRequest)
//            return recipes
//        } catch {
//            print("Failed to fetch recipes groups: \(error.localizedDescription)")
//            return []
//        }
//    }
//
//    func getRecipesInGroup(_ group: RecipesGroup) -> [Recipe] {
//        let name = group.name!
//        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "recipesGroup.name == %@", name)
//        do {
//            let recipes = try context.fetch(fetchRequest)
//            return recipes
//        } catch {
//            print("Failed to fetch recipes groups: \(error.localizedDescription)")
//            return []
//        }
//    }
