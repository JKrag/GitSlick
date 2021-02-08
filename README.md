# GitSlick

The miniature single-file Git based chat client.

*GitSlick* is a simple chat client, in a single bash file, that transfers commit messages via a Git server.

I created *GitSlick* mostly for sending messages to myself from one machine to another, mostly for use
on e.g. customer machines where I can't use our own company Slack, and may be limited in what other tools
I can install.

*GitSlick* is (nearly) buzzword compliant:

* Multi-channel
* Multi-user / Multi-identity
* Multi-workspace (*1)
* Asynchronous
* Supports slash commands
* Cryptographically encoded message history
* Encrypted transfer (e.g. ssh or https). (*2)
* 100% free of *Electron* (not Electrons though) and other heavy frameworks
* Cross-platform (*3)
* Vendor independent (*4)

1) Even chat in multiple workspaces at once. Just open multiple terminal windows nd chat in different cloned chat repos.
2) I could have made it end-2-end encrypted, but have chosen not to, for now, as I find it valuable to have the chat history readable in the remote Git server web-ui.
3) *GitSlick* only requires a terminal, bash and a reasonably new Git (> 2.27 I would guess), which should never be a problem anywhere I work.
4) Any Git Server accessible by all clients will do.

## STRONG DISCLAIMER

This is VERY bare-bones with very little error handling or safety features. I am assuming you are qualified to understand how this tool works.
I strongly suggest reading the entire script. (It might even teach you a few Git tricks yo make it worth your time). The tool WILL make commits to whatever Git repo you are currently in when you run it, and try to push them, even if it is your production source code or a very public Open Source Repo that you happen to have push rights to. **Consider yourself warned.**

## Using

Clone this repo, or simply download the chat.sh file, place it somewhere reachable on your machine and make it executable.

Create a Git repo somewhere that is reachable for all participants. It could be a private repo on GitHub, or
just a local git server on a machine at home if you are only chatting with yourself.
This will be your "chat server".

Clone that repo to your machine, using credentials that have push rights. (I personally prefer ssh).

cd into this chat directory, and start up chat.sh (from your PATH if you have made that choice, or e.g. `../GitSlick/chat.sh` if you want the *zero-install* option).

The tool prints out initial instructions for you to read, so please do that :-)

Every chat message is an empty commit to the repo, and is immediately pushed to the remote. There is no async refresh, but every time you type something (a slash command or a message), it will fetch and print any incoming messages. Just pressing `<enter>` counts as a NO-OP that just fetches latest messages.

## Ideas for the future

In order of importance - but not necessarily order of implementation:

* Support sending file attachments. I am still uncertain about the UX of this. Sending them is probably easy enough, probably just using a slash command, but I still have to figure out a good UX for retreiving files at the other end.
* Support multi-line messages.
* Add Dockerfile that can run the chat. Seems a bit pointless to just Dockerize the tool itself, as you would still need a shell to run it, and thus only avoid installing Git. A more interesting idea could be to make it self-contained in the sense that the Docker container would clone the chat repo internally every time, so it would be self-contained and not leave any residue on the file system once the container is deleted.
* Private message support, just for the fun of it. This would obviously need encryption of some sort to be "private". One simple option is to rely simply on a "shared secret", which would make it multi-people DM friendly. Another, cooler, option would be to use real public/private key encryption.
