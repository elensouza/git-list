//
//  SnapshotHelpers.swift
//  GitListTests
//
//  Created by Elen Souza on 13/06/24.
//

import Foundation
import XCTest
import SnapshotTesting

extension XCTestCase {
    func convenienceSnapshot(matching view: UIView,
                             file: StaticString = #file,
                             testName: String = #function,
                             line: UInt = #line,
                             record recording: Bool = false
) {

        if #available(iOS 13.0, *) {
            view.overrideUserInterfaceStyle = .light
            snapshot(matching: view, testName: "\(testName)light", file: file, line: line, record: recording)

            view.overrideUserInterfaceStyle = .dark
            snapshot(matching: view, testName: "\(testName)dark", file: file, line: line, record: recording)
        } else {
            snapshot(matching: view, testName: "\(testName)legacy", file: file, line: line, record: recording)
        }
    }

    func convenienceSnapshot(matching viewController: UIViewController,
                             file: StaticString = #file,
                             testName: String = #function,
                             line: UInt = #line,
                             record recording: Bool = false
    ) {
        func assert() {
            let mode: String
            if #available(iOS 13.0, *) {
                mode = viewController.overrideUserInterfaceStyle == .light ? "light" : "dark"
            } else {
                mode = "legacy"
            }
            let name = "\(testName)\(mode)-"
            snapshot(matching: viewController,
                     as: .image(on: .iPhone13Pro(.portrait)),
                     testName: "\(name)-portrait-iPhone13Pro",
                     file: file,
                     line: line,
                     record: recording)
            snapshot(matching: viewController,
                     as: .image(on: .iPhone13Pro(.landscape)),
                     testName: "\(name)-landscape-iPhone13Pro",
                     file: file,
                     line: line,
                     record: recording)
        }
        if #available(iOS 13.0, *) {
            viewController.overrideUserInterfaceStyle = .light
            assert()

            viewController.overrideUserInterfaceStyle = .dark
            assert()
        } else {
            assert()
        }
    }

    private func snapshot<Format>(matching value: UIView,
                                  as snapshotting: Snapshotting<UIView, Format> = .image,
                                  testName: String,
                                  file: StaticString = #file,
                                  line: UInt = #line,
                                  record recording: Bool) {
        let fileUrl = URL(fileURLWithPath: "\(file)", isDirectory: false)
        let fileName = fileUrl.deletingPathExtension().lastPathComponent
        let snapshotDirectory = #filePath.replacingOccurrences(of: "Helpers/SnapshotHelpers.swift",
                                                               with: "__Snapshot__/\(fileName)")
        let result = verifySnapshot(matching: value,
                                    as: snapshotting,
                                    record: recording,
                                    snapshotDirectory: snapshotDirectory,
                                    file: file,
                                    testName: testName,
                                    line: line)
        XCTAssertNil(result)
    }

    private func snapshot<Format>(matching value: UIViewController,
                                  as snapshotting: Snapshotting<UIViewController, Format> = .image,
                                  testName: String,
                                  file: StaticString = #file,
                                  line: UInt = #line,
                                  record recording: Bool) {
        let fileUrl = URL(fileURLWithPath: "\(file)", isDirectory: false)
        let fileName = fileUrl.deletingPathExtension().lastPathComponent
        let snapshotDirectory = #filePath.replacingOccurrences(of: "Helpers/SnapshotHelpers.swift",
                                                               with: "__Snapshot__/\(fileName)")
        let result = verifySnapshot(matching: value,
                                    as: snapshotting,
                                    record: recording,
                                    snapshotDirectory: snapshotDirectory,
                                    file: file,
                                    testName: testName,
                                    line: line)
        XCTAssertNil(result)
    }
}
