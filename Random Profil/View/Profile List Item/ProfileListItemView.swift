//
//  ProfileListItemView.swift
//  Random Profil
//
//  Created by Jaehwa Noh on 2023/03/30.
//

import SwiftUI

struct ProfileListItemView: View {
    var imageURL: String
    
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: imageURL)) { phase in
                
                if let image = phase.image {
                    image
                        .resizable()
                        .frame(width: 75, height: 75)
                        
                } else {
                    Image(systemName: "person")
                        .resizable()
                        .foregroundColor(.gray)
                        .frame(width: 75, height: 75)
                        
                }
            }
            
            
            
            Spacer()
                .frame(width: 20)
            VStack(alignment: .leading) {
                Text("Name")
                    .font(.title)
                Group {
                    Text("Location")
                    Text("E-mail")
                }
                .lineLimit(1)
                .font(.body)
                .foregroundColor(.gray)
            }
            Spacer()
            
        }.padding(.horizontal)
    }
}

struct ProfileListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileListItemView(imageURL: "https://randomuser.me/api/portraits/women/82.jpg")
    }
}