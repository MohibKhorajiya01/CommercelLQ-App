import re

with open('lib/core/database/database_seeder.dart', 'r') as f:
    lines = f.readlines()

new_lines = []
for line in lines:
    if "'youtube_id':" in line:
        # Check which lesson we are in based on a rough heuristic.
        # But actually, let's just strip 'youtube_id': '...' from all lines,
        # then manually add it to the 3 specific lessons using replace_file_content.
        line = re.sub(r"'youtube_id':\s*'[^']+',\s*", "", line)
    new_lines.append(line)

with open('lib/core/database/database_seeder.dart', 'w') as f:
    f.writelines(new_lines)

print("Removed all youtube_ids")
