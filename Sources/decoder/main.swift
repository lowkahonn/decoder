import JavaScriptKit
import Foundation

func createJSONJSObject() -> JSObject {
    let json = JSObject.global.Object.function!.new()
    let items = JSObject.global.Object.function!.new()

    for i in 1..<3 {
        let data = JSObject.global.Object.function!.new()
        data["price"] = i.jsValue
        data["quantity"] = i.jsValue
        items["item\(i)"] = data.jsValue
    }
    json["storage"] = items.jsValue
    return json
}

func createJSONData() -> Data {
    let string = """
    {
        "storage": {
            "item1": {
                "price": 1,
                "quantity": 1,
            },
            "item2": {
                "price": 2,
                "quantity": 2,
            }
        }
    }
    """
    return string.data(using: .utf8)!
}

struct Item: Decodable {
    let price: Int
    let quantity: Int
}

struct Storage: Decodable {
    let items: [Item]

    enum CodingKeys: String, CodingKey {
        case storage
    }

    struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let storage = try container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .storage)

        var items: [Item] = []

        // it failed here when accessing `allKeys`
        for key in storage.allKeys {
            let item = try storage.decode(Item.self, forKey: key)
            items.append(item)
        }

        self.items = items
    }
}

// Using JSONDecoder
let jsonData = createJSONData()
let storage1 = try! JSONDecoder().decode(Storage.self, from: jsonData)
print(storage1.items)

// Using JSValueDecoder
let jsonJSObject = createJSONJSObject()
let storage2 = try! JSValueDecoder().decode(Storage.self, from: jsonJSObject.jsValue)
print(storage2.items)
