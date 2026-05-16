//
//  TaskGroup.swift
//  Await
//
//  Created by Влад Шимченко on 16.05.26.
//

import Foundation

enum FetchError: Error {
    case networkFailure(Int)
    case timeout
    case invalidData
}

struct UserProfile: Sendable {
    let id: Int
    let name: String
}

struct Post: Sendable {
    let id: Int
    let userID: Int
    let title: String
}

struct Analytics: Sendable {
    let userID: Int
    let events: [String]
}

// MARK: - Actor для кэша (защита от data race)

actor Cache<Key: Hashable, Value> {
    private var storage: [Key: Value] = [:]
    private var inflightTasks: [Key: Task<Value, Error>] = [:]

    func fetch(_ key: Key, loader: @escaping () async throws -> Value) async throws -> Value {
        if let cached = storage[key] {
            return cached
        }

        if let existing = inflightTasks[key] {
            return try await existing.value // ждем уже летящий запрос
        }

        let task = Task<Value, Error> {
            try await loader()
        }
        inflightTasks[key] = task

        do {
            let value = try await task.value
            storage[key] = value
            inflightTasks.removeValue(forKey: key)
            return value
        } catch {
            inflightTasks.removeValue(forKey: key)
            throw error

        }
    }
}


final class LocalStorage {

    func fetchUser(id: Int) async throws -> UserProfile {
        try await Task.sleep(nanoseconds: UInt64.random(in: 100_000_000...300_000_000))
        guard id > 0 else { throw FetchError.invalidData }
        return UserProfile(id: id, name: "User_\(id)")
    }

    func fetchPosts(for userID: Int) async throws -> [Post] {
        try await Task.sleep(nanoseconds: 150_000_000)
        return (1...3).map { Post(id: $0, userID: userID, title: "Post \($0) of user \(userID)") }
    }

    func fetchAnalytics(for userId: Int) async throws -> Analytics {
        try await Task.sleep(nanoseconds: 150_000_000)
        return Analytics(userID: userId, events: ["login", "view", "click"])
    }

    func fetchRecommendations(basedOn posts: [Post]) async throws -> [String] {
        try await Task.sleep(nanoseconds: 100_000_000)
        return posts.map { "Rec for: \($0.title)" }
    }

    // MARK: - Гонка с таймаутом через withThrowingTaskGroup

    func withTimeout<T: Sendable>(
        seconds: Double,
        operation: @escaping @Sendable () async throws -> T
    ) async throws -> T {
        try await withThrowingTaskGroup(of: T.self) { group in
            group.addTask { try await operation() }
            group.addTask {
                try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
                throw FetchError.timeout
            }

            // Берём первый результат — победителя гонки
            let result = try await group.next()!
            group.cancelAll() // отменяем проигравшего
            return result
        }
    }

    // MARK: - Основная функция с каскадным параллелизмом

    func loadDashboard(userIds: [Int]) async throws -> [String] {
        let cache = Cache<Int, UserProfile>()

        // Параллельно грузим всех пользователей через TaskGroup
        let profiles: [UserProfile] = try await withThrowingTaskGroup(of: UserProfile.self) { group in
            for id in userIds {
                group.addTask {
                    // Каждый запрос — через кэш с дедупликацией
                    try await cache.fetch(id) {
                        try await self.withTimeout(seconds: 1.0) {
                            try await self.fetchUser(id: id)
                        }
                    }
                }
            }
            return try await group.reduce(into: []) { $0.append($1) }
        }

        // Для каждого пользователя параллельно запрашиваем посты + аналитику
        // Результаты второго уровня тоже параллельны между пользователями
        let summaries: [String] = try await withThrowingTaskGroup(of: String.self) { outerGroup in
            for profile in profiles {
                outerGroup.addTask {
                    // Внутренняя группа: посты и аналитика стартуют одновременно
                    async let posts = self.fetchPosts(for: profile.id)
                    async let analytics = self.fetchAnalytics(for: profile.id)

                    // Ждём оба результата, затем цепляем рекомендации
                    let (resolvedPosts, resolvedAnalytics) = try await (posts, analytics)
                    let recommendations = try await self.fetchRecommendations(basedOn: resolvedPosts)

                    return """
                        [\(profile.name)]
                          posts: \(resolvedPosts.map(\.title).joined(separator: ", "))
                          events: \(resolvedAnalytics.events.joined(separator: ", "))
                          recs: \(recommendations.prefix(2).joined(separator: ", "))
                        """
                }
            }

            return try await outerGroup.reduce(into: []) { $0.append($1) }
        }

        return summaries
    }
}
