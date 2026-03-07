//
//  OnboardingView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 10/02/26.
//

import SwiftUI

struct OnboardingView: View {

    @StateObject private var viewModel = OnboardingViewModel()

    var body: some View {
        ZStack {
            LinearGradient (
                gradient: Gradient(colors: [Color(.systemGray6), Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Main content
                TabView(selection: $viewModel.currentPage) {
                    
                    ForEach(0..<viewModel.onboardingData.count, id: \.self) { indexx in
                        
                        VStack(spacing: 40) {
                            Image(viewModel.onboardingData[indexx].imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 240)
                                .padding(.top, 40)
                            
                            VStack(spacing: 16) {
//                                Text(viewModel.onboardingData[indexx].title)
//                                    .font(.customfont(.heavy, fontSize: 28))
//                                    .multilineTextAlignment(.center)
                                
                                IBLabel(text: viewModel.onboardingData[indexx].title, font: .semibold(.heavyLarge))
                                    .multilineTextAlignment(.center)
                                
//                                Text(viewModel.onboardingData[indexx].description)
//                                    .font(.customfont(.medium, fontSize: 18))
//                                    .foregroundColor(.gray)
//                                    .multilineTextAlignment(.center)
//                                    .padding(.horizontal, 40)
                                
                                IBLabel(text: viewModel.onboardingData[indexx].description, font: .medium(.largeTitle), color: .gray)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                            }
                        }
                        .tag(indexx)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                Spacer()

                // Page indicators
                HStack(spacing: 12) {
                    ForEach(0..<viewModel.onboardingData.count, id: \.self) { index in
                        Circle()
                            .fill(viewModel.currentPage == index
                                  ? Color.black
                                  : Color.gray.opacity(0.3))
                            .frame(width: 12, height: 12)
                    }
                }
                .padding(.bottom, 32)

                // Bottom buttons
                HStack(spacing: 16) {

//                    Text("Skip")
//                        .font(.customfont(.medium, fontSize: 16))
//                        .foregroundColor(.gray)
//                        .onTapGesture {
//                            viewModel.skipTapped()
//                        }
                    
                    IBLabel(text: "Skip", font: .medium(.title), color: .gray)
                        .onTapGesture {
                            viewModel.skipTapped()
                        }


                    Spacer()

//                    Button {
//                        viewModel.nextTapped()
//                    } label: {
//                        HStack(spacing: 12) {
//                            Text("Next")
//                            Image(systemName: "chevron.right")
//                        }
//                        .font(.customfont(.medium, fontSize: 16))
//                        .foregroundColor(.white)
//                        .padding(.horizontal, 24)
//                        .padding(.vertical, 16)
//                        .background(Color.black)
//                        .clipShape(RoundedRectangle(cornerRadius: 25))
//                    }

                    IBLabel(text: "Next", font: .medium(.title), color: .THEME)
                        .onTapGesture {
                            viewModel.nextTapped()
                        }

                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)

        // 👇 Navigation controlled by ViewModel
        .navigationDestination(isPresented: $viewModel.goToLogin) {
            UserTypeView()
        }
    }
}


#Preview {
    OnboardingView()
}
