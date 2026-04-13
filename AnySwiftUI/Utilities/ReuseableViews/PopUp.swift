//
//  PopUp.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 24/03/26.
//

import SwiftUI

struct PopUp: View {
    
    var cloOk: () -> Void = { }
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            VStack(spacing: 16) {
                
                IBLabel (
                    text: "Successfull!", font: .semibold(.largeTitle))
                IBLabel (
                    text: "Your account is pending approval and you will receive notifications once you are authorised to book jobs.",
                    font: .regular(.subtitle),
                    color: .black
                )
                .multilineTextAlignment(.center)
                
                Button(action: {
                    self.cloOk()
                }) {
                    Text("Ok")
                        .font(.bold(.subtitle))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 40)
                        .background(.BUTTON)
                        .cornerRadius(12)
                }
            }
        } // MAIN VSTACK
        .padding(16)
        .background (
            RoundedRectangle(cornerRadius: 11)
                .stroke(Color.gray, lineWidth: 0.5)
                .background (
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.white))
                )
        )
        .padding(.horizontal, 40)
    }
    
}

struct PopBeforeBooking: View {
    
    var cloYes: (Bool) -> Void = { _ in }
    var companyName: String
    var shiftDetail: String
    var instantBooking: String
    var bookingNote: String
    var shiftStatus: String
    var comingFor: String
    
    var actionButtonTitle: String {
        if comingFor == "Book" {
            return "Book"
        } else if shiftStatus == "Accept" {
            return "WhatsApp\n+6582231930 To Cancel"
        } else {
            return "Yes, Proceed"
        }
    }
    
    var actionButtonHeight: CGFloat {
        return shiftStatus == "Accept" && comingFor != "Book" ? 44 : 24
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            VStack(spacing: 16) {
                
                IBLabel (
                    text: comingFor == "Book" ? "Are you sure you want to book?" : "Are you sure you want to cancel your booking?", font: .semibold(.largeTitle)
                )
                .multilineTextAlignment(.center)
                
                IBLabel (
                    text: companyName,
                    font: comingFor == "Book" ? .semibold(.title) : .regular(.subtitle),
                    color: comingFor == "Book" ? .THEME : .black
                )
                .multilineTextAlignment(.center)
                
                if comingFor == "Book" {
                    if instantBooking != "" {
                        IBLabel (
                            text: instantBooking,
                            font: .semibold(.subtitle),
                            color: .BUTTON
                        )
                        .multilineTextAlignment(.center)
                    }
                } else {
                    IBLabel (
                        text: "Any Confirmed bookings will have $10 cancellation penalty fee to be deducted on you next shifts payment.",
                        font: .semibold(.subtitle),
                        color: .black
                    )
                    .multilineTextAlignment(.center)
                }
                
                IBLabel (
                    text: comingFor == "Book" ? shiftDetail : "Account suspension for 1 month if you have cancelled last minute twice in a month.",
                    font: comingFor == "Book" ? .medium(.subtitle) : .semibold(.subtitle),
                    color: .black
                )
                .multilineTextAlignment(.center)
                
                IBLabel (
                    text: comingFor == "Book" ?  bookingNote : "Any shift cancelled within 48 hours of work start with is considered last minute.",
                    font: .regular(.subtitle),
                    color: comingFor == "Book" ? .gray : .black
                )
                .multilineTextAlignment(.center)
                
                HStack(spacing: 24) {
                    IBSimpletButton(height: actionButtonHeight, width: 140, fgColor: .black, buttonText: actionButtonTitle, bg: .clear, cloClicked: {
                        if shiftStatus == "Accept" {
                            cloYes(false)
                        } else {
                            cloYes(true)
                        }
                    })
                    .padding(.all, 8)
                    .overlay (
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.BUTTON, lineWidth: 0.5)
                    )
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    
                    IBSimpletButton(height: 24, width: 120, fgColor: .black, buttonText: comingFor == "Book" ? "Return" : "Back", bg: .clear, cloClicked: {
                        cloYes(false)
                    })
                    .padding(.all, 8)
                    .overlay (
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.BUTTON, lineWidth: 0.5)
                    )
                }
            }
        } // MAIN VSTACK
        .padding(16)
        .background (
            RoundedRectangle(cornerRadius: 11)
                .stroke(Color.gray, lineWidth: 0.5)
                .background (
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.white))
                )
        )
        .padding(.horizontal, 40)
    }
}

struct PopUpDelete: View {
    
