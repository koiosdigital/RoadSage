// ConnectedView.swift
//  TesKey
//
//  Created by aiden on 11/17/23.
//  
//

import SwiftUI

struct ControllableView: View {
    //@EnvironmentObject public var vehicle: Vehicle
    
    var body: some View {
        
        VStack{
            Text("Now Controllable")
                .padding()
            Button("Lock Vehicle") {
                //CommandManager(vehicle: vehicle).sendCommand(action: .rkeActionLock)
            }
            .padding()
            
            Button("Unlock Vehicle") {
                //CommandManager(vehicle: vehicle).sendCommand(action: .rkeActionUnlock)
            }
            .padding()
            
            Button("Open Trunk") {
                //CommandManager(vehicle: vehicle).sendCommand(action: .rkeActionOpenTrunk)
            }
            .padding()
        }
    }
}

struct ConnectedView: View {
    //@EnvironmentObject public var vehicle: Vehicle
    @EnvironmentObject public var bm: BluetoothManager
    
    var body: some View {
        ControllableView()
        //    .environmentObject(vehicle)
    }
}

#if DEBUG
struct ConnectedView_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            ControllableView()
        }
    }

}
#endif
