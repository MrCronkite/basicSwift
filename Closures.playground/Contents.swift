
let names = ["Kolia", "Roma", "Ignat", "Ruslan"]

func backward(_ s1: String, _ s2: String) -> Bool{
    return s1 > s2
}

let reversName = names.sorted(by: { (s1: String, s2: String) -> Bool in return s1 > s2})

let reversName_1 = names.sorted(by: {(s1, s2) -> Bool in s1 > s2 })

let reversName_2 = names.sorted { s2, s1 in s1 > s2 }

print(reversName_2)

print(reversName_1)

print(reversName)
