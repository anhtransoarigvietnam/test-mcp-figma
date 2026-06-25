import re

with open('/Users/anhtran/.gemini/antigravity-ide/brain/b56e0132-349b-4bfb-94bd-315d53110f33/.system_generated/steps/12/output.txt', 'r') as f:
    lines = f.readlines()

for line in lines:
    if line.startswith('NODE_TREE:'):
        break

screens = []
in_tree = False
for line in lines:
    if line.startswith('NODE_TREE:'):
        in_tree = True
        continue
    if in_tree:
        if line.startswith('- id:'):
            screens.append(line.strip())
        elif line.startswith('  name:'):
            screens.append(line.strip())
        elif line.startswith('  type:'):
            screens.append(line.strip())

for s in screens[:15]:
    print(s)
