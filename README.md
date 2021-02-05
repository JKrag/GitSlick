# GitSlick
The miniature single-file Git based chat client 

GitSlick is a simple chat client, in a single bash file, that transfers commit messages via a Git server.

I created GitSlcik mostly for sending messages to myself from one machine to another, mostly for use
on e.g. customer machines where I can't use our own company Slack, and may be limited in what other tools
I can install.

GitSlick only requires a terminal, bash and a reasonably new Git (> 2.27 I would guess), which should never 
be a problem anywhere I work.

DISCLAIMER: This is VERY bare-bones with very little error handling or safety features. I am assuming you are qualified to understand how this tool works. I strongly suggest reading the entire script. The tool WILL make commits to whatever Git repo you are currently in when you run it, and try to push them, even if it is your production source code or a very public Open Source Repo that you happen to have push rights to. Consider yourself warned.

## Using
Clone this repo, or simply download the chat.sh file, place it somewhere reachable on your machine and make it executable.  

Create a Git repo somewhere that is reachable for all participants. It could be a private repo on GitHub, or
just a local git server on a machine at home if you are only chatting with yourself.
This will be your "chat server".

Clone this repo to your machine, using credentials that have push rights. (I personally prefer ssh).

cd into this chat directory, and start up chat.sh (from your PATH if you have made that choice, or e.g. `../chat.sh`).

The tool prints out initial instructions for you to read, so please do that :-)

Every chat message is an empty commit to the repo, and is immediately pushed to the remote. There is no async refresh, but every time you type something (a slash command or a message), it will fetch and print any incomming messages. Just pressing `<enter>` counts as a NO-OP that just fetches latest messages.  