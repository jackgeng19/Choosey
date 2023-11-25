//
//  RequestLocationView.swift
//  Choosey
//
//  Created by Qicheng Geng on 9/27/23.
//

import SwiftUI

struct RequestLocationView: View {
    @ObservedObject var locationManager: LocationManager
    var body: some View {
        ZStack{
            VStack(alignment: .center, spacing: 8) {
                Image(systemName: "location.circle.fill")
                    .font(.system(size: 50))
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color(red: 0.04, green: 0.52, blue: 1))
                    .padding(.vertical, 1)
                // Body/Regular
                Text("We will use your location to display restaurants near you.")
                    .font(Font.custom("SF Pro Text", size: 19))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .top)
                // Body/Regular
                Button {
                    locationManager.requestLocationAccess()
                } label: {
                    Text("Allow Access")
                      .font(Font.custom("SF Pro Text", size: 17))
                      .foregroundColor(Color.blue)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 0)
            .frame(width: 393, alignment: .top)
        }
        .frame(width: 393, height: 852)
        .background(.primary)
    }
}

struct RequestLocationView_Previews: PreviewProvider {
    static var previews: some View {
        let locationManager = LocationManager()
        RequestLocationView(locationManager: locationManager)
    }
}
