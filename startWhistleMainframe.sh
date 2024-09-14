#!/bin/bash
echo "whistling mainframe engaged..."
echo "send OSC messages to /whistle followed by a string of comma-separated notes in the form of 'c,e,f#,g' (no spaces)"
/Applications/SuperCollider.app/Contents/MacOS/sclang ./data/whistler.scd
