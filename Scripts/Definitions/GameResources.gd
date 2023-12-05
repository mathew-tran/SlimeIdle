extends Node

enum RESOURCE_TYPE {
	WOOD,
	STONE,
	GRAVEL,
	MUSHROOM,
	SMALLFISH,
	PAPER,
	DUST,
	CUTSTONE
}

var ResourceMap = {
	"WOOD" : {
		"Type" : "Build",
	},
	"PAPER" : {
		"Type" : "Build",
	},
	"STONE" : {
		"Type" : "Build",
	},
	"GRAVEL" : {
		"Type" : "Build",
	},
	"MUSHROOM" : {
		"Type" : "Food",
	},
	"SMALLFISH" : {
		"Type" : "Food",
	},
	"CUTSTONE" : {
	}
	
}

func GetResourceData(resourceEnum):
	if ResourceMap.has(resourceEnum):
		return ResourceMap[resourceEnum]
	return null
	

enum TECH_TYPE {
	ADDJOB,
	JOBUPGRADEAMOUNT,
	JOBSETDURATION,
	ADDSLIME,
	UPGRADESLIMECLICK,
	NONE
}
func GetResName(resourceInt):
	return str(GameResources.RESOURCE_TYPE.keys()[resourceInt])
	
class Reward extends Resource:
	var ResourceType
	var Amount : int
		
	func GetRewardString() -> String:
		return str(Amount) + "x " + str(GameResources.RESOURCE_TYPE.keys()[ResourceType])
	
	func GetAmount() -> int:
		return Amount

	
class Job:
	var JobName : String
	var JobReward
	var Duration : int
	
	func GetDurationText():
		return str(Duration) + " seconds"
		
	func GetOutputText() -> String:
		var text = ""
		text += str(JobReward.Amount)
		text += " " + GameResources.GetResName(JobReward.ResourceType)
		text += " per "
		text += str(Duration)
		text += " seconds"
		return text
