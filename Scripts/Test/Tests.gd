extends Node2D

export var bShouldTest = true

var PassedTests = []
var FailedTests = []
var SkippedTests = []

func _ready():
	if bShouldTest:
		for test in get_children():
			if test.bIsEnabled:
				if test.bShowVerbose:
					test.ShowVerbose()
				if test.RunTest():
					PassedTests.append(test)
				else:
					FailedTests.append(test)
			else:
				SkippedTests.append(test)
		print("=== Total Tests: " + str(get_child_count()))
		print("=== Passed Tests: " + str(len(PassedTests)))
		print("=== Skipped Tests: " + str(len(SkippedTests)))
		for test in SkippedTests:
			print(test.name + " was skipped")
		print("=== Failed Tests: " + str(len(FailedTests)))
		for test in FailedTests:
			test.PrintFailureReason()
