class_name Inventory
extends Node

#### Signals
signal list_updated(list: Array[ItemResource])
signal item_added(item: ItemResource, quantity: int)
signal item_removed(item: ItemResource, quantity: int)

var items_list: Array[ItemResource]
var slots_size: int

func is_any_slot_free() -> bool:
	if items_list.size() < slots_size:
		return true
	else:
		return false


func add_item(item: ItemResource, quantity: int = 1) -> void:
	if quantity <= 0:
		return
	
	if not(is_any_slot_free()):
		return
	
	var necessary_quantity: int = quantity
	
	if quantity_item(item) > 0:
		for i in range(items_list.size()):
			var item_ref: ItemResource = items_list[i]
			
			#### Confirm that the item is the same in the list
			if not(item_ref.item_data.equal(item)):
				continue
			
			#### The item exist and have enought space in the slot to save it
			var mod_item: ItemResource = ItemResource.new()
			mod_item.item_data = item_ref.item_data
			
			var rest: int = item_ref.item_data.max_stack - (necessary_quantity + item_ref.quantity)
			
			#### The space is more than enought to save the complete quantity
			if rest >= 0:
				mod_item.quantity = necessary_quantity + item_ref.quantity
				necessary_quantity = 0
			#### Exist a difference with the quantity that means it need to save the excess
			#### In other slot or create a new instance
			else:
				mod_item.quantity = item_ref.item_data.max_stack
				necessary_quantity = abs(rest)
			
			items_list.set(i, mod_item)
	
	#### If the quantity is higher than 0 that means exist some quantity of this item
	#### Then need to create a new instance in the list of items
	if necessary_quantity > 0:
		if necessary_quantity > item.max_stack:
			var new_item: ItemResource = ItemResource.new()
			new_item.item = item
			new_item.quantity = item.max_stack
			
			items_list.append(new_item)
			add_item(item, necessary_quantity - item.max_stack)
		else:
			var new_item: ItemResource = ItemResource.new()
			new_item.item = item
			new_item.quantity = necessary_quantity
			
			items_list.append(new_item)
	
	emit_signal("item_added", item, quantity)
	emit_signal("list_updated", items_list)


func remove_item(item: ItemResource, quantity: int) -> void:
	var current_quantity: int = quantity_item(item)
	var necessary_quantity: int = clamp(quantity, 0, 9999999)
	
	#### First validate that the quantity is valid
	if necessary_quantity > current_quantity:
		return
	
	#### Set all instances of the item with a quantity of 0
	items_list = items_list.map(func(element: ItemResource):
		#### Confirm that quantity is higher than 0
		if current_quantity <= 0:
			return element
		
		#### Confirm that the item is the same in the list
		if not(element.item_data.equals(item)):
			return element
		
		var mod_element: ItemResource = ItemResource.new()
		mod_element.item_data = element.item_data
		
		var rest: int = current_quantity - element.quantity
		
		if rest > 0:
			current_quantity = rest
			mod_element.quantity = 0
		else:
			current_quantity = 0
			mod_element.quantity = abs(rest)
		
		return mod_element
		)
	
	#### Remove al instances with quantity equal to 0
	items_list = items_list.filter(func(element: ItemResource):
		return element.quantity > 0
		)
	
	emit_signal("item_removed", item, quantity)
	emit_signal("list_updated", items_list)


func quantity_item(item: ItemResource) -> int:
	var quantity: int = 0
	
	for i in items_list:
		if i.item_data.equal(item):
			quantity += i.quantity
	
	return quantity
