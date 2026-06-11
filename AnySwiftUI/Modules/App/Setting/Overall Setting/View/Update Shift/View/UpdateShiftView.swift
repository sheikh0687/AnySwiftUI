//
//  UpdateShiftView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 26/05/26.
//

import SwiftUI

struct UpdateShiftView: View {
    
    @EnvironmentObject var appState: AppState
    @State var viewModel: UpdateShiftViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // MARK: Outlet
                    if appState.hasOutlets {
                        UpdateFormRow (
                            title: "Select Outlet",
                            value: viewModel.selectedOutletName.isEmpty ? "Choose Outlet" : viewModel.selectedOutletName
                        ) {
                            viewModel.showOutletPicker = true
                        }
                    }

                    // MARK: Job Type
                    UpdateFormRow (
                        title: "Job Type",
                        value: viewModel.jobTypeName.isEmpty ? "Choose Job Type" : viewModel.jobTypeName
                    ) {
                        viewModel.showJobTypePicker = true
                    }

                    // MARK: Number of Workers
                    UpdateFormRow (
                        title: "Number of Workers",
                        value: "\(viewModel.workerCount)"
                    ) {
                        viewModel.showWorkerCountPicker = true
                    }

                    // MARK: Schedule Type
                    UpdateFormRow (
                        title: "Schedule Type",
                        value: viewModel.scheduleLabel
                    ) {
                        viewModel.showSchedulePicker = true
                    }
     
                    // MARK: Days / Dates
                    if viewModel.scheduleType != nil {
                        VStack(alignment: .leading, spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                UpdateFormRow (
                                    title: "Days",
                                    value: viewModel.dayLabel,
                                    isDisabled: viewModel.scheduleType == .urgent
                                ) {
                                    if viewModel.scheduleType == .weekly {
                                        viewModel.showDaysPicker = true
                                    } else if viewModel.scheduleType == .specificDate {
                                        viewModel.showDatePicker = true
                                    }
                                }
                                if viewModel.scheduleType == .urgent {
                                    IBLabel (
                                        text: "Note: The date for urgent bookings is fixed to today and cannot be modified.",
                                        font: .semibold(.description),
                                        color: .red
                                    )
                                }
                            }
                            
                            // Selected date chips (Specific Date mode)
                            if viewModel.scheduleType == .specificDate && !viewModel.selectedDates.isEmpty {
                                 UpdateDateChipsView(dates: viewModel.selectedDates) { index in
                                    viewModel.removeDate(at: index)
                                }
                            }
                        }
                    }

                    // MARK: Shift Section
                    VStack(alignment: .leading, spacing: 16) {
     
                        IBLabel(text: "Shift", font: .semibold(.title), color: .primary)
     
                        // Apply same time to all workers toggle (only if > 1 worker)
                        if viewModel.workerCount > 1 {
                            ApplyAllWorkersToggle (
                                isOn: $viewModel.applyTimeToAllWorkers,
                                globalStart: $viewModel.globalStartTime,
                                globalEnd: $viewModel.globalEndTime
                            ) {
                                if viewModel.applyTimeToAllWorkers {
                                    viewModel.applyGlobalTimeToAll()
                                }
                            }
                        }
     
                        // Per-worker or single shift pickers
                        if viewModel.applyTimeToAllWorkers {
                            // Single row for all workers
                            UpdateSingleShiftRow (
                                label: "All Workers",
                                startTime: $viewModel.globalStartTime,
                                endTime: $viewModel.globalEndTime
                            )
                            .onChange(of: viewModel.globalStartTime) { viewModel.applyGlobalTimeToAll() }
                            .onChange(of: viewModel.globalEndTime) { viewModel.applyGlobalTimeToAll() }
                        } else {
                            ForEach($viewModel.workerShifts) { $shift in
                                let idx = (viewModel.workerShifts.firstIndex(where: { $0.id == shift.id }) ?? 0) + 1
                                UpdateSingleShiftRow (
                                    label: "Worker #\(idx)",
                                    startTime: $shift.startTime,
                                    endTime: $shift.endTime
                                )
                            }
                        }
     
                        Divider()
                    }
                    
                    // MARK: Rate
                    UpdateFormRow (
                        title: "Rate",
                        value: viewModel.defaultRateLabel
                    ) {
                        viewModel.showRatePicker = true
                    }
     
                    // MARK: Breaks
                    UpdateFormRow (
                        title: "Breaks",
                        value: viewModel.breakType.isEmpty ? "Select" : viewModel.breakType
                    ) {
                        viewModel.showBreakPicker = true
                    }
     
                    // MARK: Meals
                    UpdateFormRow (
                        title: "Meals",
                        value: viewModel.meal.isEmpty ? "Select" : viewModel.meal
                    ) {
                        viewModel.showMealPicker = true
                    }
     
                    // MARK: Notes for Workers
                    VStack(alignment: .leading, spacing: 10) {
                        
                        IBLabel (
                            text: viewModel.showNoteForWorker ? "Notes for Workers (Urgent)" : "Notes for Workers",
                            font: .semibold(.title),
                            color: .primary
                        )
     
                        TextEditor(text: $viewModel.notes)
                            .frame(height: 150)
                            .padding(12)
                            .background(Color(.systemGray5))
                            .cornerRadius(12)
                    }

                    IBSubmitButton(buttonText: "Update Shift") {
                        Task {
                            await viewModel.updateShift()
                        }
                    }
                }
                .padding(.all, 24)
            }
            
            if viewModel.isLoading {
                ZStack {
                    Color.black.opacity(0.2).ignoresSafeArea()
                    ProgressView()
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                }
            }
        }
        .navigationTitle("Update Shift")
        .navigationBarTitleDisplayMode(.inline)
        
        .task {
            await viewModel.fetchShiftDetails()
        }
        
        .sheet(isPresented: $viewModel.showOutletPicker) {
            SelectJobDetailView(mode: .outlet) { name, id in
                viewModel.selectedOutletName = name
                viewModel.selectedOutletID = id
            }
        }
        
        // Job Type picker
        .sheet(isPresented: $viewModel.showJobTypePicker) {
            SelectJobDetailView(mode: .jobType) { name, id in
                viewModel.jobTypeName = name
                viewModel.jobTypeID = id
            }
        }
        
        // Worker count picker
        .sheet(isPresented: $viewModel.showWorkerCountPicker) {
            SelectJobDetailView(mode: .numberOfWorkers) { count, _ in
                viewModel.workerCount = Int(count) ?? 1
            }
        }
        
        // Schedule picker
        .sheet(isPresented: $viewModel.showSchedulePicker) {
            SelectJobDetailView(mode: .schedule) { rawValue, _ in
                viewModel.scheduleType = ScheduleType(rawValue: rawValue)
            }
        }
        
        // Days picker
        .sheet(isPresented: $viewModel.showDaysPicker) {
            SelectJobDetailView(mode: .days(existing: viewModel.selectedDaysName.components(separatedBy: ","))) { days, status in
                viewModel.selectedDaysName = days
                viewModel.shiftStatus = status
            }
        }
        
        // Break picker
        .sheet(isPresented: $viewModel.showBreakPicker) {
            SelectJobDetailView(mode: .breakType) { name, time in
                viewModel.breakType = name
                viewModel.breakTime = time
            }
        }
        
        // Meal picker
        .sheet(isPresented: $viewModel.showMealPicker) {
            SelectJobDetailView(mode: .mealProvision) { name, _ in
                viewModel.meal = name
            }
        }
        
        .sheet(isPresented: $viewModel.showDatePicker) {
            UpdateCalendarPickerView { dateStr, dayName in
                viewModel.selectedDates.append(dateStr)
                viewModel.selectedDayNames.append(dayName)
            }
        }
        
        .alert(appName, isPresented: $viewModel.showAlert, presenting: viewModel.alertMessage) { _ in
            Button("OK", role: .cancel) {
                if viewModel.navigateBack {
                    dismiss()
                }
            }
        } message: { msg in
            Text(msg)
        }
    }
}

