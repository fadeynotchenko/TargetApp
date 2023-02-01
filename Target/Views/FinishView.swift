//
//  FinishView.swift
//  Target
//
//  Created by Fadey Notchenko on 01.02.2023.
//

import SwiftUI
import CoreData

struct FinishView: View {
    
    @ObservedObject var target: TargetEntity
    @Binding var isFinishViewShow: Bool
    @Binding var navSelection: UUID?
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Поздравляем!")
                .bold()
                .font(.title)
            
            Text("Вы накопили на свою цель!")
                .bold()
                .font(.title2)
            
            Text("'\(target.unwrappedName)'")
                .bold()
                .font(.title)
            
            Spacer()
            
            Button {
                self.target.dateFinish = Date()
                
                PersistenceController.save(context: viewContext)
                
                self.isFinishViewShow.toggle()
                self.navSelection = nil
            } label: {
                Text("Сохранить")
                    .bold()
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .cornerRadius(15)
                    .shadow(color: .accentColor, radius: 10)
            }
            
            Text("После нажатия на кнопку Ваша цель попадет в архив")
                .foregroundColor(.gray)
                .frame(width: 330)
                .multilineTextAlignment(.center)
                .padding(.bottom)
        }
    }
}

#if DEBUG
struct FinishView_Previews: PreviewProvider {
    static var previews: some View {
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "TargetEntity")
        let target = try! PersistenceController.preview.container.viewContext.fetch(req).first as! TargetEntity
        
        FinishView(target: target, isFinishViewShow: .constant(false), navSelection: .constant(nil))
    }
}
#endif
