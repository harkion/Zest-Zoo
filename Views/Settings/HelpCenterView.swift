//
//  HelpCenterView.swift
//  Zest Zoo
//
//  Created by Fahri Can on 12/04/2026.
//

import SwiftUI

struct HelpCenterView: View {
    @State private var expandedQuestion: String? = nil
    @State private var subject = ""
    @State private var message = ""
    @State private var showSentAlert = false

    let faqs: [FAQ] = FAQ.all

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // Contact form
                VStack(alignment: .leading, spacing: 14) {
                    Text("Contact Support")
                        .font(.system(size: 18, weight: .bold, design: .rounded))

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Subject")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(.gray)
                        TextField("What do you need help with?", text: $subject)
                            .font(.system(size: 15, design: .rounded))
                            .padding(14)
                            .background(Color(hex: "#F5F5F7"))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Message")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(.gray)
                        ZStack(alignment: .topLeading) {
                            if message.isEmpty {
                                Text("Describe your issue or question…")
                                    .font(.system(size: 15, design: .rounded))
                                    .foregroundColor(.gray.opacity(0.6))
                                    .padding(14)
                            }
                            TextEditor(text: $message)
                                .font(.system(size: 15, design: .rounded))
                                .frame(height: 120)
                                .padding(10)
                                .scrollContentBackground(.hidden)
                        }
                        .background(Color(hex: "#F5F5F7"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    Button {
                        showSentAlert = true
                        subject = ""
                        message = ""
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "paperplane.fill")
                            Text("Send Message")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .disabled(subject.isEmpty || message.isEmpty)
                    .opacity(subject.isEmpty || message.isEmpty ? 0.5 : 1)
                }
                .padding(20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.04), radius: 8)

                // FAQ section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Frequently Asked Questions")
                        .font(.system(size: 18, weight: .bold, design: .rounded))

                    ForEach(faqs) { faq in
                        FAQRow(
                            faq: faq,
                            isExpanded: expandedQuestion == faq.id.uuidString
                        ) {
                            withAnimation(.spring(duration: 0.3)) {
                                if expandedQuestion == faq.id.uuidString {
                                    expandedQuestion = nil
                                } else {
                                    expandedQuestion = faq.id.uuidString
                                }
                            }
                        }
                    }
                }
                .padding(20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.04), radius: 8)

                // Support hours
                HStack(spacing: 12) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.blue)
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Support Hours")
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                        Text("Monday–Friday, 9 AM – 6 PM. We typically respond within 24 hours.")
                            .font(.system(size: 13, weight: .regular, design: .rounded))
                            .foregroundColor(.gray)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(16)
                .background(Color.blue.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
        .background(Color(hex: "#F5F5F7"))
        .navigationTitle("Help Center")
        .navigationBarTitleDisplayMode(.large)
        .alert("Message Sent!", isPresented: $showSentAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("We'll get back to you within 24 hours.")
        }
    }
}

// MARK: - FAQ Row
struct FAQRow: View {
    let faq: FAQ
    let isExpanded: Bool
    let onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: onTap) {
                HStack {
                    Text(faq.question)
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 14)
            }

            if isExpanded {
                Text(faq.answer)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, 14)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }

            Divider()
        }
    }
}

// MARK: - FAQ Model
struct FAQ: Identifiable {
    let id = UUID()
    let question: String
    let answer: String

    static let all: [FAQ] = [
        FAQ(
            question: "How do I start a movement session?",
            answer: "Tap 'Start Movement' on your Home screen. Your coach will guide you through a 1–5 minute activity. You can also tap any notification from your coach to jump straight into a session."
        ),
        FAQ(
            question: "What are the different coaches?",
            answer: "Koala (Koa) is for gentle, low-energy days. Panda (Bo) is for building steady habits. Squirrel (Zip) is for high-energy quick bursts. You're assigned based on your quiz, but can evolve between coaches over time."
        ),
        FAQ(
            question: "How does the reward system work?",
            answer: "Every completed activity earns you currency — Leafs for Koala, Bamboo for Panda, and Acorns for Squirrel. Spend them in the Shop on coach outfits, backgrounds, and accessories."
        ),
        FAQ(
            question: "Can I change my coach?",
            answer: "Your coach evolves automatically based on your activity patterns. Stay consistent and you'll be promoted to the next tier. Take a break and your coach will adjust to meet you where you are."
        ),
        FAQ(
            question: "How do streaks work?",
            answer: "Complete at least one movement session per day to maintain your streak. Missing a day resets it back to zero — but your coach will never judge you for starting over."
        ),
        FAQ(
            question: "What are challenges and how do they work?",
            answer: "Challenges let you compete with friends to see who can accumulate the most movement minutes in a week. Go to Friends → tap a friend → Challenge. Results reset every Monday."
        ),
        FAQ(
            question: "How do I adjust notification settings?",
            answer: "Go to Settings → Notifications. You can toggle morning, afternoon, and evening nudges on or off. Your coach will only send nudges during your enabled time windows."
        ),
        FAQ(
            question: "Is my data private and secure?",
            answer: "Yes. All your movement data is stored locally on your device using Apple's SwiftData framework. We don't sell or share your personal data with third parties."
        )
    ]
}
