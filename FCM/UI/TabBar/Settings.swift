 /* 
 Settings.swift 

 Copyright (C) 2023, 2024 SparkleChan and SeanIsTethered 
 Copyright (C) 2024 fridakitten 

 This file is part of FridaCodeManager. 

 FridaCodeManager is free software: you can redistribute it and/or modify 
 it under the terms of the GNU General Public License as published by 
 the Free Software Foundation, either version 3 of the License, or 
 (at your option) any later version. 

 FridaCodeManager is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of 
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
 GNU General Public License for more details. 

 You should have received a copy of the GNU General Public License 
 along with FridaCodeManager. If not, see <https://www.gnu.org/licenses/>. 
 */ 
    
import SwiftUI

struct Settings: View {
    @Binding var sdk: String
    @Binding var bsl: Bool
    @Binding var fname: String
    @State var fontstate: CGFloat = {
        if let savedFont = UserDefaults.standard.value(forKey: "savedfont") as? CGFloat {
            return savedFont
        } else {
            return 15.0
        }
    }()
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("default sdk")) {
                    NavigationLink(destination: SDKList(directoryPath: "\(global_sdkpath)" ,sdk: $sdk)) {
                        Text(sdk)
                    }
                }
                Section(header: Text("Advanced")) {
                    NavigationLink(destination: textset(bsl: $bsl, fname: $fname,fontstate: $fontstate)) {
                        Label("Code Editor", systemImage: "doc.plaintext.fill")
                        }
                    NavigationLink(destination: DebugSettings()) {
                        Label("Debug", systemImage: "ant.fill")
                    }
                }
                Section(header: Text("Additional Tools")) {
                    NavigationLink(destination: SDKDownload()) {
                        Label("SDK Hub", systemImage: "arrow.down")
                    }
                    NavigationLink(destination: SFSymbolView()) {
                    Label("SFSymbols", systemImage: "square.grid.3x3.fill")
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct DebugSettings: View {
    @AppStorage("debug") var show: Bool = false
    var body: some View {
        List {
            Section() {
                Toggle("Debug Log",isOn: $show)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Debug")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct textset: View {
    @Binding var bsl: Bool
    @Binding var fname: String
    @Binding var fontstate: CGFloat
    var body: some View {
        List {
            Section(header: Text("Font")) {
                FontPickerView(fname: $fname)
                Stepper("Font Size: \(String(Int(fontstate)))", value: $fontstate, in: 0...20)
                .onChange(of: fontstate) { _ in
                    save()
                }
            }
            Section(header: Text("Appearance")) {
                Toggle("Seperation Layer", isOn: $bsl)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Code Editor")
        .navigationBarTitleDisplayMode(.inline)
    }
    func save() {
        UserDefaults.standard.set(fontstate, forKey: "savedfont")
    }
}

struct FontPickerView: View {
    @State private var selectedFontIndex = 0
    @Binding var fname: String
    let codeEditorFonts: [String] = guif()
    var body: some View {
        VStack {
            Picker(selection: $fname, label: Text("Font")) {
                Group {
                    ForEach(codeEditorFonts, id: \.self) { fontName in
                        Text(fontName)
                            .font(.custom(fontName, size: 16))
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
            }
            .labelsHidden()
            .clipped()
        }
    }
}

