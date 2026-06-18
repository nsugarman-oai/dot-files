# Terminal Prompt Time Design

## Goal

Show the local time at the end of the Starship prompt header, immediately after command duration when duration is present.

## Design

Enable Starship's built-in `time` module in `files/config/starship.toml`. Configure it for 12-hour local time without seconds and render it with an `@` prefix. The resulting header ends with output such as `took 35s @ 8:20pm`; short commands without a duration still show `@ 8:20pm`.

Use the built-in module instead of shell hooks or custom commands. This keeps prompt rendering within Starship and avoids adding another process to every prompt.

## Validation

Validate the TOML through the installed Starship binary and render the time module to confirm the `@ h:mmam` or `@ h:mmpm` shape.
