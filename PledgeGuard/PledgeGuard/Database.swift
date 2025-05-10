//
//  Database.swift
//  PledgeGuard
//
//  Created by Harshitha Rajesh on 4/25/25.
//

import Foundation
import CoreLocation
import FirebaseFirestore

struct User: Codable, Hashable {
    var userId: String
    var dateJoined: Date
    var fullName: String
    var pledgeText: String
    var role: String
    var actionCount: Int
    var reportCount: Int
}
class Report: ObservableObject, Identifiable, Hashable {
    
    static func == (lhs: Report, rhs: Report) -> Bool {
          return lhs.id == rhs.id
      }

      func hash(into hasher: inout Hasher) {
          hasher.combine(id)
      }
    
    let id: String

    @Published var description: String
    @Published var location: GeoPoint?
    @Published var address: String?
    @Published var time: Date
    @Published var urgencyLevel: String
    @Published var userId: String
    @Published var flagged: Int
    @Published var addressed: Int
    @Published var resolved: Bool

    init(id: String,
         description: String,
         location: GeoPoint?,
         address: String?,
         time: Date,
         urgencyLevel: String,
         userId: String,
         flagged: Int,
         addressed: Int,
         resolved: Bool) {
        self.id = id
        self.description = description
        self.location = location
        self.address = address
        self.time = time
        self.urgencyLevel = urgencyLevel
        self.userId = userId
        self.flagged = flagged
        self.addressed = addressed
        self.resolved = resolved
    }
}

struct Action: Codable, Hashable {
    var userId: String
    var type: String
    var category: String
    var time: Date
    var notes: String? // Currently not implemented
}

struct Resource: Hashable {
    var category: String
    var contentURL: String
    var region: String
    var title: String
}