    let companyDetail: String
    var cloOk: () -> Void = { }
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            VStack(spacing: 16) {
                
                IBLabel (
                    text: "Your shift has been successfully cancelled in:", font: .semibold(.largeTitle)
                )
                .multilineTextAlignment(.center)
                
                IBLabel (
                    text: companyDetail,
                    font: .regular(.subtitle),
                    color: .black
                )
                .multilineTextAlignment(.center)
                
                IBSimpletButton (
                    height: 24, width: 120, fgColor: .black,buttonText: "Ok", bg: .clear, cloClicked: {
                        cloOk()
                    }
                )
                .padding(.all, 8)
                .overlay (
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.BUTTON, lineWidth: 0.5)
                )
            }
        } // MAIN VSTACK
        .padding(16)
        .background (
            RoundedRectangle(cornerRadius: 11)
                .stroke(Color.gray, lineWidth: 0.5)
                .background (
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.white))
                )
        )
        .padding(.horizontal, 40)
    }
}

struct PopSuccess: View {
    
    let title: String
    let description: String
    var cloOk: () -> Void = { }
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            VStack(spacing: 16) {
                
                if title != "" {
                    IBLabel (
                        text: title, font: .semibold(.largeTitle)
                    )
                    .multilineTextAlignment(.center)
                }
                
                if description != "" {
                    IBLabel (
                        text: description,
                        font: .regular(.subtitle),
                        color: .black
                    )
                    .multilineTextAlignment(.center)
                }
                
                IBSimpletButton (
                    height: 24, width: 120, fgColor: .black,buttonText: "Home", bg: .clear, cloClicked: {
                        cloOk()
                    }
                )
                .padding(.all, 8)
                .overlay (
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.BUTTON, lineWidth: 0.5)
                )
            }
        } // MAIN VSTACK
        .padding(16)
        .background (
            RoundedRectangle(cornerRadius: 11)
                .stroke(Color.gray, lineWidth: 0.5)
                .background (
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.white))
                )
        )
        .padding(.horizontal, 40)
    }
}

#Preview {
    PopSuccess(title: "guud", description: "ssffs")
}

struct PopDocView: View {
    
    var countryName: String
    var documentRequired: String
    
    var cloSubmit: ((UIImage?, UIImage?) -> Void)?
    var cloBack:(() -> Void)?
    @State private var selectedNRICImage: UIImage?
    @State private var selectedDOCImage: UIImage?
    @State private var showNRICImagePicker = false
    @State private var showDOCImagePicker = false

    var isButtonDisabled: Bool {
        documentRequired == "Yes"
        ? (selectedNRICImage == nil || selectedDOCImage == nil)
        : selectedNRICImage == nil
    }

