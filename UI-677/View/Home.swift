//
//  Home.swift
//  UI-677
//
//  Created by nyannyan0328 on 2022/09/23.
//

import SwiftUI

struct Home: View {
    @State var dragOffet : CGSize = .zero
    @State var startAnimation : Bool = false
    @State var currentMeta : String = "Single"
    var body: some View {
        VStack{
            
            Text("Meta Ball Animation")
                .font(.largeTitle.weight(.semibold))
                .foregroundColor(.gray.opacity(0.5))
            
            
            Picker(selection: $currentMeta) {
            
                Text("Metal")
                    .tag("Single")
                
                Text("Clubbed")
                    .tag("Double")
            } label: {
                
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            if currentMeta == "Single"{
                
                SingleMetaBall()
            }
            else{
                ClabbedView()
            }
            
            
            
         
        }
    }
    @ViewBuilder
    func ClabbedView ()->some View{
        Rectangle()
            .fill(.linearGradient(colors: [Color("Gradient1"),Color("Gradient2")], startPoint: .top, endPoint: .bottom))
            .mask {
                TimelineView(.animation(minimumInterval:3.5,paused: false)){_ in
                    
                    
                    Canvas { context, size in
                        
                        context.addFilter(.alphaThreshold(min: 0.3,color: .white))
                        context.addFilter(.blur(radius: 20))
                        
                        context.drawLayer { cxt in
                            
                            for index in 1...20{
                              
                                
                                if let resolvedImage = context.resolveSymbol(id: index){
                                    
                                    cxt.draw(resolvedImage, at: CGPoint(x: size.width / 2, y: size.height / 2))
                                }
                              
                            }
                        }
                        
                    } symbols: {
                        
                        ForEach(1...20 ,id:\.self){index in
                            
                            let offset = (startAnimation ? CGSize(width: .random(in: -180...180), height: .random(in: -240...240)):.zero)
                            
                            ClabbedRoundView(offset: offset)
                            
                            
                        }
                        
                    }
                }
           

                
                
            }
            .contentShape(Rectangle())
            .onTapGesture {
                
                startAnimation = true
            }
        
    }
    @ViewBuilder
    func ClabbedRoundView (offset : CGSize)->some View{
        
        RoundedRectangle(cornerRadius: 60, style: .continuous)
            .fill(.white)
         .frame(width: 150,height: 150)
         .offset(offset)
         .animation(.easeIn(duration: 5), value: offset)
        
    }
    @ViewBuilder
    func SingleMetaBall ()->some View{
        
        Rectangle()
            .fill(.linearGradient(colors: [Color("Gradient1"),Color("Gradient2")], startPoint: .top, endPoint: .bottom))
            .mask {
                
                Canvas { context, size in
                    context.addFilter(.alphaThreshold(min: 0.3,color: .white))
                    context.addFilter(.blur(radius: 50))
                    
                    context.drawLayer { cxt in
                        for index in [1,2]{
                            
                            if let reslovedImage = context.resolveSymbol(id: index){
                                
                                cxt.draw(reslovedImage, at: CGPoint(x: size.width / 2, y: size.height / 2))
                                
                            }
                        }
                      
                    }
                    
                    
                } symbols: {
                    
                    BallView()
                        .tag(1)
                    
                    BallView(offset: dragOffet)
                        .tag(2)
                }
             

            }
            .gesture(
            
                DragGesture().onChanged({ value in
                    dragOffet = value.translation
                })
                .onEnded({ value in
                    
                    withAnimation(.interactiveSpring(response: 0.7,dampingFraction: 0.7,blendDuration: 0.1)){
                        dragOffet = .zero
                    }
                })
            
            )
        
       
            
        
    }
    @ViewBuilder
    func BallView(offset : CGSize = .zero)->some View{
        
     
        Circle()
            .fill(.white)
         .frame(width: 200,height: 200)
         .offset(offset)
    
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
