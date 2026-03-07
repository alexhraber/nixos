# /etc/nixos/nushell/custom.nu

$env.PATH = ($env.PATH | prepend [
  $"($env.HOME)/.opencode/bin"
  $"($env.HOME)/.local/bin"
  $"($env.HOME)/.npm-global/bin"
  $"($env.HOME)/bin"
])

$env.GPG_TTY = (tty)

alias ll = ls -la
alias la = ls -a
alias l = ls
alias c = clear
alias r = reset
alias q = exit

alias nrs = sudo nixos-rebuild switch
alias nrt = sudo nixos-rebuild test
alias nrb = sudo nixos-rebuild boot

alias gs = git status
alias ga = git add
alias gc = git commit
alias gp = git push
alias gl = git log --oneline --graph --decorate -20

def has-command [name: string] {
  (which $name | is-not-empty)
}

def is-ssh-session [] {
  let ssh_client = ($env.SSH_CLIENT? | default "")
  let ssh_connection = ($env.SSH_CONNECTION? | default "")
  let ssh_tty = ($env.SSH_TTY? | default "")
  (($ssh_client != "") or ($ssh_connection != "") or ($ssh_tty != ""))
}

def shell-level [] {
  ($env.SHLVL? | default "1" | into int)
}

# Lockfile keyed on parent PID (the terminal process) — survives shell restarts within same terminal
def ff-lockfile [] {
  let ppid = (open --raw $"/proc/($nu.pid)/status" | lines | where ($it | str starts-with "PPid") | first | str replace --regex 'PPid:\s+' '' | str trim)
  $"/tmp/.ff_($ppid)"
}

if $nu.is-interactive {
  let nested_shell = ((shell-level) > 1)
  let remote_shell = (is-ssh-session)
  let lockfile = (ff-lockfile)
  let already_shown = ($lockfile | path exists)

  if (not $nested_shell) and (not $remote_shell) and (not $already_shown) {
    ^touch $lockfile
    ^stty sane
    ^reset
    if (has-command "fastfetch") { fastfetch }
  }
}
