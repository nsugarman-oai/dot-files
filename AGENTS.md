# AGENTS.md

## Skill Routing

- When the user asks to add a file to this repo, use `skills/add-file/SKILL.md`.
- When the user asks to remove a file from this repo, use `skills/remove-file/SKILL.md`.
- When the user asks to link a file while preserving existing local changes, merge an existing home-directory file into the repo copy before relinking, or asks for `link-merge` on one file or `all`, use `skills/link-merge/SKILL.md`.
- When the user asks to install this repo's managed files into `$HOME`, or asks for an install flow across all managed files, use `skills/install/SKILL.md`.

## Notes

- Keep the detailed add/remove workflow in the skill files. Do not duplicate that procedure here.
- Follow the existing command naming, script layout, and helper usage patterns already present in this repo.
- Keep command comments in `files/local/bin/git-alias` and `files/config/git/aliases.conf` in sync. When adding, removing, or rewording one of those comments in either file, update the matching comment in the other file in the same change.
- Use repo-relative paths in repo docs and instructions, for example `skills/add-file/SKILL.md`.
- Do not hardcode absolute filesystem paths, usernames, or assumed install locations in docs, skills, or agent guidance.
