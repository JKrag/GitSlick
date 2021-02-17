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

1) Even chat in multiple workspaces at once. Just open multiple terminal windows and chat in different cloned chat repos.
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

Maybe slightly in order of importance - but not necessarily order of implementation. I am doing this 95% for fun, so features will get added if, where and when I feel inspired:

* [Support sending file attachments](https://github.com/JKrag/GitSlick/issues/1). 
* [Dockerize the chat runtime](https://github.com/JKrag/GitSlick/issues/3)
* [Private message support, just for the fun of it](https://github.com/JKrag/GitSlick/issues/4)
* [Support running in split-screen terminal](https://github.com/JKrag/GitSlick/issues/5)
* [Add a run-mode where chat takes place under the hood in an existing repo](https://github.com/JKrag/GitSlick/issues/6)
* I had the idea that it might be a good idea with a small safety check to avoid running chat.sh in the wrong repo. My initial thought was that it could be as simple as checking for the existance of a possibly empty `.gitslick` file in the root of the repo, and aborting f this doesn't exist. But writing this, I realise that it would either have to be an untracked file, or it would have to be copied over and added to each new branch. maybe it could look for this file in the .git folder? More thinking needed.

## Docker

In case you want chat without cloning the chat repo locally, and without leaving too many traces on your computer,
you acn run the whoe thing in Docker.

### Build image

```
docker to build -t gitslick .
``` 

### Run image

```
docker run -it -v ~/.ssh:/tmp/.ssh:ro gitslick -r git@github.com:JKrag/demo.git -e "jankrag@gmail.com" -n "Whale Hail"
```
