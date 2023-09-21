//
//  DetailEmployee.swift
//  TutorialiOS17_ObservationAPI
//
//  Created by Javier Rodríguez Gómez on 21/9/23.
//

import SwiftUI

struct DetailEmployee: View {
	let employee: Employee
	
    var body: some View {
		Form {
			LabeledContent("First Name", value: employee.firstName)
			LabeledContent("Last Name", value: employee.lastName)
			LabeledContent("Email", value: employee.email)
		}
		.navigationTitle("Employees Detail")
		.navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
	NavigationStack {
		DetailEmployee(employee: .test)
	}
}
