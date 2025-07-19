//
//  LoginView.swift
//  Elearning App
//
//  Created by MMI Softwares Pvt Ltd on 19/07/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: LoginViewModel

    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // App Logo/Title
                    VStack(spacing: 16) {
                        Image(systemName: "book.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.white)
                        
                        Text("E-Learning App")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Learn at your own pace")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.top, 60)
                    
                    // Login Form
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            TextField("Enter your email", text: $viewModel.email)
                                .textFieldStyle(CustomTextFieldStyle())
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            SecureField("Enter your password", text: $viewModel.password)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        // Login Button
                        Button(action: {
                            viewModel.login()
                        }) {
                            HStack {
                                if viewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Text("Sign In")
                                        .fontWeight(.semibold)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                viewModel.isLoading ? Color.gray : Color.white
                            )
                            .foregroundColor(
                                viewModel.isLoading ? Color.white : Color.blue
                            )
                            .cornerRadius(12)
                        }
                        .disabled(viewModel.isLoading)
                        
                        // Forgot Password Button
                        Button(action: {
                            viewModel.forgotPassword()
                        }) {
                            Text("Forgot Password?")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .disabled(viewModel.isLoading)
                        
                        // Error Message
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.caption)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        
                        // Demo Credentials
                        VStack(spacing: 8) {
                            Text("Demo Credentials")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text("Email: student@example.com")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))
                            
                            Text("Password: learning123")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))
                        }
                        .padding(.top, 20)
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
    }
}

// Custom TextField Style
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.white.opacity(0.9))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    LoginView()
        .environmentObject(LoginViewModel())
}

