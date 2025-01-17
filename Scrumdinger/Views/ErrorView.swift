//
//  ErrorView.swift
//  Scrumdinger
//
//  Created by eternal on 2024/4/4.
//

import SwiftUI

struct ErrorView: View {
    
    let errorWrapper: ErrorWrapper
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("An error has occurred!")
                    .font(.title)
                    .padding(.bottom)
                Text(errorWrapper.error.localizedDescription)
                    .font(.headline)
                Text(errorWrapper.guidance)
                    .font(.caption)
                    .padding(.top)
                Spacer()
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Dismiss") {
                        dismiss()
                    }
                }
            }
        }
        
    }
}

#Preview {
 
    enum SampleError: Error {
        case errorRequired
    }
    
    let errorWrapper = ErrorWrapper(error: SampleError.errorRequired, guidance: "You can safely ignore this error.")
    
    return ErrorView(errorWrapper: errorWrapper)
}
