//
//  DateFormatterService.swift
//  ImageFeed
//
//  Created by Anastasiia on 14.02.2025.
//

import Foundation

final class DateFormatterService {
    private let dateFormatter: DateFormatter

    init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
    }

    func formatDate(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
}
