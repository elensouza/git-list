//
//  GitResponse.swift
//  GitList
//
//  Created by Elen Souza on 09/06/24.
//

import Foundation

// MARK: - GitResponse
struct GitResponse: Decodable {
    let url, forksUrl, commitsUrl: String?
    let id, nodeId: String?
    let gitPullUrl, gitPushUrl: String?
    let htmlUrl: String?
    let files: [String: [String: FileResponse]]
    let gitPublic: Bool?
    //let createdAt, updatedAt: Date?
    let description: String?
    let comments: Int?
    //let user: NSNull
    let commentsUrl: String?
    let owner: Owner?
    let truncated: Bool?
}

// MARK: - Files
struct Files: Decodable {
    let helloWorldRb: HelloWorldRb
}

// MARK: - HelloWorldRb
struct HelloWorldRb: Decodable {
    let filename, type, language: String
    let rawUrl: String
    let size: Int
}

// MARK: - Owner
struct Owner: Decodable {
    let login: String
    let id: Int
    let nodeId: String?
    let avatarUrl: String?
    let gravatarId: String?
    let url, htmlUrl, followersUrl: String?
    let followingURL, gistsURL, starredURL: String?
    let subscriptionsUrl, organizationsUrl, reposUrl: String?
    let eventsUrl: String?
    let receivedEventsUrl: String?
    let type: String?
    let siteAdmin: Bool?
}

struct FileResponse: Decodable { }
