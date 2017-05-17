#!/usr/bin/env python

import sys, os
import xml.etree.ElementTree as et

PREFIX = "s"

segueIdentifiers = {}
controllerIdentifiers = {}
storyboardNames = {}
reuseIdentifiers = {}

def addSegueIdentifier(identifier):
	key = identifier[0].upper() + identifier[1:]
	if not key.startswith(PREFIX.upper()):
		key = PREFIX + key

	segueIdentifiers[key] = identifier

def addControllerIdentifier(identifier):
    key = identifier[0].upper() + identifier[1:]
    if not key.startswith(PREFIX.upper()):
        key =  key

    controllerIdentifiers[key] = identifier

def addStoryboardName(identifier):
    key = identifier[0].upper() + identifier[1:]
    if not key.startswith(PREFIX.upper()):
        key =  key

    storyboardNames[key] = identifier

def addReuseIdentifier(identifier):
    key = identifier[0].upper() + identifier[1:]
    if not key.startswith(PREFIX.upper()):
        key = PREFIX + key

    reuseIdentifiers[key] = identifier

def process_storyboard(file):
    tree = et.parse(file)
    root = tree.getroot()

    addStoryboardName(os.path.splitext(os.path.basename(file))[0])

    for segue in root.iter("segue"):
        segueIdentifier = segue.get("identifier")
        if segueIdentifier == None:
            continue
        addSegueIdentifier(segueIdentifier)

    for controller in root.iter("viewController"):
		controllerIdentifier = controller.get("storyboardIdentifier")
		if controllerIdentifier == None:
			continue
		addControllerIdentifier(controllerIdentifier)


# def writeHeader(file, identifiers):
#     constants = sorted(identifiers.keys())
#
#     for constantName in constants:
#         file.write("extern NSString * const " + constantName + ";\n")

def writeImplementation(file, identifiers):
    constants = sorted(identifiers.keys())

    for constantName in constants:
        file.write("    static let " + constantName + " = \"" + identifiers[constantName] + "\"\n")

def writeEnum(file, identifiers):
    constants = sorted(identifiers.keys())

    for constantName in constants:
        file.write("    case " + constantName + " = \"" + identifiers[constantName] + "\"\n")

count = os.environ["SCRIPT_INPUT_FILE_COUNT"]
for n in range(int(count)):
    process_storyboard(os.environ["SCRIPT_INPUT_FILE_" + str(n)])

# with open(sys.argv[1], "w+") as header:
#     header.write("/* Generated document. DO NOT CHANGE */\n\n")
#     header.write("/* Segue identifier constants */\n")
#     header.write("@class NSString;\n\n")
#     writeHeader(header, segueIdentifiers)
#
#     header.close()

with open(sys.argv[1], "w+") as implementation:
    implementation.write("/* Generated document. DO NOT CHANGE */\n\n")
    implementation.write("import Foundation\n\nstruct StoryboardSegue { \n\n")

    writeImplementation(implementation, segueIdentifiers)
    implementation.write("\n}\n\n")

    implementation.write("enum ViewControllerIdentifier : String {\n")
    writeEnum(implementation, controllerIdentifiers)
    implementation.write("\n}\n\n")

    implementation.write("enum StoryboardName : String {\n")
    writeEnum(implementation, storyboardNames)
    implementation.write("\n}")

    implementation.close()
