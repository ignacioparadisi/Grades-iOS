//
//  CreateTermView.swift
//  Grades
//
//  Created by Ignacio Paradisi on 9/20/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import SwiftUI

struct CreateTermView: View {
    private let dateFormatter: DateFormatter = DateFormatter()
    @Environment(\.presentationMode) var presentation
    @State var nameText = ""
    @State var maxGradeText = ""
    @State var minGradeText = ""
    @State var deadline = Date() {
        didSet {
            print(deadline)
            deadlineText = dateFormatter.string(from: deadline, format: .shortDate)
        }
    }
    @State private var showDatePicker = false
    @State var deadlineText = ""
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Group {
                    Text("Name").font(.title).fontWeight(.bold)
                    Text("Enter a name for the term")
                    TextField("Term name", text: $nameText)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
                        .padding(.bottom)
                }
                Group {
                    Text("Grades").font(.title).fontWeight(.bold)
                    Text("Enter max and min grade to pass")
                    HStack(spacing: 16) {
                        TextField("Max. Grade", text: $maxGradeText)
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
                        TextField("Max. Grade", text: $minGradeText)
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
                    }
                    .padding(.bottom)
                }
                Group {
                    Text("Duration").font(.title).fontWeight(.bold)
                    Text("Enter the duration of the term")
                    HStack(spacing: 16) {
                        TextField("From", text: $deadlineText, onEditingChanged: { isEditing in
                            withAnimation {
                                self.showDatePicker = isEditing
                            }
                        }, onCommit: {})
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))

                        TextField("To", text: $minGradeText)
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
                    }
                    .padding(.bottom)
                    
                    if showDatePicker {
                         DatePicker(selection: $deadline, displayedComponents: .date) {
                            Text("From")
                        }
                         .transition(.opacity)
                    }
                }
                
                Spacer()
                Button(action: {
                    print("Pressed")
                    self.presentation.wrappedValue.dismiss()
                }) {
                    HStack {
                        Spacer()
                        Text("Save").foregroundColor(Color(.white))
                        Spacer()
                    }
                    
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color("accentColor")))
            }
            .padding()
        }
        .navigationBarTitle("Add Term")
    }
}

extension CreateTermView {
}

struct CreateTermView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTermView()
    }
}
