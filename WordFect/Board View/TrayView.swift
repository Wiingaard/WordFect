//
//  TrayView.swift
//  WordFect
//
//  Created by Martin Wiingaard on 11/04/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import SwiftUI

struct TrayView: View {
    
    @ObservedObject var tray: Tray

    var body: some View {
        VStack {
            LineView(fields: tray.fields, onTap: tray.didTap).frame(height: 60)
        }
    }
}

struct TrayView_Previews: PreviewProvider {
    static var previews: some View {
        TrayView(tray: Tray())
    }
}
