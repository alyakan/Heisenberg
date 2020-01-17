//
//  ContentView.swift
//  BreakingChemistery
//
//  Created by Aly Yakan on 17/01/2020.
//  Copyright © 2020 Aly Yakan. All rights reserved.
//

import SwiftUI

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content

    var body: some View {
        VStack {
            ForEach(0 ..< rows) { row in
                HStack {
                    ForEach(0 ..< self.columns) { column in
                        self.content(row, column)
                    }
                }
            }
        }
    }

    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }
}

struct PeriodicTable: Codable {
    let elements: [Element]
}

struct Element: Codable {
    let name: String
    let number: Int
    let period: Int
    let xpos: Int
    let ypos: Int

    var numberString: String {
        "\(number)"
    }

    var periodString: String {
        "\(period)"
    }
}

struct ContentView: View {
    var items = [Color.red, Color.orange, Color.yellow, Color.green, Color.blue, Color.purple]
    let periodicElements = loadElements()

    var body: some View {
        return ScrollView(Axis.Set.vertical, showsIndicators: true) {
            ScrollView(Axis.Set.horizontal, showsIndicators: true) {
                // 9 * 18
                GridStack(rows: 10, columns: 18) { row, col in

                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(self.element(inRow: row, column: col) == nil ? Color.white : Color.red)
                            .frame(width: 100, height:
                            100)
                            .shadow(radius: 8)

                        VStack(alignment: .leading, spacing: 16) {
                            Text(self.element(inRow: row, column: col)?.numberString ?? "")
                                .font(.caption)
                            Text(self.element(inRow: row, column: col)?.name ?? "No element")
                                .font(.system(size: 13))
                            Text(self.element(inRow: row, column: col)?.periodString ?? "")
                                .font(.caption)
                        }
                    }
                    .foregroundColor(Color.black)

                }
            }
        }

    }

    func element(inRow row: Int, column: Int) -> Element? {
        return periodicElements.first { $0.ypos == row + 1 && $0.xpos == column + 1 }
    }

    static func loadElements() -> [Element] {
        guard let data = elementsData() else { return [Element]() }
        let periodicTable = decode(type: PeriodicTable.self, from: data)
        return periodicTable?.elements ?? [Element]()
    }

    static func elementsData(forResource resource: String = "PeriodicTableJSON") -> Data? {
        guard let fileUrl = Bundle.main.url(forResource: resource, withExtension: "json") else { fatalError() }
        return try? Data(contentsOf: fileUrl)
    }

    static func decode<T: Decodable>(type: T.Type, from data: Data) -> T? {
        return try? JSONDecoder().decode(type, from: data)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
