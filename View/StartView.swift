//
//  StartView.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 26/2/24.
//

import SwiftUI

struct StartView: View {
    @State private var readyToNavigate : Bool = false
    @State private var isButtonClicked = false
    @State private var isSecondaryButtonClicked = false

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
                    .overlay(
                        Button(action: {
                                //readyToNavigate = true
                            }) {
                                ZStack(alignment: .bottom) {
                                    Image("scroll")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 200, height: 200)

                                    Button(action: {
                                        readyToNavigate = true
                                    }) {
                                        Text("Start")
                                            .foregroundColor(.black)
                                            .font(.system(size: 30, weight: .bold))
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 10)

                                            .background(
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .fill(Color(red: 241/255, green: 195/255, blue: 102/255))
                                                            .overlay(
                                                                RoundedRectangle(cornerRadius: 10)
                                                                    .stroke(Color.black, lineWidth: 1)
                                                            )
                                                    )
                                            .cornerRadius(10)
                                    }
                                    .padding(.bottom, 30)
                                    .shadow(color: Color.black.opacity(0.6), radius: 5, x: 0, y: 3)
                                    /*
                                    Text("Start")
                                        .foregroundColor(.black)
                                        .font(.system(size: 35, weight: .bold))
                                        .padding(.bottom, 50)
                                    */
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
