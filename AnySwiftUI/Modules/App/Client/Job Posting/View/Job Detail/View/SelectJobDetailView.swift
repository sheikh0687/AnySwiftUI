//
//  SelectJobDetailView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 04/05/26.
//

import SwiftUI

struct SelectJobDetailView: View {
    
    let mode: PickerMode
    /// Called on final selection: (displayName/value, id/secondParam)
    var onSelect: (String, String) -> Void
    
    @State var viewModel: JobDetailViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(mode: PickerMode, onSelect: @escaping (String, String) -> Void) {
        self.mode = mode
        self.onSelect = onSelect
        _viewModel = State(wrappedValue: JobDetailViewModel(mode: mode))
    }
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    loadingView
                } else {
                    listView
                }
            }
            .navigationTitle(viewModel.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbarContent }
            .alert("Notice", isPresented: $viewModel.showAlert, presenting: viewModel.alertMessage) { _ in
                Button("OK", role: .cancel) {}
            } message: { msg in
                Text(msg)
            }
            // Break time bottom sheet
            .sheet(isPresented: $viewModel.showBreakTimeSheet) {
                BreakTimePickerView(breakTimes: viewModel.breakTimes) { time in
                    onSelect(viewModel.selectedBreakType, time)
                    dismiss()
                }
            }
        }
        .task { await loadDataIfNeeded() }
    }
    
    // MARK: Loading
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text("Loading...")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: List
    private var listView: some View {
        List(viewModel.items) { item in
            SelectionRowView (
                item: item,
                mode: mode,
                isSelected: isSelected(item)
            )
            .contentShape(Rectangle())
            .onTapGesture { handleTap(item) }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        }
        .listStyle(.plain)
    }
    
    // MARK: Toolbar
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") { dismiss() }
        }
        if viewModel.showDoneButton {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") { confirmDaysSelection() }
                    .fontWeight(.semibold)
            }
        }
    }
    
    // MARK: Helpers
    private func isSelected(_ item: SelectionItem) -> Bool {
        if case .days = mode {
            return viewModel.selectedDayIDs.contains(item.id)
        }
        return false
    }
    
    private func handleTap(_ item: SelectionItem) {
        switch mode {
        case .outlet:
            onSelect(item.name, item.id)
            dismiss()
            
        case .jobType:
            onSelect(item.name, item.id)
            dismiss()
            
        case .schedule:
            onSelect(item.id, "")   // id = "Specific Date" / "Weekly" / "Urgent"
            dismiss()
            
        case .numberOfWorkers:
            onSelect(item.name, "")
            dismiss()
            
        case .breakType:
            if item.id == "Not Applicable" {
                onSelect(item.name, "")
                dismiss()
            } else {
                // Show break time dropdown sheet
                viewModel.selectedBreakType = item.name
                viewModel.showBreakTimeSheet = true
            }
            
        case .mealProvision:
            onSelect(item.name, "")
            dismiss()
            
        case .days:
            // Toggle selection
            viewModel.toggleDay(item)
        }
    }
    
    private func confirmDaysSelection() {
        guard !viewModel.selectedDayIDs.isEmpty else {
            viewModel.alertMessage = "Please select the days"
            viewModel.showAlert = true
            return
        }
        
        let result = viewModel.selectedDaysResult
        onSelect(result.days, result.shiftStatus)
        
        dismiss()
    }
    
    private func loadDataIfNeeded() async {
        switch mode {
        case .outlet:
            do {
                viewModel.isLoading = true
                let response = try await viewModel.fetchOutlets()
                await MainActor.run {
                    viewModel.applyOutlets(response)
                    viewModel.isLoading = false
                }
            } catch {
                await MainActor.run {
                    viewModel.errorMessage = error.localizedDescription
                    viewModel.isLoading = false
                }
            }
            
        case .jobType:
            do {
                viewModel.isLoading = true
                let response = try await viewModel.fetchJobTypes()
                await MainActor.run {
                    viewModel.applyJobTypes(response)
                    viewModel.isLoading = false
                }
            } catch {
                await MainActor.run {
                    viewModel.errorMessage = error.localizedDescription
                    viewModel.isLoading = false
                }
            }
            
        default:
            break
        }
    }
}

// MARK: - Row View
 
struct SelectionRowView: View {
 
    let item: SelectionItem
    let mode: PickerMode
    let isSelected: Bool
 
    var body: some View {
        HStack(spacing: 12) {
            // Outlet: show logo placeholder
            if case .outlet = mode {
                Circle()
                    .fill(Color(.systemGray5))
                    .frame(width: 36, height: 36)
                    .overlay (
                        Image(systemName: "building.2")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    )
            }
 
            Text(item.name)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(isSelected ? Color.accentColor : .primary)
 
            Spacer()
 
            // Days: show checkmark
            if case .days = mode {
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color.accentColor)
                        .font(.system(size: 18))
                } else {
                    Image(systemName: "circle")
                        .foregroundColor(Color(.systemGray4))
                        .font(.system(size: 18))
                }
            } else {
                // All other modes: just chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color(.systemGray3))
            }
        }
        .padding(.vertical, 12)
        .background (
            RoundedRectangle(cornerRadius: 0)
                .fill(Color.clear)
        )
        .overlay(alignment: .bottom) {
            Divider().padding(.leading, mode.hasLeadingIcon ? 64 : 0)
        }
    }
}
 
// MARK: - Break Time Picker Sheet
 
struct BreakTimePickerView: View {
    
    let breakTimes: [String]
    var onSelect: (String) -> Void
    @Environment(\.dismiss) private var dismiss
 
    var body: some View {
        NavigationView {
            List(breakTimes, id: \.self) { time in
                Button {
                    onSelect(time)
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.accentColor)
                            .frame(width: 24)
                        Text(time)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundColor(Color(.systemGray4))
                    }
                    .padding(.vertical, 4)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Select Break Duration")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}

// MARK: - PickerMode helpers
 
extension PickerMode {
    var hasLeadingIcon: Bool {
        if case .outlet = self { return true }
        return false
    }
}
//#Preview {
//    SelectJobDetailView(mode: <#PickerMode#>, onSelect: <#(String, String) -> Void#>, viewModel: <#JobDetailViewModel#>)
//}
