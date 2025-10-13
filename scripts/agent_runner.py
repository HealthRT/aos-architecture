#!/usr/bin/env python3
import json
import os
import re
import subprocess
import sys
from pathlib import Path


def run(cmd: str) -> str:
    result = subprocess.run(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    if result.returncode != 0:
        print(result.stdout)
        raise SystemExit(result.returncode)
    return result.stdout.strip()


def safe_slug(text: str, max_len: int = 40) -> str:
    slug = re.sub(r"[^a-zA-Z0-9\-]+", "-", text.strip()).strip("-")
    return slug[:max_len].lower() or "story"


def git_config():
    run("git config user.name 'aos-agent-bot'")
    run("git config user.email 'aos-agent-bot@users.noreply.github.com'")


def ba_on_epic(event):
    issue = event["issue"]
    num = issue["number"]
    title = issue["title"]
    body = issue.get("body") or ""
    slug = safe_slug(title)
    branch = f"bot/ba-story-{num}-{slug}"

    git_config()
    run(f"git checkout -b {branch}")

    story_dir = Path("specs/generated")
    story_dir.mkdir(parents=True, exist_ok=True)
    story_path = story_dir / f"STORY-{num}-{slug}.yaml"
    content = f"""id: GENERATED-{num}
title: "{title}"
summary: |
  Generated from Epic #{num}. Replace this summary with the precise objective.

user_story: |
  {body}

acceptance_criteria:
  - "TBD"

models: []
artifacts: {{ code: [], tests: [], docs: [] }}
"""
    story_path.write_text(content, encoding="utf-8")

    run(f"git add {story_path.as_posix()}")
    run(f"git commit -m 'feat(BA): generate Story.yaml draft from Epic #{num}'")
    run(f"git push -u origin {branch}")

    pr_title = f"Story: {title}"
    pr_body = f"Generated from Epic #{num}.\n\nPlease review (status:needs-technical-review)."
    pr_url = run(
        f"gh pr create -B main -H {branch} --title {json.dumps(pr_title)} --body {json.dumps(pr_body)}"
    )
    # apply review-needed label if exists
    try:
        run("gh pr edit --add-label 'status:needs-technical-review'")
    except SystemExit:
        pass
    # comment back on epic
    run(
        f"gh issue comment {num} --body {json.dumps(f'BA Story draft opened: {pr_url}') }"
    )


def architect_on_pr(event):
    pr = event["pull_request"]
    number = pr["number"]
    msg = (
        "Architect review started. I will validate acceptance criteria coverage, constraints, and ADR compliance."
    )
    run(f"gh pr comment {number} --body {json.dumps(msg)}")


def scrum_on_story_approved(event):
    pr = event.get("pull_request")
    if pr:
        pr_number = pr["number"]
        msg = (
            "Scrum received approval. Decomposition queued: work orders will be created and dispatched."
        )
        run(f"gh pr comment {pr_number} --body {json.dumps(msg)}")


def coder_on_issue(event):
    issue = event["issue"]
    num = issue["number"]
    title = issue["title"]
    slug = safe_slug(title)
    branch = f"feature/WO-{num}-{slug[:20]}"
    checklist = (
        f"Suggested branch: `{branch}`\n\n"
        "Please implement per work order and attach Proof of Execution (install/upgrade/tests)."
    )
    repo = os.environ.get("GITHUB_REPOSITORY", "")
    run(f"gh issue comment {num} --repo {repo} --body {json.dumps(checklist)}")


def main():
    role = os.environ.get("ROLE", "").lower()
    event_path = os.environ.get("GITHUB_EVENT_PATH")
    if not role or not event_path:
        print("ROLE and GITHUB_EVENT_PATH are required")
        sys.exit(1)
    with open(event_path, "r", encoding="utf-8") as f:
        event = json.load(f)

    if role == "ba":
        ba_on_epic(event)
    elif role == "architect":
        architect_on_pr(event)
    elif role == "scrum":
        scrum_on_story_approved(event)
    elif role == "coder":
        coder_on_issue(event)
    else:
        print(f"Unknown role: {role}")
        sys.exit(2)


if __name__ == "__main__":
    main()


