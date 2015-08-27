#!/bin/bash

sessionPWD="/home/$USER/";
sessionName="new-session"; #must be same as filename
#check if already created
cd ${sessionPWD};
#create SESSION
tmux new-session -s ${sessionName} -n vim -d
#first window  1: vim
tmux send-keys -t ${sessionName} 'vim' C-m
#second window 2: git
tmux new-window -n 'git' -t ${sessionName}
tmux send-keys -t ${sessionName}:2 'git status' C-m
#second window 3: ranger
tmux new-window -n 'ranger' -t ${sessionName}
tmux send-keys -t ${sessionName}:3 'ranger' C-m

# Start out on the first window when we attach
tmux select-window -t ${sessionName}:2
# tmux attach -t ${sessionName} #handled by rsc