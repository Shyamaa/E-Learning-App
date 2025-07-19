//
//  ProfileView.swift
//  Elearning App
//
//  Created by MMI Softwares Pvt Ltd on 19/07/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var loginVM: LoginViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    ProfileHeaderView(user: loginVM.currentUser)
                    
                    // Stats Cards
                    StatsCardsView(user: loginVM.currentUser)
                    
                    // Achievements
                    AchievementsView(user: loginVM.currentUser)
                    
                    // Settings
                    SettingsView()
                    
                    // Logout Button
                    LogoutButtonView {
                        loginVM.logout()
                    }
                }
                .padding()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// Profile Header View
struct ProfileHeaderView: View {
    let user: User?
    
    var body: some View {
        VStack(spacing: 16) {
            // Profile Image
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 100, height: 100)
                
                if let user = user {
                    Text(String(user.firstName.prefix(1)) + String(user.lastName.prefix(1)))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                } else {
                    Image(systemName: "person.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                }
            }
            
            // User Info
            VStack(spacing: 4) {
                if let user = user {
                    Text(user.fullName)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(user.email)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Member since \(user.joinDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else {
                    Text("Guest User")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

// Stats Cards View
struct StatsCardsView: View {
    let user: User?
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            StatCard(
                title: "Courses",
                value: "\(user?.progress.completedCourses ?? 0)",
                subtitle: "Completed",
                icon: "book.fill",
                color: .blue
            )
            
            StatCard(
                title: "Study Time",
                value: "\(user?.progress.totalStudyTime ?? 0)",
                subtitle: "Minutes",
                icon: "clock.fill",
                color: .orange
            )
            
            StatCard(
                title: "Streak",
                value: "\(user?.progress.currentStreak ?? 0)",
                subtitle: "Days",
                icon: "flame.fill",
                color: .red
            )
        }
    }
}

// Stat Card View
struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(subtitle)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// Achievements View
struct AchievementsView: View {
    let user: User?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Achievements")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            if let achievements = user?.progress.achievements, !achievements.isEmpty {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ForEach(achievements) { achievement in
                        AchievementCard(achievement: achievement)
                    }
                }
            } else {
                Text("No achievements yet. Keep learning to earn badges!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
            }
        }
    }
}

// Achievement Card View
struct AchievementCard: View {
    let achievement: User.Achievement
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: achievement.icon)
                .font(.title)
                .foregroundColor(Color(achievement.type.color))
            
            Text(achievement.title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            Text(achievement.description)
                .font(.caption2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// Settings View
struct SettingsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Settings")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            VStack(spacing: 0) {
                SettingsRow(icon: "bell.fill", title: "Notifications", subtitle: "On")
                SettingsRow(icon: "moon.fill", title: "Dark Mode", subtitle: "Off")
                SettingsRow(icon: "wifi", title: "Download over WiFi only", subtitle: "On")
                SettingsRow(icon: "globe", title: "Language", subtitle: "English")
            }
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
}

// Settings Row View
struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            Text(title)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(subtitle)
                .foregroundColor(.secondary)
                .font(.caption)
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.caption)
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

// Logout Button View
struct LogoutButtonView: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .foregroundColor(.red)
                
                Text("Logout")
                    .fontWeight(.semibold)
                    .foregroundColor(.red)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.red.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(LoginViewModel())
} 