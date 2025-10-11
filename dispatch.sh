#!/bin/bash

# dispatch.sh - Automated Work Order Dispatch Script
# Creates GitHub issues from markdown work order files
# Usage: ./dispatch.sh <work_order_file_path>

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_error() {
    echo -e "${RED}ERROR: $1${NC}" >&2
}

print_success() {
    echo -e "${GREEN}SUCCESS: $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}WARNING: $1${NC}"
}

# Check if file argument is provided
if [ $# -ne 1 ]; then
    print_error "Usage: $0 <work_order_file_path>"
    print_error "Example: $0 work_orders/pending/DEVOPS-004.md"
    exit 1
fi

WORK_ORDER_FILE="$1"

# Check if file exists
if [ ! -f "$WORK_ORDER_FILE" ]; then
    print_error "Work order file not found: $WORK_ORDER_FILE"
    exit 1
fi

print_warning "Processing work order: $WORK_ORDER_FILE"

# Extract YAML frontmatter (content between first and second ---)
FRONTMATTER=$(sed -n '/^---$/,/^---$/p' "$WORK_ORDER_FILE" | sed '1d;$d')

if [ -z "$FRONTMATTER" ]; then
    print_error "No YAML frontmatter found in $WORK_ORDER_FILE"
    print_error "Work order files must have YAML frontmatter with title, repo, assignee, and labels"
    exit 1
fi

# Extract fields from frontmatter
TITLE=$(echo "$FRONTMATTER" | grep '^title:' | sed 's/title: *//' | sed 's/^"//' | sed 's/"$//')
REPO=$(echo "$FRONTMATTER" | grep '^repo:' | sed 's/repo: *//' | sed 's/^"//' | sed 's/"$//')
ASSIGNEE=$(echo "$FRONTMATTER" | grep '^assignee:' | sed 's/assignee: *//' | sed 's/^"//' | sed 's/"$//')
LABELS=$(echo "$FRONTMATTER" | grep '^labels:' | sed 's/labels: *//' | sed 's/^"//' | sed 's/"$//')

# Validate required fields
if [ -z "$TITLE" ]; then
    print_error "Missing 'title' field in frontmatter"
    exit 1
fi

if [ -z "$REPO" ]; then
    print_error "Missing 'repo' field in frontmatter"
    exit 1
fi

if [ -z "$ASSIGNEE" ]; then
    print_error "Missing 'assignee' field in frontmatter"
    exit 1
fi

if [ -z "$LABELS" ]; then
    print_error "Missing 'labels' field in frontmatter"
    exit 1
fi

print_warning "Extracted metadata:"
echo "  Title: $TITLE"
echo "  Repo: $REPO"
echo "  Assignee: $ASSIGNEE"
echo "  Labels: $LABELS"

# Extract body content (everything after the second --- marker)
# Find the line number of the second --- marker
SECOND_MARKER_LINE=$(grep -n '^---$' "$WORK_ORDER_FILE" | sed -n '2p' | cut -d: -f1)

if [ -z "$SECOND_MARKER_LINE" ]; then
    print_error "Could not find second --- marker in file"
    exit 1
fi

# Extract everything after the second marker (add 1 to skip the marker line itself)
BODY=$(sed -n "$((SECOND_MARKER_LINE + 1)),\$p" "$WORK_ORDER_FILE")

if [ -z "$BODY" ]; then
    print_error "No body content found after frontmatter"
    exit 1
fi

# Create a temporary file for the body content
TEMP_BODY_FILE=$(mktemp)
echo "$BODY" > "$TEMP_BODY_FILE"

# Build gh command
GH_CMD="gh issue create"

# Add title
GH_CMD="$GH_CMD --title \"$TITLE\""

# Add repo if not the current one
if [ "$REPO" != "HealthRT/aos-architecture" ]; then
    GH_CMD="$GH_CMD --repo \"$REPO\""
fi

# Add assignee (only if it's a valid GitHub user)
if gh api user/"$ASSIGNEE" >/dev/null 2>&1; then
    GH_CMD="$GH_CMD --assignee \"$ASSIGNEE\""
    print_warning "Assignee will be set to: $ASSIGNEE"
else
    print_warning "Assignee '$ASSIGNEE' is not a valid GitHub user - skipping assignee assignment"
fi

# Add labels (split by comma and add each)
IFS=',' read -ra LABEL_ARRAY <<< "$LABELS"
for label in "${LABEL_ARRAY[@]}"; do
    label=$(echo "$label" | sed 's/^ *//' | sed 's/ *$//')  # trim whitespace
    GH_CMD="$GH_CMD --label \"$label\""
done

# Add body file
GH_CMD="$GH_CMD --body-file \"$TEMP_BODY_FILE\""

print_warning "Executing: $GH_CMD"

# Execute the command
if ISSUE_URL=$(eval "$GH_CMD"); then
    print_success "GitHub issue created successfully!"
    echo "Issue URL: $ISSUE_URL"

    # Create dispatched directory if it doesn't exist
    DISPATCHED_DIR="work_orders/dispatched"
    mkdir -p "$DISPATCHED_DIR"

    # Move the file to dispatched directory
    DISPATCHED_FILE="$DISPATCHED_DIR/$(basename "$WORK_ORDER_FILE")"
    mv "$WORK_ORDER_FILE" "$DISPATCHED_FILE"

    print_success "Work order moved to: $DISPATCHED_FILE"

else
    print_error "Failed to create GitHub issue"
    rm -f "$TEMP_BODY_FILE"
    exit 1
fi

# Clean up temp file
rm -f "$TEMP_BODY_FILE"

print_success "Work order dispatch completed successfully!"
