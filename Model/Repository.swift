import Foundation

public class Repository {

    public static let instance = Repository()

    public let sections: [Section]

    private init() {
        let fileURL = NSBundle.mainBundle().URLForResource("ExampleMenu.json", withExtension: nil)!
        let data = NSData(contentsOfURL: fileURL)!
        let raw = try! NSJSONSerialization.JSONObjectWithData(data, options: []) as! JSONObject

        sections = (JSONObjectsArrayValue(raw["sections"]) ?? []).map { Section(raw: $0) }
    }

}

public class Section: MenuObject {

    public let title: String
    public let items: [Item]

    public init(raw: JSONObject) {
        title = raw["title"]~~~ ?? ""
        items = (JSONObjectsArrayValue(raw["items"]) ?? []).map { Item(raw: $0) }
    }

}

public class Item: MenuObject {

    public let title: String
    public let price: String

    public init(raw: JSONObject) {
        title = raw["title"]~~~ ?? ""
        price = raw["price"]~~~ ?? ""
    }

}

public protocol MenuObject {

}
