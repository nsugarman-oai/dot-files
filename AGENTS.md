# AGENTS.md

## Notes

- Keep the detailed add/remove workflow in the skill files. Do not duplicate that procedure here.
- Keep `README.md` concise and usage-focused. Document only what a user needs to know to run the repo's scripts and workflows; do not add architecture decisions or other internal implementation details.
- Follow the existing command naming, script layout, and helper usage patterns already present in this repo.
- Keep command comments in `files/local/bin/git-alias` and `files/config/git/aliases.conf` in sync. When adding, removing, or rewording one of those comments in either file, update the matching comment in the other file in the same change.
- Use repo-relative paths in repo docs and instructions, for example `.agents/skills/add-file/SKILL.md`.
- Do not hardcode absolute filesystem paths, usernames, or assumed install locations in docs, skills, or agent guidance.
