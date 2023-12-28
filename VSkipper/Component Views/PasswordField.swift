//  Created by p0ch1ta on 28/12/2023 for project VSkipper

import SwiftUI

struct PasswordField: View {
    
    @Binding var password: String
    
    @State private var passwordHidden = true
    
    var body: some View {
        HStack {
            if passwordHidden {
                SecureField("", text: $password)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.vertical, 2)
                    .multilineTextAlignment(.trailing)
                Button {
                    passwordHidden.toggle()
                } label: {
                    Image(systemName: "eye.fill")
                        .foregroundColor(.cyan)
                }
            } else {
                TextField("", text: $password)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.vertical, 2)
                    .multilineTextAlignment(.trailing)
                Button {
                    passwordHidden.toggle()
                } label: {
                    Image(systemName: "eye.slash.fill")
                        .foregroundColor(.cyan)
                }
            }
//            Button {
//                passwordHidden.toggle()
//            } label: {
//                Image(systemName: passwordHidden ? "eye.fill" : "eye.slash.fill")
//                    .foregroundColor(.cyan)
//                if passwordHidden {
//                    Image(systemName: "eye.fill")
//                        .foregroundColor(.cyan)
//                } else {
//                    Image(systemName: "eye.slash.fill")
//                        .foregroundColor(.cyan)
//                }
//            }
        }
    }
}

#Preview {
    PasswordField(password: .constant("password"))
}
