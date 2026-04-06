//
//  QuizView.swift
//  Zest Zoo
//
//  Created by Fahri Can on 06/04/2026.
//

import SwiftUI
import SwiftData

struct QuizView: View {
    @Environment(\.modelContext) private var context
    @Environment(AppState.self) private var appState
    @State private var viewModel = QuizViewModel()
    @State private var navigateToReveal = false
    @State private var slideDirection: SlideDirection = .forward

    enum SlideDirection { case forward, backward }

    var currentQ: QuizQuestion {
        viewModel.questions[viewModel.currentQuestionIndex]
    }

    var body: some View {
        ZStack {
            Color(hex: "#F5F5F7").ignoresSafeArea()

            VStack(spacing: 0) {

                // Header
                HStack {
                    if viewModel.currentQuestionIndex > 0 {
                        Button {
                            slideDirection = .backward
                            viewModel.goBack()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                        }
                    } else {
                        Color.clear.frame(width: 24)
                    }

                    Spacer()

                    Text("\(viewModel.currentQuestionIndex + 1) / \(viewModel.questions.count)")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundColor(.gray)

                    Spacer()
                    Color.clear.frame(width: 24)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                // Progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 6)

                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.black)
                            .frame(width: geo.size.width * viewModel.progress, height: 6)
                            .animation(.spring(duration: 0.4), value: viewModel.progress)
                    }
                }
                .frame(height: 6)
                .padding(.horizontal, 24)
                .padding(.top, 16)

                // Question card — slides on change
                ZStack {
                    QuestionCardView(
                        question: currentQ,
                        selectedOptionIndex: viewModel.selectedOptions[viewModel.currentQuestionIndex],
                        onSelect: { optIdx in
                            viewModel.select(optionIndex: optIdx, for: viewModel.currentQuestionIndex)
                            // Auto-advance after short delay
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                if viewModel.currentQuestionIndex < viewModel.questions.count - 1 {
                                    slideDirection = .forward
                                    viewModel.advance()
                                }
                            }
                        }
                    )
                    .id(viewModel.currentQuestionIndex)
                    .transition(slideDirection == .forward
                        ? .asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading))
                        : .asymmetric(
                            insertion: .move(edge: .leading),
                            removal: .move(edge: .trailing))
                    )
                    .animation(.spring(duration: 0.35), value: viewModel.currentQuestionIndex)
                }
                .padding(.top, 32)

                Spacer()

                // CTA — only show on last question once answered
                if viewModel.currentQuestionIndex == viewModel.questions.count - 1
                    && viewModel.selectedOptions[viewModel.currentQuestionIndex] != nil {
                    Button {
                        let user = viewModel.createUser(context: context)
                        appState.currentUser = user
                        appState.hasCompletedOnboarding = true
                        navigateToReveal = true
                    } label: {
                        Text("Meet My Coach →")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.black)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.spring(duration: 0.4), value: viewModel.isComplete)
                }
            }
        }
        .fullScreenCover(isPresented: $navigateToReveal) {
            CoachRevealView(coach: viewModel.assignedCoach()) {
                appState.appPhase = .mainApp
            }
        }
    }
}

// MARK: - Question Card
struct QuestionCardView: View {
    let question: QuizQuestion
    let selectedOptionIndex: Int?
    let onSelect: (Int) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {

            // Section label
            Text(question.section == .lazinessScore ? "Finding your coach" : "Getting to know you")
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundColor(.gray)
                .textCase(.uppercase)
                .tracking(1.2)

            // Question text
            Text(question.question)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(.black)
                .fixedSize(horizontal: false, vertical: true)

            // Options
            VStack(spacing: 12) {
                ForEach(Array(question.options.enumerated()), id: \.offset) { idx, option in
                    OptionRow(
                        text: option.text,
                        isSelected: selectedOptionIndex == idx,
                        onTap: { onSelect(idx) }
                    )
                }
            }
        }
        .padding(24)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.06), radius: 16, x: 0, y: 4)
        .padding(.horizontal, 20)
    }
}

// MARK: - Option Row
struct OptionRow: View {
    let text: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color.black : Color.gray.opacity(0.3), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    if isSelected {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 14, height: 14)
                    }
                }

                Text(text)
                    .font(.system(size: 16, weight: isSelected ? .semibold : .regular, design: .rounded))
                    .foregroundColor(isSelected ? .black : .gray)
                    .multilineTextAlignment(.leading)

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(isSelected ? Color.black.opacity(0.05) : Color(hex: "#F8F8F8"))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.black.opacity(0.2) : Color.clear, lineWidth: 1.5)
            )
        }
        .animation(.spring(duration: 0.2), value: isSelected)
    }
}
