#!/bin/bash

SKILLS_DIR="skill"
CONFIG_FILE="./antigravity.json"
PLUGIN_DIR=".gemini/config/plugins/flutter-project-skills"
CLAUDE_RULES_DIR=".claude/rules"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# ==========================================
# PARSE ARGUMENTS
# ==========================================
TARGET="all"
if [ "$1" = "--antigravity" ]; then
    TARGET="antigravity"
elif [ "$1" = "--claude" ]; then
    TARGET="claude"
fi

echo "Configuring Flutter Skills..."
echo "Target: $TARGET"

if [ ! -d "$SKILLS_DIR" ]; then
    echo -e "${RED}Error: Skills directory ($SKILLS_DIR) not found. Please clone the submodule first.${NC}"
    exit 1
fi

# ==========================================
# 1. ANTIGRAVITY
# ==========================================
setup_antigravity() {
    echo ""
    echo "Generating $CONFIG_FILE..."
    echo '{
  "settings": {
    "agent_mode": "advanced",
    "progressive_context": true
  },
  "skills": [' > "$CONFIG_FILE"

    FIRST=true
    for file in "$SKILLS_DIR"/skill_*.md; do
        if [ -f "$file" ]; then
            rel_path="skills/$(basename "$file")"
            skill_name=$(basename "$file" .md | sed 's/skill_[0-9]*_//' | tr '_' ' ')

            if [ "$FIRST" = true ]; then
                FIRST=false
            else
                echo "," >> "$CONFIG_FILE"
            fi

            echo "    { \"name\": \"$skill_name\", \"path\": \"$rel_path\", \"enabled\": true }" >> "$CONFIG_FILE"
        fi
    done

    echo "
  ]
}" >> "$CONFIG_FILE"

    echo "Generating local workspace plugin at $PLUGIN_DIR..."
    rm -rf "$PLUGIN_DIR"
    mkdir -p "$PLUGIN_DIR/skills"

    cat > "$PLUGIN_DIR/plugin.json" << 'PLUGINJSON'
{
  "name": "flutter-project-skills",
  "version": "1.0.0",
  "description": "Local Flutter skills and conventions for this project.",
  "author": {
    "name": "Developer"
  },
  "license": "MIT",
  "keywords": ["flutter", "project-skills"]
}
PLUGINJSON

    for file in "$SKILLS_DIR"/skill_*.md; do
        if [ -f "$file" ]; then
            base_name=$(basename "$file" .md)
            skill_dir_name=$(echo "$base_name" | sed 's/skill_[0-9]*_//' | tr '_' '-')
            human_name=$(echo "$base_name" | sed 's/skill_[0-9]*_//' | tr '_' ' ')

            summary=$(head -n 1 "$file" | grep -i "^Summary:" | sed 's/^Summary: *//I')
            if [ -z "$summary" ]; then
                summary="Instructions and rules for $human_name"
            fi

            mkdir -p "$PLUGIN_DIR/skills/$skill_dir_name"

            {
                echo "---"
                echo "name: \"$human_name\""
                echo "description: \"$summary\""
                echo "---"
                cat "$file"
            } > "$PLUGIN_DIR/skills/$skill_dir_name/SKILL.md"

            echo "Configured skill: $human_name"
        fi
    done

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[Antigravity] Config generated at: $CONFIG_FILE${NC}"
        echo -e "${GREEN}[Antigravity] Plugin generated at: $PLUGIN_DIR${NC}"
    else
        echo -e "${RED}[Antigravity] Failed to generate config.${NC}"
        exit 1
    fi
}

# ==========================================
# 2. CLAUDE CODE
# ==========================================
setup_claude() {
    echo ""
    echo "Setting up .claude/rules/ ..."
    mkdir -p "$CLAUDE_RULES_DIR"

    cat > "./CLAUDE.md" << 'CLAUDEMD'
# Flutter Project

Skills are loaded automatically from `.claude/rules/` based on the files you are editing.
Run `/memory` to see which skills are currently active.
CLAUDEMD

    declare -A SKILL_PATHS
    SKILL_PATHS["skill_01_project_structure"]=""
    SKILL_PATHS["skill_02_bloc_cubit"]="**/*_bloc.dart\n  - **/*_cubit.dart\n  - **/*_state.dart\n  - **/*_event.dart"
    SKILL_PATHS["skill_03_data_layer"]="**/*_repository.dart\n  - **/*_repository_impl.dart\n  - **/*_datasource.dart\n  - **/*_model.dart\n  - **/*_entity.dart"
    SKILL_PATHS["skill_04_routing"]="**/*router*\n  - **/*route*\n  - **/*routes*"
    SKILL_PATHS["skill_05_widget_ui"]="**/*_page.dart\n  - **/*_screen.dart\n  - **/*_widget.dart\n  - **/widgets/**\n  - **/pages/**\n  - **/screens/**"
    SKILL_PATHS["skill_06_theme"]="**/*theme*\n  - **/*color*\n  - **/*style*\n  - **/theme/**"
    SKILL_PATHS["skill_07_testing"]="**/*_test.dart\n  - **/test/**"

    for file in "$SKILLS_DIR"/skill_*.md; do
        if [ -f "$file" ]; then
            base_name=$(basename "$file" .md)
            human_name=$(echo "$base_name" | sed 's/skill_[0-9]*_//' | tr '_' ' ')
            out_file="$CLAUDE_RULES_DIR/$base_name.md"
            paths="${SKILL_PATHS[$base_name]}"

            {
                echo "---"
                echo "description: Flutter $human_name skill"
                if [ -n "$paths" ]; then
                    echo "paths:"
                    echo -e "  - $paths"
                fi
                echo "---"
                cat "$file"
            } > "$out_file"

            echo "Configured skill: $human_name"
        fi
    done

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[Claude] Rules generated at: $CLAUDE_RULES_DIR${NC}"
        echo -e "${GREEN}[Claude] CLAUDE.md created at project root${NC}"
        echo "Run /memory in Claude Code to verify skills are loaded"
    else
        echo -e "${RED}[Claude] Failed to generate rules.${NC}"
        exit 1
    fi
}

# ==========================================
# 3. RUN
# ==========================================
case "$TARGET" in
    antigravity)
        setup_antigravity
        ;;
    claude)
        setup_claude
        ;;
    all)
        setup_antigravity
        setup_claude
        ;;
esac

echo ""
echo -e "${GREEN}Done!${NC}"