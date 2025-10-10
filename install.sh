#!/bin/bash

# YMD-Spec Installation Script
# Installs YMD/PMD specifications and prompts to ~/.claude/ymd-spec/

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Installation paths
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/ymd-spec"
TARGET_DIR="$HOME/.claude/ymd-spec"
BACKUP_DIR="$HOME/.claude/ymd-spec.backup.$(date +%Y%m%d_%H%M%S)"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}YMD-Spec Installation${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo -e "${RED}Error: Source directory not found: $SOURCE_DIR${NC}"
    exit 1
fi

# Check if ~/.claude directory exists
if [ ! -d "$HOME/.claude" ]; then
    echo -e "${YELLOW}~/.claude directory not found. Creating...${NC}"
    mkdir -p "$HOME/.claude"
    echo -e "${GREEN}✓ Created ~/.claude directory${NC}"
fi

# Backup existing installation if it exists
if [ -d "$TARGET_DIR" ]; then
    echo -e "${YELLOW}Existing installation found at: $TARGET_DIR${NC}"
    echo -e "${YELLOW}Creating backup at: $BACKUP_DIR${NC}"
    cp -R "$TARGET_DIR" "$BACKUP_DIR"
    echo -e "${GREEN}✓ Backup created${NC}"
    echo ""
fi

# Create target directory
echo -e "${BLUE}Installing YMD-Spec to: $TARGET_DIR${NC}"
mkdir -p "$TARGET_DIR"

# Copy files
echo -e "${BLUE}Copying specification files...${NC}"
cp -R "$SOURCE_DIR"/* "$TARGET_DIR/"

# Verify installation
if [ -f "$TARGET_DIR/ymd_format_spec.md" ] && \
   [ -f "$TARGET_DIR/pmd_format_spec.md" ] && \
   [ -d "$TARGET_DIR/prompts" ]; then
    echo -e "${GREEN}✓ Installation successful!${NC}"
else
    echo -e "${RED}✗ Installation verification failed${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}Installation Summary${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "Target location: ${GREEN}$TARGET_DIR${NC}"
echo ""
echo "Installed files:"
echo "  ✓ Core specifications (ymd_format_spec.md, pmd_format_spec.md, composition_spec.md)"
echo "  ✓ Context documentation (context/)"
echo "  ✓ Business logic prompts (prompts/)"
echo "  ✓ Cheatsheet (cheatsheet/)"
echo ""

if [ -d "$BACKUP_DIR" ]; then
    echo -e "Backup of previous installation: ${YELLOW}$BACKUP_DIR${NC}"
    echo ""
fi

echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}Next Steps${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "1. Load YMD/PMD context in Claude Code:"
echo -e "   ${YELLOW}/load-ymd-context${NC}"
echo ""
echo "2. Create your first YMD file:"
echo -e "   ${YELLOW}/create-ymd-manifest${NC}"
echo ""
echo "3. Or use the interactive agent:"
echo -e "   ${YELLOW}@ymd-author${NC}"
echo ""
echo "4. Validate compositions:"
echo -e "   ${YELLOW}/validate-composition path/to/file.ymd${NC}"
echo ""
echo -e "${GREEN}Documentation:${NC}"
echo -e "  Quick reference: ${BLUE}~/.claude/ymd-spec/context/quick-reference.md${NC}"
echo -e "  Cheatsheet:      ${BLUE}~/.claude/ymd-spec/cheatsheet/ymd_pmd_cheatsheet.md${NC}"
echo -e "  Examples:        ${BLUE}~/.claude/ymd-spec/context/examples.md${NC}"
echo ""
echo -e "${GREEN}Installation complete! 🎉${NC}"
