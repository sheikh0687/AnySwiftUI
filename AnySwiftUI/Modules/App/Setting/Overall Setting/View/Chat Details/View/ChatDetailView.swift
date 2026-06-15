//
//  ChatDetailView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 11/06/26.
//

import SwiftUI

struct ChatDetailView: View {

    @State var viewModel = ChatDetailViewModel()
    @FocusState private var isInputFocused: Bool

    var receiveriD: String = ""
    var requestiD: String = ""
    var userName: String = ""

    var body: some View {
        VStack(spacing: 0) {
            reasonBanner

            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        if viewModel.messages.isEmpty && !viewModel.isLoading {
                            emptyState
                        }

                        ForEach(viewModel.messages) { msg in
                            ChatBubbleView(message: msg)
                                .id(msg.id)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                }
                .refreshable {
                    await viewModel.fetchChatDetail(showLoader: false)
                }
                .onChange(of: viewModel.messages) {
                    scrollToBottom(proxy: proxy)
                }
                .onAppear {
                    scrollToBottom(proxy: proxy, animated: false)
                }
                .onTapGesture {
                    isInputFocused = false
                }
            }

            messageInputBar
        }
        .navigationTitle(userName)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(uiColor: .systemBackground))
        .task {
            viewModel.requestiD = requestiD
            viewModel.receiveriD = receiveriD
            await viewModel.fetchChatDetail()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("NewMessage"))) { _ in
            Task {
                await viewModel.fetchChatDetail(showLoader: false)
            }
        }
        .overlay {
            if viewModel.isLoading && viewModel.messages.isEmpty {
                ProgressView()
            }
        }
        .alert("Something went wrong", isPresented: errorBinding) {
            Button("OK", role: .cancel) { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    private var errorBinding: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )
    }

    @ViewBuilder
    private var reasonBanner: some View {
        if !viewModel.chatReason.isEmpty {
            Text(viewModel.chatReason)
                .font(.system(size: 13))
                .foregroundColor(.secondary)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity)
                .background(Color(uiColor: .systemGray6))
        }
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Image(systemName: "bubble.left.and.bubble.right")
                .font(.system(size: 36))
                .foregroundColor(.secondary)
            Text("No messages yet")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("Say hello and start the conversation")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
    }

    private func scrollToBottom(proxy: ScrollViewProxy, animated: Bool = true) {
        guard let last = viewModel.messages.last else { return }
        if animated {
            withAnimation(.easeOut(duration: 0.25)) {
                proxy.scrollTo(last.id, anchor: .bottom)
            }
        } else {
            proxy.scrollTo(last.id, anchor: .bottom)
        }
    }

    private var messageInputBar: some View {
        HStack(alignment: .bottom, spacing: 10) {
            TextField("Write here...", text: $viewModel.chatMessage, axis: .vertical)
                .focused($isInputFocused)
                .lineLimit(1...5)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color(uiColor: .systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

            Button {
                Task {
                    await viewModel.sendMessage()
                }
            } label: {
                Group {
                    if viewModel.isSending {
                        ProgressView()
                            .frame(width: 32, height: 32)
                    } else {
                        Image(systemName: "arrow.up.circle.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                    }
                }
                .foregroundColor(viewModel.canSend ? .accentColor : .gray.opacity(0.4))
            }
            .disabled(!viewModel.canSend)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(uiColor: .systemBackground))
        .overlay(
            Rectangle()
                .fill(Color(uiColor: .separator))
                .frame(height: 0.5),
            alignment: .top
        )
    }
}

// MARK: - Chat Bubble

struct ChatBubbleView: View {
    let message: ChatMessageUI

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.isCurrentUser {
                Spacer(minLength: 40)
                bubbleContent
                avatar
            } else {
                avatar
                bubbleContent
                Spacer(minLength: 40)
            }
        }
    }

    private var avatar: some View {
        AsyncImage(url: URL(string: avatarURL ?? "")) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .foregroundColor(Color(uiColor: .systemGray3))
            }
        }
        .frame(width: 40, height: 40)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color(uiColor: .systemGray4), lineWidth: 0.5))
    }

    private var avatarURL: String? {
        let url = message.avatarURL
        return (url?.isEmpty ?? true) ? nil : url
    }
    
    private var bubbleContent: some View {
        VStack(alignment: message.isCurrentUser ? .trailing : .leading, spacing: 4) {
            if !message.isCurrentUser, message.isSupport, let name = message.supportName, !name.isEmpty {
                Text(name)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 4)
            }

            Text(message.message)
                .font(.system(size: 15))
                .foregroundColor(message.isCurrentUser ? .white : .primary)
                .multilineTextAlignment(message.isCurrentUser ? .trailing : .leading)
                .fixedSize(horizontal: false, vertical: true)   // <-- key fix
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                    message.isCurrentUser
                    ? Color.accentColor
                    : Color(uiColor: .systemGray5)
                )
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .frame(maxWidth: 260, alignment: message.isCurrentUser ? .trailing : .leading)

            HStack(spacing: 4) {
                Text(message.dateTime)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)

                if message.isCurrentUser {
                    Image(systemName: message.seenStatus == "Read" ? "checkmark.circle.fill" : "checkmark.circle")
                        .font(.system(size: 11))
                        .foregroundColor(message.seenStatus == "Read" ? .accentColor : .secondary)
                }
            }
            .padding(.horizontal, 4)
        }
        .frame(maxWidth: 260, alignment: message.isCurrentUser ? .trailing : .leading)
    }
}

#Preview {
    NavigationStack {
        ChatDetailView(userName: "John Doe")
    }
}
