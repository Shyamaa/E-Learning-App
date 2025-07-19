//
//  Elearning_AppApp.swift
//  Elearning App
//
//  Created by MMI Softwares Pvt Ltd on 19/07/25.
//

import SwiftUI

@main
struct ElearningAppSwiftUIApp: App {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @StateObject private var loginVM = LoginViewModel()

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                TabView {
                    HomeView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                    
                    NavigationView {
                        CourseListView()
                    }
                    .tabItem {
                        Image(systemName: "book.fill")
                        Text("Courses")
                    }
                    
                    SearchView()
                        .tabItem {
                            Image(systemName: "magnifyingglass")
                            Text("Search")
                        }
                    
                    ProfileView()
                        .tabItem {
                            Image(systemName: "person.fill")
                            Text("Profile")
                        }
                }
                .environmentObject(loginVM)
            } else {
                LoginView()
                    .environmentObject(loginVM)
            }
        }
    }
}
