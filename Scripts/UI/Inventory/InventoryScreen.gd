extends Container

var ItemClass = preload("res://Prefab/UI/Inventory/InventoryItem.tscn")

onready var ItemBox = $VBoxContainer/InventoryItems/ScrollContainer/ItemVbox

func Save():
	pass
	
func Load():
	pass
	
func _ready():
	var inventory = get_tree().get_nodes_in_group("Inventory")[0]
	inventory.connect("OnInventoryUpdate", self, "ShowInventory")
	ShowInventory()
	
	
	for item in ItemBox.get_children():
		item.queue_free()
		
	yield(get_tree().create_timer(1.0), "timeout")
	SortInventory()
	UpdateInventoryTPS()
	
func UpdateInventoryTPS():
	var inventory = get_tree().get_nodes_in_group("Inventory")[0]
	var items = inventory.GetItemList()
	for item in items:
		var foundItem = FindItem(item)
		if foundItem != null:
			var amount = Helper.GetSlimePanel().GetTPSForResource(item)
			foundItem.UpdateTPS(amount)
		
	
func ShowInventory():
	var inventory = get_tree().get_nodes_in_group("Inventory")[0]
	var items = inventory.GetItemList()
	for item in items:
		var foundItem = FindItem(item)
		if foundItem != null:
			foundItem.UpdateText(items[item])
		else:
			var instance = ItemClass.instance()
			instance.Setup(item, items[item])
			ItemBox.add_child(instance)
			SortInventory()
	
			
			

func SortInventory():	
	# Implement bubble sort?
	if ItemBox.get_child_count() <= 0:
		return
	
	for index in range(0, ItemBox.get_child_count()):
		var smallestChild = ItemBox.get_child(index)
		for invItem in range(index + 1, ItemBox.get_child_count()):
			if ItemBox.get_child(invItem) == smallestChild:
				pass
			else:
				var itemBoxName = ItemBox.get_child(invItem).ItemName.to_lower()
				var smallestChildName = smallestChild.ItemName.to_lower()
				if itemBoxName < smallestChildName:
					smallestChild = ItemBox.get_child(invItem)
					print(itemBoxName + ">" + smallestChildName)
		ItemBox.move_child(smallestChild, index)
		
			
		
		
func FindItem(itemName):
	for element in ItemBox.get_children():
		if element.ItemName == itemName:
			return element
	return null
