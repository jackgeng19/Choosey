//
//  RowView.swift
//  Choosey
//
//  Created by Qicheng Geng on 10/4/23.
//

import SwiftUI

struct RowView: View {
    let business: Business
    
    var body: some View {
        HStack{
            VStack{
                HStack(alignment: .firstTextBaseline){
                    Text(business.name)
                        .lineLimit(1)
                        .padding(.leading, 3)
                        .font(.callout)
                    Spacer()
                    Text(String(format: "%.0f", business.distance) + " m")
                        .foregroundColor(.secondary)
                        .padding(.trailing, 3)
                        .font(.caption)
                }
                HStack(alignment: .firstTextBaseline){
                    Group{
                        rating
                    }
                    Spacer()
                    Text(business.price)
                        .foregroundStyle(.secondary)
                        .font(.caption)
                        .padding(.trailing, 3)
                }
            }
            .padding([.top, .bottom], 3)
        }
    }
    
    var rating: some View {
        HStack{
            Image(systemName: "star.fill")
                .font(.caption2)
                .foregroundStyle(Color.yellow)
                .padding(.leading, 3)

            Text(String(format: "%.1f", business.rating))
                .font(.caption)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .foregroundStyle(Color.yellow)
                .padding(.leading, -5)
            Text("(" + String(business.reviewCount) + ")")
                .foregroundStyle(.secondary)
                .font(.caption)
            Text(business.location.displayAddress)
                .foregroundStyle(.secondary)
                .font(.caption)
        }
    }
}



#Preview {
    RowView(business: Business.example)
}
