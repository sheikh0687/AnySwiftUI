//
//  ProfileView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 30/03/26.
//

import SwiftUI
import CountryPicker

struct ProfileView: View {
    
    @EnvironmentObject var appState: AppState
    @State var viewModel = EditProfileViewModel()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ZStack(alignment: .top) {
                VStack(alignment: .center, spacing: 24) {
                    profileImageView
                    
                    profileInfo
                }
                .padding(.horizontal, 36)
            }
            .task {
                await loadCountries()
                await loadProfileDetails()
                await loadJobTypes()
                await loadCountryDocDt()
            }
            .sheet(isPresented: $viewModel.showProfilePicker) {
                ImagePicker(sourceType: .camera) { img in
                    viewModel.selectedProfileImage = img
                }
            }
            .sheet(isPresented: $viewModel.showNRCPicker) {
                ImagePicker(sourceType: .camera) { img in
                    viewModel.selectedNRICImage = img
                }
            }
            .sheet(isPresented: $viewModel.showDOCPicker) {
                ImagePicker(sourceType: .camera) { img in
                    viewModel.selectedDOCImage = img
                }
            }
            .sheet(isPresented: $viewModel.showCountryPicker) {
                CountryPickerUI(country: $viewModel.countryObj)
            }
            .sheet(isPresented: $viewModel.showLogoPicker) {
                ImagePicker(sourceType: .camera) { img in
                    viewModel.businessLogo = img
                }
            }
            .sheet(isPresented: $viewModel.showAddressPicker) {
                LocationPickerView { result in
                    if let res = result {
                        viewModel.businessAddress = res["address"] as? String ?? ""
                        viewModel.businessLat     = res["lat"] as? Double ?? 0.0
                        viewModel.businessLon     = res["lng"] as? Double ?? 0.0
                    }
                }
            }
            .alert(item: $viewModel.customError) { error in
                Alert (
                    title: Text(appName),
                    message: Text(error.localizedDescription),
                    dismissButton: .default(Text("Ok"))
                )
            }
            .alert("Success", isPresented: $viewModel.showSuccessAlert) {
                Button("OK") {
                    appState.goToHome = true
                }
            } message: {
                Text(viewModel.successMessage)
            }
        }
    }
    
    // MARK: PROFILE VIEW
    private var profileImageView: some View {
        ZStack(alignment: .bottomTrailing) {

            if let selectedImage = viewModel.selectedProfileImage {

                // User selected image
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())

            } else if let imageURL = URL(string: viewModel.profileImageURL),
                      !viewModel.profileImageURL.isEmpty {

                // API image
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Image("profile")
                        .resizable()
                        .scaledToFit()
                        .background (
                            Circle()
                                .stroke(Color.black.opacity(0.2), lineWidth: 0.5)
                        )
                }
                .frame(width: 120, height: 120)
                .clipShape(Circle())

            } else {

                // Placeholder
                Image("profile")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .background (
                        Circle()
                            .stroke(Color.black.opacity(0.2), lineWidth: 0.5)
                    )
            }

            Image("edit")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .padding(2)
                .background(.white)
                .cornerRadius(6)
                .shadow(radius: 2)
        }
        .onTapGesture {
            viewModel.showProfilePicker = true
        }
    }
    
    // MARK: PROFILE DETAILS
    private var profileInfo: some View {
        VStack(alignment: .leading, spacing: 24) {
            
            // UFIRST NAME
            VStack(alignment: .leading, spacing: 0) {
                IBLabel (
                    text: "First Name",
                    font: .regular(.description),
                    color: .BLACK
                )
                IBTextField (
                    placeholder: "First Name",
                    text: $viewModel.firstName,
                    keyboardType: UIKeyboardType.default
                )
                Divider()
            }
            
            // ULAST NAME
            VStack(alignment: .leading, spacing: 0) {
                IBLabel (
                    text: "Last Name",
                    font: .regular(.description),
                    color: .BLACK
                )
                IBTextField (
                    placeholder: "Last Name",
                    text: $viewModel.lastName,
                    keyboardType: UIKeyboardType.default
                )
                Divider()
            }
            
            // UMOBILE NUMBER
            HStack(spacing: 16) {
                Button {
                    viewModel.showCountryPicker = true
                } label: {
                    HStack(spacing: 6) {
                        if let countryObj = viewModel.countryObj {
                            IBLabel (
                                text: "+\(countryObj.phoneCode)",
                                font: .medium(.largeTitle),
                                color: .black
                            )
                        }
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.gray)
                    }
                }
                .background(Color.white)
                
                VStack(alignment: .leading, spacing: 0) {
                    IBLabel (
                        text: "Mobile",
                        font: .regular(.description),
                        color: .BLACK
                    )

                    IBTextField(placeholder: "Mobile", text: $viewModel.mobileNumber, keyboardType: .phonePad)
                    Divider()
                }
            }
            
            //UEMAIL ADDRESS
            VStack(alignment: .leading, spacing: 0) {
                IBLabel (
                    text: "Email",
                    font: .regular(.description),
                    color: .BLACK
                )
                IBTextField (
                    placeholder: "Email Address",
                    text: $viewModel.email,
                    keyboardType: UIKeyboardType.default
                )
                Divider()
            }
            
            if viewModel.userType == "Client" {
                //CBUSINESS NAME
                VStack(alignment: .leading, spacing: 0) {
                    IBLabel (
                        text: "Business Name",
                        font: .regular(.description),
                        color: .BLACK
                    )
                    IBTextField (
                        placeholder: "Enter Business Name",
                        text: $viewModel.businessName,
                        keyboardType: UIKeyboardType.default
                    )
                    Divider()
                }
                
                //CBUSINESS REGISTRATION
                VStack(alignment: .leading, spacing: 0) {
                    IBLabel (
                        text: viewModel.clientDocName,
                        font: .regular(.description),
                        color: .BLACK
                    )
                    IBTextField (
                        placeholder: "Enter",
                        text: $viewModel.businessRegNo,
                        keyboardType: UIKeyboardType.default
                    )
                    Divider()
                }
                
                //CBUSINESS ADDRESS
                VStack(alignment: .leading, spacing: 0) {
                    IBLabel (
                        text: "Business Address",
                        font: .regular(.description),
                        color: .BLACK
                    )
                    
                    HStack {
                        IBTextField (
                            placeholder: "Enter Business Address",
                            text: $viewModel.businessAddress,
                            keyboardType: UIKeyboardType.default
                        )
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .onTapGesture {
                        viewModel.showAddressPicker = true
                    }
                    Divider()
                }
                
                //CBUSINESS LOGO
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        .frame(height: 140)

                    if let selectedImage = viewModel.businessLogo {

                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipped()

                    } else if let imageURL = URL(string: viewModel.businessLogoURL),
                              !viewModel.businessLogoURL.isEmpty {

                        AsyncImage(url: imageURL) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Image("upload_image")
                                .resizable()
                                .scaledToFill()
                        }
                        .frame(width: 120, height: 120)
                        .clipped()

                    } else {
                        Image("upload_image")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipped()
                    }
                }
                .onTapGesture {
                    viewModel.showLogoPicker = true
                }

            } else {
                //UJOB TYPE
                VStack(alignment: .leading, spacing: 8) {
                    IBLabel (
                        text: "Select Your Preferred Job Type",
                        font: .medium(.subtitle),
                        color: .BLACK
                    )
                    VStack(spacing: 4) {
                        Menu {
                            ForEach(viewModel.arrayJobTypes, id: \.id) { country in
                                Button {
                                    viewModel.selectedJobName = country.name ?? ""
                                    viewModel.selectedJobiD = country.id ?? ""
                                    viewModel.isDocRequired = country.document_requied ?? ""
                                    viewModel.doccName = country.document_name ?? ""
                                } label: {
                                    Text(country.name ?? "")
                                }
                            }
                        } label: {
                            HStack(spacing: 10) {
                                Button {
                                    print("Select Country")
                                } label: {
                                    IBLabel(text: viewModel.selectedJobName.isEmpty ? "Select Job Type" : viewModel.selectedJobName, font: .medium(.title), color: .gray)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Divider()
                    }
                }
                
                //UPAYMENT TYPE
                VStack(alignment: .leading, spacing: 12) {
                    IBLabel (
                        text: "Receive Payment Via",
                        font: .medium(.subtitle),
                        color: .BLACK
                    )
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        
                        IBLabel (
                            text: viewModel.payNowTitle,
                            font: .medium(.subtitle),
                            color: .BLACK
                        )
                        
                        VStack(alignment: .leading, spacing: 0) {
                            IBLabel (
                                text: viewModel.payNowPlaceholder,
                                font: .regular(.description),
                                color: .BLACK
                            )
                            IBTextField (
                                placeholder: "Enter",
                                text: $viewModel.payNowNumber,
                                keyboardType: UIKeyboardType.default
                            )
                            Divider()
                        }
                    }
                }
                
                //UOTHER PAYMENT TYPE
                VStack(alignment: .leading, spacing: 12) {
                    IBLabel (
                        text: "Or",
                        font: .medium(.subtitle),
                        color: .BLACK
                    )
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        IBLabel (
                            text: "Local Bank Transfer",
                            font: .medium(.subtitle),
                            color: .BLACK
                        )
                        
                        VStack(alignment: .leading, spacing: 0) {
                            IBLabel (
                                text: "Enter bank number",
                                font: .regular(.description),
                                color: .BLACK
                            )
                            IBTextField (
                                placeholder: "Enter bank number",
                                text: $viewModel.bankNumber,
                                keyboardType: UIKeyboardType.default
                            )
                            Divider()
                        }
                        
                        VStack(alignment: .leading, spacing: 0) {
                            IBLabel (
                                text: "Enter bank name",
                                font: .regular(.description),
                                color: .BLACK
                            )
                            IBTextField (
                                placeholder: "Enter bank name",
                                text: $viewModel.bankName,
                                keyboardType: UIKeyboardType.default
                            )
                            Divider()
                        }
                    }
                }
                
                //UNRC DOCUMENT
                VStack(alignment: .leading, spacing: 8) {
                    IBLabel (
                        text: viewModel.workerDocName,
                        font: .medium(.subtitle),
                        color: .BLACK
                    )
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            .frame(height: 120)

                        if let selectedImage = viewModel.selectedNRICImage {

                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipped()

                        } else if let imageURL = URL(string: viewModel.nrcDocumentURL),
                                  !viewModel.nrcDocumentURL.isEmpty {

                            AsyncImage(url: imageURL) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Image("upload_image")
                                    .resizable()
                                    .scaledToFill()
                            }
                            .frame(width: 100, height: 100)
                            .clipped()

                        } else {

                            Image("upload_image")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipped()
                        }
                    }
                    .onTapGesture {
                        viewModel.showNRCPicker = true
                    }
                    
                    if viewModel.isDocRequired == "Yes" {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 0)
                                .frame(height: 120)

                            HStack {
                                if let image = viewModel.selectedNRICImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                } else if let imageUrl = URL(string: viewModel.jobDocumentURL), !viewModel.jobDocumentURL.isEmpty {
                                    AsyncImage(url: imageUrl) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        Image("upload_image")
                                            .resizable()
                                            .scaledToFill()
                                    }
                                    .frame(width: 100, height: 100)
                                    .clipped()
                                }
                                else {
                                    Image("upload_image")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                }
                                
                                Spacer()
                                
                                IBLabel (
                                    text: viewModel.doccName,
                                    font: .medium(.subtitle),
                                    color: .BLACK
                                )
                            }
                            .onTapGesture {
                                viewModel.showDOCPicker = true
                            }
                        }
                    }
                }
            }
            
            
            IBSubmitButton(buttonText: "Upload") {
                viewModel.mobileCode = viewModel.countryObj?.phoneCode ?? ""
                if viewModel.validateProfileFields() {
                    Task {
                        await callUpdateProfile()
                    }
                }
            }
        }
    }
}

