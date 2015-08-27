#================================================================
# Tmux session handler (sessions defined in ~/.tmux/)
#================================================================
#tmux
    #create a new client and point it to session
    rsc () {
        #make a new session name from argument
        [[ -z "$1" ]] && local sesn="$HOSTNAME" || local sesn="$1";
        local clid="$sesn~$(date +%S)";
        #create a new session and point it the target session
        #that way both sessions dont have to see the same screen
        tmux new-session -d -t $sesn -s $clid \; set-option destroy-unattached on  \; attach-session -t $clid;
    }

    #create a new session and pass it to rsc
    tmsc () {
        # if  $1 = ls
        [[ "$1" == "ls" ]] && (
            echo -e "\nRunning Sessions:";
            tmux ls;
            [[ -d ~/.tmux/ ]] && echo -e "\nAvailable Sessions: " && ls ~/.tmux/;
        ) && return;

        #if no sessionname given, default is hostname
        [[ -z "$1" ]] && local sesn="$HOSTNAME" || local sesn="$1"
        #if no session with that name exists, it will be created
        [[ $(tmux -q has-session -t "$sesn" && echo 1) ]] || (
            # if session file exists, use it else create a named session
            [[ -f ~/.tmux/$sesn.sh   ]] && $SHELL ~/.tmux/$sesn.sh;
            [[ ! -f ~/.tmux/$sesn.sh ]] && tmux new-session -d -s $sesn;
        )
        #connect to session
        rsc $sesn;
    }

    # load session from file and attach it, (however don't create a new session to point at it)
    tses () {
        [[ -d ~/.tmux ]] || mkdir -p ~/.tmux/;
        [[ -z "$1" || "$1" == "ls" ]] && (
            echo "Usage: tses \$session";
            echo -e "\nRunning Sessions:";
            tmux ls;
            echo -e "\nAvailable sessions: (~/.tmux/)"
            [[ -d ~/.tmux/ ]] && ls ~/.tmux/ && return;
        );
        if  [ ! -z "$1" ] && [ -e ~/.tmux/$1.sh ]; then
            #check if already created
            [[ $(tmux -q has-session -t "$1" && echo 1) ]] || (
                #load session
                $SHELL ~/.tmux/$1.sh;
            )
            #attach it
            tmux attach -t $1;
        fi;
    }