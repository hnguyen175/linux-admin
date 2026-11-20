sock="$HOME/.ssh/github-agent.sock"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "$script_dir"

# clean up
pkill -TERM -u "$(id -u)" -x ssh-agent || true
rm -f -- "$sock"

# config ssh for using git agent's socket
git config --local core.sshCommand "ssh -o 'IdentityAgent=$sock' -F $script_dir/ssh_config"

# start ssh agent with defined socket and add deploy 8hr expiry key
# will prompt for passphrase if key is encrypted
eval "$(ssh-agent -a "$sock" -s)" && ssh-add -t 8h "$HOME/.ssh/github_deploy"