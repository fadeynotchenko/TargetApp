//
//  ContentView.swift
//  Target
//
//  Created by Fadey Notchenko on 29.01.2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Target.dateStart, ascending: true)], animation: .default)
    private var targets: FetchedResults<Target>
    
    @State private var isNewTargetViewShow = false

    var body: some View {
        NavigationView {
            List {
                //archive button
                NavigationLink {
                    
                } label: {
                    ArchiveButtonLabel
                }
                .isDetailLink(false)
                
                ForEach(targets) { target in
                    NavigationLink {
                        Text(target.name)
                    } label: {
                        TargetRow(target)
                    }
                    .swipeActions {
                        DeleteSwipeActionButton(target)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle(Text("Test"))
            .sheet(isPresented: $isNewTargetViewShow) {
                NewTargetView(isEditMode: false, isNewTargetViewShow: $isNewTargetViewShow)
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        self.isNewTargetViewShow.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            
            Text("placholder")
        }
    }
    
    private var ArchiveButtonLabel: some View {
        HStack(spacing: 10) {
            RectangleIcon(systemName: "archivebox.fill", color: .blue)
                .frame(width: 40, height: 40)
            
            Text("archive")
                .bold()
                .font(.title3)
        }
        .padding(.vertical)
    }
    
    private func TargetRow(_ target: Target) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(target.name)
                .bold()
                .font(.title3)
                .lineLimit(1)
            
            CapsuleProgress(target: target)
            
            Text("\(target.currentMoney) / \(target.price)")
                .bold()
                .lineLimit(1)
            
        }
        .padding(.vertical)
    }
    
    private func DeleteSwipeActionButton(_ target: Target) -> some View {
        Button(role: .destructive) {
            withAnimation {
                viewContext.delete(target)
                
                PersistenceController.save(context: viewContext)
            }
        } label: {
            Image(systemName: "trash")
        }
    }
}

struct CapsuleProgress: View {
    @ObservedObject var target: Target
    
    //with animation
    @State private var percent: CGFloat = 0
    //without animation
    @State private var percentInt: Int = 0
    
    var body: some View {
        ZStack(alignment: .leading) {
            
            ZStack(alignment: .trailing) {
                HStack {
                    Capsule()
                        .fill(.gray.opacity(0.2))
                        .frame(width: 180, height: 12)
                    
                    Text("\(Int(percentInt)) %")
                        .bold()
                }
            }
            
            Capsule()
                .fill(Color(UIColor.color(withData: target.color)))
                .frame(width: percent / 100 * 180, height: 12)
        }
        .onAppear {
            calculatePercent(price: target.price, current: target.currentMoney)
        }
        .onChange(of: target.currentMoney) { new in
            calculatePercent(price: target.price, current: new)
        }
        .onChange(of: target.price) { new in
            calculatePercent(price: new, current: target.currentMoney)
        }
    }
    
    private func calculatePercent(price: Int64, current: Int64) {
        guard price != 0 else { return }
        
        percentInt = Int(min(current * 100 / price, 100))
        
        withAnimation(.easeInOut(duration: 2.0)) {
            percent = min(CGFloat(current * 100 / price), 100.0)
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
#endif