    var buttonOpacity: Double {
        documentRequired == "Yes"
        ? ((selectedNRICImage == nil || selectedDOCImage == nil) ? 0.6 : 1.0)
        : (selectedNRICImage == nil ? 0.6 : 1.0)
    }
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    dismiss()
                }

            VStack(alignment: .center, spacing: 16) {
                if documentRequired == "Yes" {
                    if countryName == "Singapore" {
                        Text("NRIC Verification Required")
                            .font(.system(size: 14, weight: .semibold))
                    } else {
                        Text("ID Verification Required")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    
                    if countryName == "Singapore" {
                        Text("To complete your first booking, please upload a clear photo of your NRIC for identity verification.")
                            .font(.system(size: 12, weight: .regular))
                            .multilineTextAlignment(.center)
                    } else {
                        Text("To complete your first booking, please upload a clear photo of your valid ID. This is a one-time requirement to keep our platform safe and secure.")
                            .font(.system(size: 12, weight: .regular))
                            .multilineTextAlignment(.center)
                    }
                    
                    Text("Your information will be kept confidential and used only for verification")
                        .font(.system(size: 12, weight: .regular))
                        .multilineTextAlignment(.center)
                    
                    if countryName == "Singapore" {
                        Text("Front Page NRIC Picture")
                            .font(.system(size: 14, weight: .semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        VStack(spacing: 4) {
                            Text("Front of ID Photo")
                                .font(.system(size: 14, weight: .semibold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            if countryName == "India" {
                                Text("(Aadhaar, PAN, Driving Licence, Voter ID, Passport)")
                                    .font(.system(size: 12, weight: .regular))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            } else if countryName == "Malaysia" {
                                Text("(MyKad, Passport, Driving Licence)")
                                    .font(.system(size: 12, weight: .regular))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            } else if countryName == "Philippines" {
                                Text("(PhilSys ID, Passport, Driver’s License, UMID)")
                                    .font(.system(size: 12, weight: .regular))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            .frame(height: 120)

                        if let image = selectedNRICImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 100)
                                .clipped()
                        }
                        
                        Button {
                            showNRICImagePicker = true
                        } label: {
                            Text(selectedNRICImage == nil ? "Upload a photo" : "Change photo")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 10)
                                .background(selectedNRICImage == nil ? Color("BUTTON_COLOR") : Color("BUTTON_COLOR").opacity(0.75))
                                .cornerRadius(6)
                        }
                    }
                    
                    // Food and Hygeine
                    Text("Food Safety & Hygiene Certificate Required")
                        .font(.system(size: 14, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Text("Since you're applying for a Kitchen or chef job, please upload your Food Safety & Hygiene Certificate (FSHC).\nThis is a one time requirement.")
                        .font(.system(size: 12, weight: .regular))
                        .multilineTextAlignment(.center)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            .frame(height: 120)

                        if let image = selectedDOCImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 100)
                                .clipped()
                        }
                        
                        Button {
                           showDOCImagePicker = true
                        } label: {
                            Text(selectedDOCImage == nil ? "Upload a Document" : "Change Document")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 10)
                                .background(selectedDOCImage == nil ? Color("BUTTON_COLOR") : Color("BUTTON_COLOR").opacity(0.75))
                                .cornerRadius(6)
                        }
                    }
                    
                } else {
                    if countryName == "Singapore" {
                        Text("NRIC Verification Required")
                            .font(.system(size: 18, weight: .semibold))
                    } else {
                        Text("ID Verification Required")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    
                    if countryName == "Singapore" {
                        Text("To complete your first booking, please upload a clear photo of your NRIC for identity verification.")
                            .font(.system(size: 14, weight: .medium))
                            .multilineTextAlignment(.center)
                    } else {
                        Text("To complete your first booking, please upload a clear photo of your valid ID. This is a one-time requirement to keep our platform safe and secure.")
                            .font(.system(size: 14, weight: .medium))
                            .multilineTextAlignment(.center)
                    }
                    
                    Text("Your information will be kept confidential and used only for verification")
                        .font(.system(size: 14, weight: .medium))
                        .multilineTextAlignment(.center)
                    
                    if countryName == "Singapore" {
                        Text("Front Page NRIC Picture")
                            .font(.system(size: 14, weight: .semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        VStack(spacing: 4) {
                            Text("Front of ID Photo")
                                .font(.system(size: 14, weight: .semibold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            if countryName == "India" {
                                Text("(Aadhaar, PAN, Driving Licence, Voter ID, Passport)")
                                    .font(.system(size: 12, weight: .regular))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            } else if countryName == "Malaysia" {
                                Text("(MyKad, Passport, Driving Licence)")
                                    .font(.system(size: 12, weight: .regular))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            } else if countryName == "Philippines" {
                                Text("(PhilSys ID, Passport, Driver’s License, UMID)")
                                    .font(.system(size: 12, weight: .regular))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            .frame(height: 120)

                        if let image = selectedNRICImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 100)
                                .clipped()
                        }
                        
                        Button {
                            showNRICImagePicker = true
                        } label: {
                            Text(selectedNRICImage == nil ? "Upload a photo" : "Change photo")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 10)
                                .background(selectedNRICImage == nil ? Color("BUTTON_COLOR") : Color("BUTTON_COLOR").opacity(0.75))
                                .cornerRadius(6)
                        }
                    }
                }

                HStack(spacing: 12) {

                    Button {
                        guard selectedNRICImage != nil || selectedDOCImage != nil else {
                            print("Both images are nil")
                            return
                        }
                        self.cloSubmit?(selectedNRICImage, selectedDOCImage)
                    } label: {
                        Text("Submit")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(selectedNRICImage != nil ? Color("BUTTON_COLOR") : Color.gray)
                            .cornerRadius(18)
                    }
                    .disabled(isButtonDisabled)
                    .opacity(buttonOpacity)
                    
                    Button {
                        cloBack?()
                    } label: {
                        Text("Back")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color(.systemGray6))
                            .cornerRadius(18)
                    }
                }
                .padding(.horizontal)
            }
            .padding()
            .background (
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
            )
            .padding(.horizontal, 16)
        }
        .sheet(isPresented: $showNRICImagePicker) {
            ImagePicker(sourceType: .camera) { image in
                selectedNRICImage = image
            }
        }
        .sheet(isPresented: $showDOCImagePicker) {
            ImagePicker(sourceType: .camera) { image in
                selectedDOCImage = image
            }
        }
    }
    
//    private func openNRICCameraPicker() {
//        guard let topVC = UIApplication.topViewController() else { return }
//        
//        CameraHandler.sharedInstance.showActionSheet(vc: topVC)
//        CameraHandler.sharedInstance.imagePickedBlock = { img in
//            selectedNRICImage = img
//        }
//    }
    
//    private func openDOCCameraPicker() {
//        guard let topVC = UIApplication.topViewController() else { return }
//        
//        CameraHandler.sharedInstance.showActionSheet(vc: topVC)
//        CameraHandler.sharedInstance.imagePickedBlock = { img in
//            selectedDOCImage = img
//        }
//    }
}
