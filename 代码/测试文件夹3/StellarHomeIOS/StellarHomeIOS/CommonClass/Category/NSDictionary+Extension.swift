extension NSDictionary {
    func toJson() -> JSON?{
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            let json =  try? JSON(data: data)
            return json
        }catch let error {
            print(error)
            return nil
        }
    }
}