git config --local core.sshCommand "ssh -F '$PWD/ssh_config'"

pkill -TERM -u "$(id -u)" -x ssh-agent || true
eval "$(ssh-agent -a "$HOME/.ssh/github-agent.sock" -s)"
ssh-add -t 8h "$HOME/.ssh/github_deploy"