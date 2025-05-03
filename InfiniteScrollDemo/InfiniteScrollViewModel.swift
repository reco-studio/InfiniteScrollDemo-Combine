import Foundation
import Combine

// 1️⃣ Make it an ObservableObject so SwiftUI can watch @Published props
class InfiniteScrollViewModel: ObservableObject {
    // 2️⃣ These drive your UI
    @Published var items: [Int] = []
    @Published var isLoading: Bool = false

    // 3️⃣ Paging state
    private var page: Int = 0
    private let pageSize: Int = 20

    // 4️⃣ Proper initializer syntax—call first load here
    init() {
        loadMoreItems()
    }

    // 5️⃣ Called from each row's .onAppear
    func loadMoreItemsIfNeeded(currentItem item: Int?) {
        guard let item = item else { return }
        // 6️⃣ Compare to the array's last element, not `item.last`
        if items.last == item {
            loadMoreItems()
        }
    }

    // 7️⃣ Core loading logic
    private func loadMoreItems() {
        guard !isLoading else { return }    // 8️⃣ Prevent overlapping calls
        isLoading = true

        // 9️⃣ Simulate network delay (replace with real API fetch)
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            let start = self.page * self.pageSize
            let newItems = (start..<start + self.pageSize).map { $0 }

            DispatchQueue.main.async {
                self.items.append(contentsOf: newItems)  // 1️⃣0️⃣ Update array
                self.page += 1                            // 1️⃣1️⃣ Advance page
                self.isLoading = false                    // 1️⃣2️⃣ Clear loading flag
            }
        }
    }

    // 1️⃣3️⃣ Optional pull-to-refresh support
    func refreshData() {
        page = 0
        items.removeAll()
        loadMoreItems()
    }
}
