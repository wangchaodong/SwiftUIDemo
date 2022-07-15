//
//  ContentView.swift
//  Demo2
//
//  Created by s1mple wang on 2022/7/6.
//

import SwiftUI

struct ContentView: View {
    var body: some View {

        ScrollView {
            VStack {
                Text("Images")
                    .font(.largeTitle)
                Text("Using SF Symbols")                .foregroundColor(.gray)
                Text("You will see I use icons or symbols to add clarity to what I'm demonstrating.                 These come from Apple's new symbol font library which you can browse using an                 app called 'SF Symbols'.")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(Color.white)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color.blue)
                    )
                    .padding()
                // Use "systemName" when you want to use "SF Symbols"
                Image(systemName: "hand.thumbsup.fill")                .font(.largeTitle)
                // Make the symbol larger
    //            Image("SF Symbols")
                Image("haru")
                    .resizable()
    //                .scaledToFit()
                    .frame(width: 190, height: 190)
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(1)

                    .overlay {
                        Text("HARU")
                            .foregroundColor(.purple)
                            .font(.title)
                            .fontWeight(.bold)
                    }

                VStack {
                    TimelineView(.periodic(from: Date.now, by: 1.0)) {
                        context in
                        Text(context.date.description).font(.title)
                    }
                    Canvas { context, size in
                        context.stroke(Path(ellipseIn: CGRect(origin: .zero, size: size)),with: .color(.blue), lineWidth: 3)
                    }.frame(width: 100, height: 50, alignment: .center).border(.red,width: 2)

                    TextEditor(text: .constant("Placeholder"))
                    .frame(width: 100, height: 30, alignment: .center)
                    ProgressView(value: 30, total: 10, label: {
                        Text("WY")
                    }, currentValueLabel: {
                        Text("start")
                    })
                    .progressViewStyle(.circular)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
