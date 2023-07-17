import Foundation

func fetchDataFromServer(completion: @escaping (Result<String, Error>) -> Void) {
    // Пример асинхронной операции, которая занимает время
    DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
        if Bool.random() {
            completion(.success("Данные успешно получены"))
        } else {
            completion(.failure(NSError(domain: "com.example", code: 0, userInfo: [NSLocalizedDescriptionKey: "Ошибка получения данных"])))
        }
    }
}

func processFetchedData(data: String) {
    print("Обработка полученных данных: \(data)")
}

async func fetchDataAndProcess() {
    do {
        let data = try await withUnsafeThrowingContinuation { (continuation: UnsafeContinuation<Result<String, Error>, Never>) in
            fetchDataFromServer { result in
                continuation.resume(with: result)
            }
        }
        processFetchedData(data: data)
    } catch {
        print("Ошибка: \(error)")
    }
}

Task {
    await fetchDataAndProcess()
}

