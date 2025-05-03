
import SwiftUI

struct InfiniteScrollView: View {
    @StateObject private var viewModel = InfiniteScrollViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.items, id: \.self) { item in
                    Text("Item \(item)")
                        .padding()
                        .onAppear {
                            viewModel.loadMoreItemsIfNeeded(currentItem: item)
                        }
                }

                if viewModel.isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
            }
            .navigationTitle("Infinite Scroll")
            // Optional pull-to-refresh on iOS 15+
            .refreshable {
                viewModel.refreshData()
            }
        }
    }
}
