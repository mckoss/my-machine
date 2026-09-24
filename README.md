My portable machine configuration files.  I use this to setup a consitent (Ubuntu) configuration
on the multiple machines I use/administer.

You can setup a new machine by executing:

    wget https://raw.github.com/mckoss/my-machine/master/my-machine.sh
    chmod +x my-machine.sh
    ./my-machine.sh

## Global AI agent instructions

`home/.agents/AGENTS.md` holds my global instructions for AI coding agents. Run
`bin/setup-agents` (also run by `bin/setup-machine`) to link it in place:

    ~/.claude/CLAUDE.md  -> <repo>/home/.agents/AGENTS.md
    ~/.codex/AGENTS.md   -> <repo>/home/.agents/AGENTS.md
    ~/.gemini/GEMINI.md  -> <repo>/home/.agents/AGENTS.md

It is safe to re-run. A file that already matches is replaced by a link; one
that differs is shown as a diff and left alone unless you agree to move it
aside to a `.bak-*` backup.
