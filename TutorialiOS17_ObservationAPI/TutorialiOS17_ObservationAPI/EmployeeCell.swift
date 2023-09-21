//
//  EmployeeCell.swift
//  TutorialiOS17_ObservationAPI
//
//  Created by Javier Rodríguez Gómez on 21/9/23.
//

import SwiftUI

struct EmployeeCell: View {
	let employee: Employee
	
	var body: some View {
		VStack(alignment: .leading) {
			Text("\(employee.lastName), \(employee.firstName)")
				.font(.headline)
			Text(employee.email)
				.font(.caption)
				.foregroundStyle(.secondary)
			Text(employee.department.rawValue)
				.font(.footnote)
				.padding(.top, 5)
		}
	}
}

#Preview {
	EmployeeCell(employee: .test)
}
