//
//  StartView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 26/2/24.
//

import SwiftUI

struct StartView: View {
    @State private var readyToNavigate : Bool = false
    var body: some View {
        NavigationStack {
            ZStack {
                Image("startScreen")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .navigationBarBackButtonHidden(true)
                    .navigationDestination(isPresented: $readyToNavigate) {
                        CanvasView()
                    }
                /*
                Button {
                    readyToNavigate = true
                } label: {
                    Text("Navigate Button")
                }
                */
                    .overlay(
                            Button(action: {
                                readyToNavigate = true
                            }) {
                                ZStack(alignment: .bottom) {
                                    Image("scroll")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 200, height: 200)

                                    Text("Start")
                                        .foregroundColor(.black)
                                        .font(.system(size: 40, weight: .bold))
                                        .padding(.bottom, 50)
                                        .cornerRadius(10)
                                        .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 2)

                                }
                            }
                            .padding(20)
                        )
            }.navigationBarBackButtonHidden(true)
        }.navigationBarBackButtonHidden(true)
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
