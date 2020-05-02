//
//  PlayingFieldView.swift
//  WordFect
//
//  Created by Martin Wiingaard on 12/04/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import SwiftUI

struct PlayingFieldView: View {
    
    @ObservedObject var playingField = PlayingField()
    
    var body: some View {
        VStack {
            GridView(fields: self.playingField.fields) { self.playingField.didTapField($0) }
            Spacer()
        }
    }
}

struct PlayingFieldView_Previews: PreviewProvider {
    static var previews: some View {
        PlayingFieldView()
    }
}
