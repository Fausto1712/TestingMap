//
//  GridPlotter.swift
//  MapDrawer
//
//  Created by Fausto Pinto Cabrera on 06/05/24.
//

import SwiftUI

struct GridPlotter: View {
    @State private var columns: Int = 7
    @State private var rows: Int = 7
    @State private var selectedCells: [[Int]] = []
    
    var body: some View {
        VStack {
            GridView(columns: columns, rows: rows, selectedCells: $selectedCells)
                .padding()
            
            Spacer()
            
            HStack {
                Text("Columns:")
                Stepper(value: $columns, in: 1...10) {
                    Text("\(columns)")
                }
            }
            HStack {
                Text("Rows:")
                Stepper(value: $rows, in: 1...10) {
                    Text("\(rows)")
                }
            }
            HStack{
                Spacer()
                Button(action: printSelectedCells) {
                    Text("Print Cells")
                }
                Spacer()
                Button(action: reserCells) {
                    Text("Reset Cells")
                }
                Spacer()
            }
        }
        .padding()
    }
    
    private func printSelectedCells() {
        print("Selected Cells:")
        //runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * 0.0), coordinates[1] + (longitudeDelta * 0.0)], label: "1"))
        if !selectedCells.isEmpty{
            let firstCell = selectedCells[0]
            print(firstCell)
            for (index, cell) in selectedCells.enumerated() {
                let changeX = CGFloat(cell[0] - firstCell[0])
                let changeY = CGFloat(((cell[1] - firstCell[1])) * -1)
                let moveY = (changeY / CGFloat(rows-1))
                let moveX = (changeX / CGFloat(columns-1))
                
                /*print("\(String(format: "%.2f", moveX))")
                print("\(String(format: "%.2f", moveY))")
                print("[\(changeX),\(changeY)]")*/
                
                print("runMarkers.append(RunMarker(coordinates: [coordinates[0] + (latitudeDelta * \(String(format: "%.2f", moveY))), coordinates[1] + (longitudeDelta * \(String(format: "%.2f", moveX)))], label: \"\(index + 1)\"))")
            }
        }
    }
    
    private func reserCells() {
       selectedCells = []
    }
}

struct GridView: View {
    let columns: Int
    let rows: Int
    @Binding var selectedCells: [[Int]]
    
    var body: some View {
        VStack {
            ForEach(0..<rows, id: \.self) { row in
                HStack {
                    ForEach(0..<columns, id: \.self) { column in
                        CellView(row: row, column: column, isSelected: selectedCells.contains([column, row]))
                            .onTapGesture {
                                let coordinate = [column, row]
                                if let lastIndex = selectedCells.last, lastIndex != coordinate {
                                    selectedCells.append(coordinate)
                                } else if selectedCells.isEmpty {
                                    selectedCells.append(coordinate)
                                }
                            }
                    }
                }
            }
        }
        .background(drawLines())
    }
    
    private func drawLines() -> some View {
        ZStack {
            if !selectedCells.isEmpty {
                ForEach(0..<selectedCells.count - 1, id: \.self) { index in
                    let currentCoordinate = selectedCells[index]
                    let nextCoordinate = selectedCells[index + 1]
                    
                    let currentRow = currentCoordinate[1]
                    let currentColumn = currentCoordinate[0]
                    
                    let nextRow = nextCoordinate[1]
                    let nextColumn = nextCoordinate[0]
                    
                    Line(from: CGPoint(x: CGFloat(currentColumn) * 38 + 15, y: CGFloat(currentRow) * 38 + 15),
                         to: CGPoint(x: CGFloat(nextColumn) * 38 + 15, y: CGFloat(nextRow) * 38 + 15))
                    .stroke(Color.red, lineWidth: 2)
                }
            }
        }
    }
    
}

struct CellView: View {
    let row: Int
    let column: Int
    let isSelected: Bool
    
    var body: some View {
        Circle()
            .foregroundColor(isSelected ? Color.red : Color.black.opacity(0.5))
            .frame(width: 30, height: 30)
    }
}

struct Line: Shape {
    var from: CGPoint
    var to: CGPoint
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: from)
        path.addLine(to: to)
        return path
    }
}

#Preview {
    GridPlotter()
}
