//
//  CalculationHistory.swift
//  Quantifyr
//
//  Created by Israel Manzo on 3/13/26.
//

import Foundation

struct CalculationRecord: Identifiable, Codable {
    let id: UUID
    let formulaName: String
    let result: String
    let date: Date
    
    init(id: UUID = UUID(), formulaName: String, result: String, date: Date = Date()) {
        self.id = id
        self.formulaName = formulaName
        self.result = result
        self.date = date
    }
}

@Observable
final class HistoryManager {
    static let shared = HistoryManager()
    
    private let key = "quantifyr_calculation_history"
    private let maxRecords = 50
    
    var records: [CalculationRecord] = []
    
    private init() {
        load()
    }
    
    func add(formulaName: String, result: String) {
        let record = CalculationRecord(formulaName: formulaName, result: result)
        records.insert(record, at: 0)
        if records.count > maxRecords {
            records = Array(records.prefix(maxRecords))
        }
        save()
    }
    
    func clear() {
        records = []
        save()
    }
    
    func remove(_ record: CalculationRecord) {
        records.removeAll { $0.id == record.id }
        save()
    }
    
    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([CalculationRecord].self, from: data) else {
            records = []
            return
        }
        records = decoded
    }
    
    private func save() {
        guard let data = try? JSONEncoder().encode(records) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}
