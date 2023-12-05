extends Node2D


export var bIsEnabled = true
export var bShowVerbose = true
var failureReason = []

func RunTest():
	return false

func ShowVerbose():
	pass
	
func PrintFailureReason():
	print("=== " + name + " has failed ===")
	for x in range(0, len(failureReason)):
		var text = "[" + str(x+1) + "]: " + failureReason[x]
		print(text)
