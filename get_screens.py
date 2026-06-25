import re

screens = []
with open('/Users/anhtran/.gemini/antigravity-ide/brain/b56e0132-349b-4bfb-94bd-315d53110f33/.system_generated/steps/12/output.txt', 'r') as f:
    for line in f:
        # Match lines like: '    [FRAME] "Screen Name" #123:456 layout={"mode":"none","sizing":{},"locationRelativeToParent":...'
        # Notice there are exactly 4 spaces at the beginning for top-level frames under a SECTION or CANVAS
        match = re.match(r'^    \[FRAME\] "(.*?)" #\d+:\d+ layout=', line)
        if match:
            screens.append(match.group(1))

print(f"Total screens: {len(screens)}")
for s in screens:
    print(f"- {s}")
