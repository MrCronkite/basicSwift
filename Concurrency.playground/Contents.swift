

print("hello async")

func listName(inGallery name: String) async -> [String]{
    await Task.sleep(2 * 1_000_000_000)
    
    print("\(name)")
    
    return ["vlad", "Josef", "Djo"]
}

print("gudbay async\(await listName(inGallery: "Liza"))")
