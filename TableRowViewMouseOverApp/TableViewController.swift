//
// TableViewController.swift
//

import Cocoa

// NSStackViewにはtagがないので、このクラスで定義
class StackView: NSStackView {
	static let Tag: Int = 100
	
	static let TitleTextFieldIndex: Int = 0
	static let DeleteButtonViewIndex: Int = 1
	
	override var tag: Int {
		get { return StackView.Tag }
		set {}
	}
}

class Location {
	var location: String
	
	init(location: String) {
		self.location = location
	}
}

class TrackingTableRowView: NSTableRowView {
	var mouseOver: Bool = false
	var trackingArea: NSTrackingArea! = nil
	
	override func updateTrackingAreas() {
		
		if self.trackingArea == nil {
			let options: NSTrackingArea.Options = [.inVisibleRect, .mouseEnteredAndExited, .activeInKeyWindow]
			
			self.trackingArea = NSTrackingArea(rect: NSZeroRect, options: options, owner: self, userInfo: nil)
			self.addTrackingArea(self.trackingArea)
		}
		
		super.updateTrackingAreas()
	}
	
	override func mouseEntered(with event: NSEvent) {
		guard let tableView = self.superview as? NSTableView else {
			return
		}
		
		if #available(macOS 14.2, *) {
			let visibleRowsRange: NSRange = tableView.rows(in: tableView.visibleRect)
			
			// マウスを高速に動かすと削除ボタンが残ったままになる現象を緩和するために、一旦非表示にしてreload
			for visibleRow: Int in visibleRowsRange.location..<visibleRowsRange.location + visibleRowsRange.length {
				if let tableRowView: TrackingTableRowView = tableView.rowView(atRow: visibleRow, makeIfNecessary: false) as? TrackingTableRowView {
					tableRowView.mouseOver = false
					tableView.reloadData(forRowIndexes: IndexSet(integer: visibleRow), columnIndexes: IndexSet(integer: 0))
				}
			}
		}
		
		self.mouseOver = true
		
		let row: Int = tableView.row(for: self)
		
		if row != -1 {
			tableView.reloadData(forRowIndexes: IndexSet(integer: row), columnIndexes: IndexSet(integer: 0))
		}
	}
	
	override func mouseExited(with event: NSEvent) {
		guard let tableView = self.superview as? NSTableView else {
			return
		}
		
		self.mouseOver = false
		
		let row: Int = tableView.row(for: self)
		
		if row != -1 {
			tableView.reloadData(forRowIndexes: IndexSet(integer: row), columnIndexes: IndexSet(integer: 0))
		}
	}
	
}

class TableViewController: NSViewController {
	
	var list: [Location] = [
		Location(location: "東京"),
		Location(location: "New York"),
		Location(location: "Hawaii"),
		Location(location: "Ayers Rock"),
		Location(location: "富士山"),
		Location(location: "Cape Hope"),
		Location(location: "鎌倉"),
		Location(location: "Egypt"),
		Location(location: "Everest"),
		Location(location: "Alps"),
		Location(location: "Machu Picchu"),
		Location(location: "Nile"),
		Location(location: "Niagara"),
		Location(location: "Hong Kong"),
		Location(location: "Istanbul"),
		Location(location: "Jakarta"),
		Location(location: "Los Angeles"),
		Location(location: "Venice"),
		Location(location: "Shanghai"),
		Location(location: "Singapore"),
		Location(location: "Seoul"),
		Location(location: "Singapore"),
		Location(location: "Central Park"),
		Location(location: "Eiffel Tower"),
		Location(location: "Stonehenge"),
		Location(location: "Times Square"),
		Location(location: "Grand Canyon"),
		Location(location: "Hollywood"),
	]
	
	@IBOutlet var tableView: NSTableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override var representedObject: Any? {
		didSet {
		}
	}
	
	@IBAction func deleteButtonAction(_ sender: NSButton) {
		let row: Int = self.tableView.row(for: sender)
		
		print(row)
	}

}


extension TableViewController: NSTableViewDataSource {
	
	func numberOfRows(in tableView: NSTableView) -> Int {
		return self.list.count
	}
	
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		let tableRowView: TrackingTableRowView = tableView.rowView(atRow: row, makeIfNecessary: false) as! TrackingTableRowView
		let tableCellView: NSTableCellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TableCellView"), owner: nil) as! NSTableCellView
		let stackView: NSStackView = tableCellView.viewWithTag(StackView.Tag) as! NSStackView
		let titleTextField: NSTextField = stackView.views[StackView.TitleTextFieldIndex] as! NSTextField
		
		titleTextField.stringValue = self.list[row].location
		
		if tableRowView.mouseOver {
			stackView.views[StackView.DeleteButtonViewIndex].isHidden = false
		} else {
			stackView.views[StackView.DeleteButtonViewIndex].isHidden = true
		}
		
		return tableCellView
	}
}

extension TableViewController: NSTableViewDelegate {
	
	func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
		let identifier: NSUserInterfaceItemIdentifier = NSUserInterfaceItemIdentifier("TableRowView")
		
		var tableRowView: TrackingTableRowView? = tableView.makeView(withIdentifier: identifier, owner: self) as? TrackingTableRowView
		
		if tableRowView == nil {
			tableRowView = TrackingTableRowView(frame: NSZeroRect)
			tableRowView?.identifier = identifier
		}
		
		tableRowView!.mouseOver = false
		
		return tableRowView
	}
	
}
