//
//  GDGenshinDictionaryView.swift
//  GenshinPizzaHelper
//
//  Created by Bill Haku on 2022/10/3.
//

import SwiftUI

@available (iOS 15, *)
struct GenshinDictionary: View {
    @State var dictionaryData: [GDDictionary]?
    @State private var searchText: String = ""
    @State private var showSafari: Bool = false
    @State private var showInfoSheet: Bool = false
    var searchResults: [GDDictionary]? {
            if searchText.isEmpty || dictionaryData == nil {
                return dictionaryData?.sorted {
                    $0.id < $1.id
                }
            } else {
                return dictionaryData!.filter {
                    $0.en.localizedCaseInsensitiveContains(searchText) ||
                    ($0.zhCN != nil && $0.zhCN!.contains(searchText)) ||
                    ($0.ja != nil && $0.ja!.contains(searchText)) ||
                    ($0.variants != nil && (($0.variants!.en != nil && $0.variants!.en!.contains(where: {$0.caseInsensitiveCompare(searchText) == .orderedSame})) ||
                                             ($0.variants!.zhCN != nil && $0.variants!.zhCN!.contains(searchText)) ||
                                             ($0.variants!.ja != nil && $0.variants!.ja!.contains(searchText)))) ||
                    ($0.tags != nil && $0.tags!.contains(where: {$0.caseInsensitiveCompare(searchText) == .orderedSame}))
                }
                .sorted {
                    $0.id < $1.id
                }
            }
        }

    let alphabet = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]

    var body: some View {
        if let searchResults = searchResults, let dictionaryData = dictionaryData {
            ScrollViewReader { value in
                List {
                    ForEach(alphabet, id: \.self) { letter in
                        if searchResults.filter { $0.id.hasPrefix(letter.lowercased()) }.count > 0 {
                            Section(header: Text(letter)) {
                                ForEach(searchResults.filter { $0.id.hasPrefix(letter.lowercased()) }, id: \.id) { item in
                                    dictionaryItemCell(word: item)
                                        .id(item.id)
                                        .contextMenu {
                                            Button("????????????") {
                                                UIPasteboard.general.string = item.en
                                            }
                                            if let zhcn = item.zhCN {
                                                Button("????????????") {
                                                    UIPasteboard.general.string = zhcn
                                                }
                                            }
                                            if let ja = item.ja {
                                                Button("????????????") {
                                                    UIPasteboard.general.string = ja
                                                }
                                            }
                                        }
                                }
                            }.id(letter)
                        }
                    }
                }
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "???????????????????????????????????????")
                .overlay(alignment: .trailing) {
                    if searchText.isEmpty {
                        VStack(spacing: 5) {
                            ForEach(0 ..< alphabet.count, id: \.self) { idx in
                                Button(action: {
                                    withAnimation {
                                        value.scrollTo(alphabet[idx], anchor: .top)
                                    }
                                }, label: {
                                    Text(alphabet[idx])
                                        .font(.footnote)
                                })
                            }
                        }
                    }
                }
            }
            .navigationTitle("?????????????????????")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        showInfoSheet.toggle()
                    }) {
                        Image(systemName: "info.circle")
                    }
                    Button(action: {
                        showSafari.toggle()
                    }) {
                        Image(systemName: "safari")
                    }
                }
            }
            .fullScreenCover(isPresented: $showSafari, content: {
                SFSafariViewWrapper(url: URL(string: "https://genshin-dictionary.com/")!)
                    .ignoresSafeArea()
            })
            .sheet(isPresented: $showInfoSheet) {
                NavigationView {
                    VStack(alignment: .leading) {
                        Text("????????????[?????????????????????](https://genshin-dictionary.com/)?????????")
                        Text("??????????????????\(dictionaryData.count)???????????????????????????????????????????????????")
                        Text("???????????????????????????????????????????????????&??????????????????Twitter????????????[?????????](https://twitter.com/xicri_gi?s=21&t=p-r6hSgh_TXt7iddPNZM1w)?????????&?????????????????????????????????[Bill Haku](mailto:i@hakubill.tech)???")
                        Spacer()
                    }
                    .padding(.horizontal)
                    .multilineTextAlignment(.leading)
                    .navigationBarTitle("???????????????????????????")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                showInfoSheet.toggle()
                            }) {
                                Text("??????")
                            }
                        }
                    }
                }
            }
        } else {
            ProgressView().navigationTitle("?????????????????????")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showSafari.toggle()
                        }) {
                            Image(systemName: "safari")
                        }
                    }
                }
                .fullScreenCover(isPresented: $showSafari, content: {
                    SFSafariViewWrapper(url: URL(string: "https://genshin-dictionary.com/")!)
                        .ignoresSafeArea()
                })
                .onAppear {
                    DispatchQueue.global().async {
                        API.OpenAPIs.fetchGenshinDictionaryData() { result in
                            self.dictionaryData = result
                        }
                    }
                }
        }
    }

    @ViewBuilder
    func dictionaryItemCell(word: GDDictionary) -> some View {
        VStack(alignment: .leading) {
            Text("**??????** \(word.en)")
            if let zhcn = word.zhCN {
                Text("**??????** \(zhcn)")
            }
            if let ja = word.ja {
                if let jaPron = word.pronunciationJa {
                    Text("**??????** \(ja)") + Text(" (\(jaPron))").font(.footnote)
                } else {
                    Text("**??????** \(ja)")
                }
            }
            if let tags = word.tags {
                ScrollView(.horizontal) {
                    HStack(spacing: 3) {
                        ForEach(tags, id:\.self) { tag in
                            Text(tag)
                                .font(.footnote)
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .background(
                                    Capsule()
                                        .fill(.blue)
                                        .frame(height: 15)
                                        .frame(maxWidth: 100)
                                )
                        }
                    }
                }
                .padding(.top, -5)
            }
        }
    }
}
