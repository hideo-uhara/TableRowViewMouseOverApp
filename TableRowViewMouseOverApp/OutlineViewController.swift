//
// OutlineViewController.swift
//

import Cocoa

class OutlineViewController: NSViewController {
	static let LocationsGroup: String = "Locations"
	static let FavoritesGroup: String = "Favorites"
	
	let group: [String] = [
		OutlineViewController.LocationsGroup,
		OutlineViewController.FavoritesGroup,
	]
	
	
	var groupItems: [String: [Location]] = [
		OutlineViewController.LocationsGroup: [
			Location(location: "東京"),
			Location(location: "New York"),
			Location(location: "Hawaii"),
			Location(location: "Ayers Rock"),
		],
		
		OutlineViewController.FavoritesGroup: [
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
	]
	
	@IBOutlet var outlineView: NSOutlineView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if #available(macOS 11.0, *) {
			self.outlineView.style = .plain
		}
		
		for item in self.group {
			self.outlineView.expandItem(item, expandChildren: true)
		}
	}
	
	override var representedObject: Any? {
		didSet {
		}
	}
	
	@IBAction func deleteButtonAction(_ sender: NSButton) {
		let row: Int = self.outlineView.row(for: sender)
		
		print(row)
	}
	
}


extension OutlineViewController: NSOutlineViewDataSource {
	
	func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
		if item == nil {
			return self.group.count
		} else {
			let item: String = item as! String
			
			return self.groupItems[item]!.count
		}
	}
	
	func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
		if item == nil {
			return self.group[index]
		} else {
			let item: String = item as! String
			
			return self.groupItems[item]![index]
		}
	}
	
	func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
		if item is String {
			return true
		} else {
			return false
		}
	}
	
	func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
		
		if item is String {
			let tableCellView: NSTableCellView = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("GroupTableCellView"), owner: self) as! NSTableCellView
			let textFieldTag: Int = 1
			let textField: NSTextField = tableCellView.viewWithTag(textFieldTag) as! NSTextField
			
			textField.stringValue = item as! String
			
			if #available(macOS 11.0, *) {
				// DelegateのisGroupItemでの表示反映がされない場合があるので、自前で対応
				if tableCellView.textField != nil {
					tableCellView.textField?.textColor = .secondaryLabelColor
					tableCellView.textField?.font = .systemFont(ofSize: NSFont.smallSystemFontSize, weight: .semibold)
					tableCellView.textField = nil // isGroupItemの表示反映なしに
				}
			}
			
			return tableCellView
			
		} else {
			if let location: Location = item as? Location {
				let row: Int = outlineView.row(forItem: location)
				let tableRowView: TrackingTableRowView = outlineView.rowView(atRow: row, makeIfNecessary: false) as! TrackingTableRowView
				let tableCellView: NSTableCellView = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("LocationTableCellView"), owner: self) as! NSTableCellView
				let stackView: NSStackView = tableCellView.viewWithTag(StackView.Tag) as! NSStackView
				let textField: NSTextField = stackView.views[StackView.TitleTextFieldIndex] as! NSTextField
				
				textField.stringValue = location.location
				
				if tableRowView.mouseOver {
					stackView.views[StackView.DeleteButtonViewIndex].isHidden = false
				} else {
					stackView.views[StackView.DeleteButtonViewIndex].isHidden = true
				}
				
				return tableCellView

			} else {
				return nil
			}
		}
	}
	
}

extension OutlineViewController: NSOutlineViewDelegate {
	
	func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
		if item is String {
			return true
		} else {
			return false
		}
	}
	
	func outlineView(_ outlineView: NSOutlineView, rowViewForItem item: Any) -> NSTableRowView? {
		
		if item is Location {
			let identifier: NSUserInterfaceItemIdentifier = NSUserInterfaceItemIdentifier("TrackingTableRowView")
			
			var tableRowView: TrackingTableRowView? = outlineView.makeView(withIdentifier: identifier, owner: self) as? TrackingTableRowView
			
			if tableRowView == nil {
				tableRowView = TrackingTableRowView(frame: NSZeroRect)
				tableRowView?.identifier = identifier
			}
			
			tableRowView!.mouseOver = false
			
			return tableRowView
		} else {
			return nil
		}
	}
	
}
