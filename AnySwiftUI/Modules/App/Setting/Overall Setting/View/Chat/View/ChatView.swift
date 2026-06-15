//
//  ChatView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 11/06/26.
//

import SwiftUI

struct ChatView: View {
    
    @State var viewModel = ChatViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 0) {
                ScrollView(showsIndicators: false) {
                    if viewModel.isLoading {
                        ProgressView("Loading Chats...")
                            .frame(maxWidth: .infinity)
                    } else if viewModel.arrayChatList.isEmpty {
                        EmptyView(title: "", subtitle: "No Chats Available", img: "")
                    } else {
                        ForEach(viewModel.arrayChatList, id: \.id) { chatss in
                            ChatListCard(obj: chatss)
                                .onTapGesture {
                                    viewModel.requestiD = chatss.request_id ?? ""
                                    viewModel.receiveriD = chatss.sender_id ?? ""
                                    viewModel.userName = "\(chatss.first_name ?? "") \(chatss.last_name ?? "")"
                                    viewModel.navToChatDetail = true
                                }
                        }
                    }
                }
                .refreshable {
                    await loadChats()
                }
            }
            .padding(.all, 16)
        }
        .navigationTitle("Messages")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .alert(item: $viewModel.customError) { error in
            Alert (
                title: Text(appName),
                message: Text(error.localizedDescription),
                dismissButton: .default(Text("OK"))
            )
        }
        .task {
            await loadChats()
        }
        .navigationDestination(isPresented: $viewModel.navToChatDetail) {
            ChatDetailView (
                receiveriD: viewModel.receiveriD,
                requestiD: viewModel.requestiD,
                userName: viewModel.userName
            )
        }
    }
    
    func loadChats() async {
        viewModel.isLoading = true
        
        defer {
            viewModel.isLoading = false
        }
        
        do {
            let response = try await viewModel.fetchChatMessage()
            if response.status == "1" {
                viewModel.arrayChatList = response.result ?? []
            }
        } catch {
            viewModel.customError = .customError(message: error.localizedDescription)
        }
    }
}

struct ChatListCard: View {
    
    let obj: Res_ChatList
    
    var body: some View {
        HStack(spacing: 14) {
           
           // MARK: Profile Image
           AsyncImage(url: URL(string: obj.image ?? "")) { phase in
               switch phase {
               case .success(let img):
                   img.resizable().scaledToFill()
               default:
                   ZStack {
                       Circle()
                           .fill(Color.gray.opacity(0.2))
                       
                       Image(systemName: "person.fill")
                           .font(.system(size: 22))
                           .foregroundColor(.gray)
                   }
               }
           }
           .frame(width: 56, height: 56)
           .clipShape(Circle())
           .overlay (
               Circle()
                   .stroke(Color.white, lineWidth: 2)
           )
           .shadow(radius: 2)
           
           // MARK: Name + Job
           VStack(alignment: .leading, spacing: 6) {
               HStack {
                   Text("\(obj.first_name ?? "") \(obj.last_name ?? "")")
                       .font(.system(size: 17, weight: .semibold))
                       .foregroundColor(.primary)
                   
                   Spacer()
                   
                   if (obj.no_of_message ?? 0) > 0 {
                       Text("\(obj.no_of_message ?? 0)")
                           .font(.caption2.bold())
                           .foregroundColor(.white)
                           .frame(minWidth: 22, minHeight: 22)
                           .background (
                               Capsule()
                                   .fill(.red)
                           )
                   }
               }

               Text(obj.last_message ?? "")
                   .font(.system(size: 13, weight: .medium))
                   .foregroundColor(.gray)
               
               HStack {
                   Spacer()
                   Text(obj.date_time ?? "")
                       .font(.system(size: 10, weight: .regular))
                       .foregroundColor(.gray)
               }
           }
           .frame(maxWidth: .infinity, alignment: .leading)
       }
       .padding()
       .background (
           RoundedRectangle(cornerRadius: 16)
            .fill(Color.white)
       )
       .overlay (
           RoundedRectangle(cornerRadius: 16)
               .stroke (Color.black.opacity(0.06),
                   lineWidth: 1
               )
       )
       .shadow (
           color: Color.black.opacity(0.05),
           radius: 6,
           x: 0,
           y: 4
       )
    }
}

#Preview {
    ChatView()
}