#Preview {
    UpdateShiftView(viewModel: .init(shiftiD: "1", selectedOutletName: "TechImmense"))
        .environmentObject(AppState.shared)
}

/// FormRow — tappable row with title + value + chevron
struct UpdateFormRow: View {
    
    var title: String
    var value: String
    var isDisabled: Bool = false
    var action: (() -> Void)? = nil
 
    var body: some View {
        Button {
            action?()
        } label: {
            VStack(spacing: 14) {
                HStack {
                    
                    Text(title)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.primary)
 
                    Spacer()
 
                    HStack(spacing: 6) {
                        Text(value)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(isDisabled ? .secondary : .THEME)
 
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(isDisabled ? .secondary : .THEME)
                    }
                }
                Divider()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
    }
}

/// A single shift row with start/end DatePicker
struct UpdateSingleShiftRow: View {
    let label: String
    @Binding var startTime: Date
    @Binding var endTime: Date
 
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.secondary)
 
            HStack(spacing: 12) {
                DatePicker("Start", selection: $startTime, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .frame(maxWidth: .infinity)
                    .padding(.all, 6)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
 
                DatePicker("End", selection: $endTime, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .frame(maxWidth: .infinity)
                    .padding(.all, 6)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
            }
        }
    }
}

/// Toggle row: "Apply same time to all workers"
struct UpdateApplyAllWorkersToggle: View {
    @Binding var isOn: Bool
    @Binding var globalStart: Date
    @Binding var globalEnd: Date
    var onChange: () -> Void
 
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Toggle(isOn: $isOn) {
                Text("Apply same time to all workers")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primary)
            }
            .tint(Color.accentColor)
            .onChange(of: isOn) { onChange() }
 
            Divider()
        }
    }
}

/// Horizontal chips for selected dates with remove button
struct UpdateDateChipsView: View {
    let dates: [String]
    var onRemove: (Int) -> Void
 
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
 
    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(dates.indices, id: \.self) { i in
                HStack(spacing: 6) {
                    Text(dates[i])
                        .font(.system(size: 13, weight: .medium))
                        .lineLimit(1)
 
                    Spacer()
 
                    Button {
                        onRemove(i)
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
        }
    }
}

struct UpdateCalendarPickerView: View {
    
    var onSelect: (String, String) -> Void
    @Environment(\.dismiss) var dismiss
    @State private var selectedDate = Date()
 
    var body: some View {
        NavigationView {
            VStack {
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .padding()
                Spacer()
            }
            .navigationTitle("Select Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let df = DateFormatter()
                        df.dateFormat = "yyyy-MM-dd"
                        let dayFmt = DateFormatter()
                        dayFmt.dateFormat = "EEEE"
                        onSelect(df.string(from: selectedDate), dayFmt.string(from: selectedDate))
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