// MARK: API CALLING
extension ProfileView {
    
    @MainActor
    func loadCountries() async {
        do {
            let response = try await viewModel.fetchCountryList()
            if response.status == "1" {
                viewModel.arrayCountries = response.result ?? []
            }
        } catch {
            print("Error fetching countries: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func loadProfileDetails() async {
        viewModel.isLoading = true

        defer {
            viewModel.isLoading = false
        }

        do {
            let response = try await viewModel.fetchProfileDetails()

            guard response.status == "1",
                  let profile = response.result else {
                return
            }

            // MARK: - Text Fields
            let mobileWithCode = profile.mobile_with_code ?? ""
            let mobile = profile.mobile ?? ""
            let extractedCode = mobileWithCode.replacingOccurrences(of: mobile, with: "").replacingOccurrences(of: "+", with: "")
            
            if let matchedCountry = viewModel.arrayCountries.first(where: { ($0.phone_code ?? "").replacingOccurrences(of: "+", with: "") == extractedCode }) {
                viewModel.countryObj = Country(phoneCode: matchedCountry.phone_code ?? "", isoCode: matchedCountry.sortname ?? "")
            } else {
                // Fallback to Singapore if no match found or extractedCode is empty
                viewModel.countryObj = Country(phoneCode: "65", isoCode: "SG")
            }
            
            viewModel.firstName = profile.first_name ?? ""
            viewModel.lastName = profile.last_name ?? ""
            viewModel.mobileNumber = profile.mobile ?? ""
            viewModel.email = profile.email ?? ""
            
            // MARK: - Image URLs
            viewModel.profileImageURL = profile.image ?? ""
            
            if viewModel.userType == "Client" {
                viewModel.businessName = profile.business_name ?? ""
                viewModel.businessRegNo = profile.une_register_number ?? ""
                viewModel.businessAddress = profile.business_address ?? ""
                viewModel.businessLat = Double(profile.lat ?? "") ?? 0.0
                viewModel.businessLon = Double(profile.lon ?? "" ) ?? 0.0
                viewModel.businessLogoURL = profile.business_logo ?? ""
            } else {
                viewModel.payNowNumber = profile.pay_now_number ?? ""
                viewModel.bankName = profile.bank_name ?? ""
                viewModel.bankNumber = profile.local_bank_number ?? ""

                // MARK: - Job Type
                viewModel.selectedJobiD = profile.job_type_id ?? ""
                viewModel.selectedJobName = profile.job_type_name ?? ""

                // MARK: - PayNow Label & Placeholder
                switch profile.country_name {
                case "India":
                    viewModel.payNowTitle = "UPI"
                    viewModel.payNowPlaceholder = "Enter your UPI ID"

                case "Philippines":
                    viewModel.payNowTitle = "GCash"
                    viewModel.payNowPlaceholder = "Same as phone number registered"

                case "Malaysia":
                    viewModel.payNowTitle = "DuitNow"
                    viewModel.payNowPlaceholder = "Same as phone number registered"

                default:
                    viewModel.payNowTitle = "PayNow"
                    viewModel.payNowPlaceholder = "Same as phone number registered"
                }

                viewModel.jobDocumentURL = profile.job_document ?? ""
                viewModel.nrcDocumentURL = profile.nrc_document ?? ""
            }
        } catch {
            viewModel.customError = .customError(message: error.localizedDescription)
        }
    }
    
    @MainActor
    func loadJobTypes() async {
        viewModel.isLoading = true
        
        defer {
            viewModel.isLoading = false
        }
        
        do {
            let response = try await viewModel.fetchJobTypes()
            if response.status == "1" {
                viewModel.arrayJobTypes = response.result ?? []
            }
        } catch {
            viewModel.customError = .customError(message: error.localizedDescription)
        }
    }
    
    @MainActor
    func loadCountryDocDt() async {
        viewModel.isLoading = true
        
        defer { viewModel.isLoading = false }
        
        do {
            let response = try await viewModel.fetchCountryDocDetails()
            if response.status == "1" {
                viewModel.workerDocName = response.result?.worker_document ?? ""
                viewModel.clientDocName = response.result?.client_document ?? ""
            }
        } catch {
            viewModel.customError = .customError(message: error.localizedDescription)
        }
    }
    
    @MainActor
    func callUpdateProfile() async {
        viewModel.isLoading = true
        
        defer { viewModel.isLoading = false }
        
        do {
            let response = try await viewModel.updateUserProfile()
            if response.status == "1" {
                viewModel.successMessage = "Profile updated successfully"
                viewModel.showSuccessAlert = true
            }
        } catch {
            viewModel.customError = .customError(message: error.localizedDescription)
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppState.shared)
}
