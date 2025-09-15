# Workshop itnroduction to cluster computing



Cluster computing is mainly useful when you have software that can run massively parallel. A single core on a cluster machine is generally slower than on your personal machine, but once you can run hundreds of processes in parallel (not necessarily completely indepent, some exchange between steps is possible and usually essential), a cluster will beat any standard laptop or desktop.

You can distinguish between CPU and GPU clusters (there are so more specific variants as well): CPU clusters are more flexible with regards to computations executed; GPU clusters tend to use more straightforward compuations. GPU clusters often have lower precision as well; there are 64 bit floating point precision (usually required for e.g. astrophysical or climate simulations) GPUs as well, but these can run less processes in parallel. GPUs also tend to overall slower than a CPU, but can handle even more processes (provided memory throughput doesn't become a bottleneck).

Here, we'll focus on the basics of running programs on a CPU cluster.


## Setting up ssh


Most clusters are accessed over ssh, secure shell access, which allows remote working through a terminal (which is far more efficient, and easier to setup and maintain, than through a graphical user interface).

While you can log in to a remote machine with a username and password, using ssh keys is the standard nowayds: you log in once with a password, copy the key file contents to the other machine in a specific file, and then you can use the key to ssh any next session, without using your password.


To set up ssh key access  on your own machine, the following steps are needed

- start a (macOS or Linux) terminal

- Change to the `.ssh/` directory in your home directory: `cd ~/.ssh`.

  If you don't have that directory, make it first: `mkdir ~/.ssh`, then `cd ~/.ssh`.

- Check what's already avaiable with ls`.

- If you see files with a `.pub` extension, you are probably already set. This is likely a file like `id_ed25519.pub` or `id_rsa.pub`. There should also then be a matching file without the `.pub` extension.

  These files are so-called "ssh key" files: they contain a public (the `.pub` file) and a private key (the matching file). The private key should never be shared to anyone (and you should never have to copy it either; it stays on your machine only); the public key can be handed out to anyone anywhere, if so wanted.

  If you have these files, you should be good to go, and can skip to the next section.

  Bonus: "ed25519" stands for the Edwards variant of a elliptic curve number 25519. Elliptic curves are useful in cryptography, as it's very easy to calculate them one way, but reverse engineering them takes ages. RSA stands for Rivest–Shamir–Adleman, the authors who published the algorithm in 1977. ed25519 is newer (and generally better) than RSA, but some older machines can't use ed25519.


### Creating a private-public ssh key pair

- To create these, use the `ssh-keygen` command. You can probably the defaults. Start it from the `~/.ssh/` directory:

```
  ssh-keygen
```

  which should ask you for a file to store the key in (the default is probably fine), then for a passphrase. Pick something unique you can remember, then confirm the passphrase in the next step.

  You should now have your ssh key. You can peek into the public key file: `cat id_ed25519.pub` for example. It will the encryption, then the public key, then your username with your computer's name (if you're on wireless, this can a bit of a convoluted name). The last part is to remember what private key this key belongs to: if you copy the public key somewhere else (a cluster machine, but also e.g. GitHub), then this part will tell where its private counterpart can be found.

- Your private key is now set up, but it has a password. This password is, like your key, local to your machine (unlike your, for example, your Helios account), so in that sense it is a bit safer to have this alternative password. Still, it will be annoying to type your ssh key password each time the key is used. Let's fix that.

### Using ssh-agent to handle your ssh-key password

- Check if the `ssh-agent` program is running, with `echo $SSH_AGENT_SOCK`.  `ssh-agent` is a little commandline keychain program that can keep your ssh-key passwords in memory.

- If the variable is empty or does not exist, start the `ssh-agent` program, as follows:

```
eval "$(ssh-agent -s)"
```

- If the program wasn't running, you probably need to add it to your `~/.bash_profile` (if you are using bash shell), or to `~/.zprofile` (for zsh users). You can check your shell with `echo $SHELL`.

  Add the following lines to the proper profile file:

```
if [ -z "$SSH_AUTH_SOCK" ] ; then
  eval `ssh-agent -s`
fi
```

  This will store your password for your ssh-key during your terminal (shell) session on the local side. That is, you enter your password one time when you login to a machine, then any next time, it is remembered thanks to ssh-agent. Only after a reboot will you need to re-enter your password for an ssh session.


### Setting up the ssh configuration

- Now, still in the `~/.ssh` directory, open the `config` file with your favourite text editor (nano, vi, emacs, kate, gedit, VS Code). If it doesn't exist, create a new one.

  Add the following section

```
host helios
     HostName helios-h0.science.uva.nl
     User <username>
     IdentityFile ~/.ssh/id_ed25519
```

  The indentation is important, but it can also be 2 spaces, or even tabs. Justk eep it equal for all fields.

  If you are not using Helios, change the `HostName` to the IP address of the demonstration machine.

  `<username>` should match the username on the *cluster* machine. And the identity file should match your *private* key.

  The above setup creates a convenient shortcut for accessing Helios: there is an alias for the full machine name, your username on that machine will automatically be matched with that helios, and it will use the given private-public key.

### Add your public key to Helios

- We do still need to copy the public key to Helios. This is the one time we access Helios with the normal password, that is, the password belonging to your Helios account.

  Log in with just `ssh helios` (thanks to the `~/.ssh/config` entry), and enter your password.

  The very first time you log in, ssh may point out that it doesn't know this host. If you trust that that this is Helios (that is, you typed the name correctly in the config section), press <enter> for yes and proceed. This should only happen once, before you enter your password.

  Once you are on Helios, create (if it doesn't exist) a `~/.ssh` directory (`mkdir -p ~/.ssh`) and enter it, `cd ~/.ssh`.

  Now create or open a `authorized_keys` file, and add one line to it: the line from your public key. You probably need a local text editor like `nano` or `pico` (you can't use VS Code here, since we are working remotely; not yet anyway). Save and exit.

  Or you can do it on the command line as follows:

```
echo "<that whole line from your public key file>" >> ~/.ssh/authorized_keys
```

  (mind the double quotes; you need them because of the spaces in the line. `>>` appends to a file if it already exists.)

  Lastly, check the permission of that file and the `~/.ssh` directory: everything should be read/write only for you (and executable for a directory). `chmod 600 authorized_keys` and `chmod 700 .` will do that if executed from the `~./.ssh` directory. `ls -la` should look somewhat like this:

```
drwx--s---+  2 <user> api-helios-unix-fnwi   19 Sep 15 15:47 .
drwx--S---+ 49 <user> api-helios-unix-fnwi  124 Sep 15 15:53 ..
-rw-------+  1 <user> api-helios-unix-fnwi 1038 Sep 15 15:47 authorized_keys
```

  file sizes may differ, as well the `<user>` part, but the permission on the left should look similar to that. (Ignore the s & S permissions, which are certain group permissions that are not important in this context.) Double check that the `.` directory is executable (the difference between 6 and 7 in the `chmod` command).

  Once done, you can log out of Helios, by typing `logout` or pressing `control-d`.

- Back on your local machine, in the `.ssh` directory, also ensure your files are only readable and writeable by (even if you're the only user on the system). In the `~/.ssh/` directory: `chmod 600 config`, `chmod 600 id_ed25519*` and `chmod 700 .`.

  There may also be a known_hosts file: this is where the special identifier key for Helios is stored. You can also change this file permissions if you want. There is a chance that if Helios gets upgraded (or completely replaced), this key changes, and ssh refuses to connect. The only way out is to edit the `known_hosts` file, remove or comment-out the line for Helios and save the file, ssh into Helios, and accept the new host key. This happens rarely though.


## Editing files over ssh

Many editors allow you to edit files over ssh. That is, you run the editor on your local machine, but the file being edited is, for example, on Helios. With our ssh setup, this is now largely automatic (assuming you have already entered your ssh-key password once during the terminal session).

*Important note*: the machine that you log in to for Helios, the so-called head node, is not really meant for (continuously) editing. It is mainly to log in, manage your cluster jobs, and edit some simple scripts and configuration files. It is strongly advised to do all the editing (and testing) on your local machine, and once you're satisfied, copy the files over and run your software on the cluster.

Generally, it can be just as easy to edit a small file with `nano` or `Vi` (once you know how to exit `Vi`), or even `emacs` (once you know how to exit Emacs in terminal mode).

For remote editing, I know of the following editors that support this:

- Vi / Vim: start it with `vi scp://helios///home/user/path/to/file.txt`. Replace `user` with your username. Thanks to the ssh config file, we can just use `helios` as an alias. Otherwise, we would have needed `scp://user@helios-h0.science.uva.nl//...`. Note the two occurrences of double slashes

- Emacs: from within emacs, open a file (control-x control-f) with `/ssh:helios:/path/to/file.txt` (this is called TRAMP mode). Again, we can use the `helios` alias from the ssh config file.

- VS Code: Install the Remote-SSH extension. Once you have the extension, from the command palette, search "Remote-SSH: Connect to Host" and enter "helios". Once this connection is established, you can edit files remotely.

  Be aware that VS Code installs a small utility program that helps with the editing on the remote side, and you can often end up with multiple of these helper programs on the remote host. I'm not even sure if these go away once you explicitly close the connection on the VS Code side, so occasionally, perhaps kill these programs yourself once your done editing (you can find them with `ps -fu <username>` | grep vscode-server`).


## Ssh tunneling

For some purposes, you may want to run a notebook on Helios. *This should not be done for computing; only for quick inspecting.*

Generally, it's a bad idea to start a notebook server and a browser from Helios, and then forward it all to your local machine (on macOS, you would even need to install XQuartz). Instead, it is far more lightweight if you can run the notebook server on Helios, but view and work in your browser. For this, you can use an ssh tunnel; also known as port forwarding.

Ssh tunnels have more uses, but this is one common to usage I have seen with Helios. Again, just beware of how much you do with it: don't run heavy computations through a notebook (this includes an endless run of Matplotlib images from your data: creating images is also compute intensive).

- In a terminal, start an ssh tunnel, with

```
ssh -NfL 8088:localhost:8088 helios
```

This will forward port 8088 on Helios to your machine (localhost) (ports are specific access points for ssh; each process has an individual port).

The `-f` option puts this ssh connection in the background, the `-N` option means to not execute the command in the remote shell, and the `-L` option sets the actual forwarding.

You'll get the usual greeting from Helios, but you remain on your local machine.

Now, ssh into Helios normally.

There is no (Jupyter) notebook by default on Helios, so we will use one that comes with a Conda installation. Load the corresponding module (modules are discussed below):

```
module load anaconda3
```

and check that Jupyter is available: `which jupyter`.

Now, start the server, but without the browser, and with the port specified as above:

```
jupyter lab --no-browser --port 8088
```

(you can use `notebook` instead of `lab` if you prefer.)

Once that is running, in the browser on your *local* machine, click one of the two links that appears in the terminal, or copy-paste it into the browser on your *local* machine. And you'll have a Jupyter session running remotely, but with a local interface. Much faster and more convenient!

You can shut down the server from within the notebook, or just `control-c` the job in the terminal.

If you log out from Helios, the ssh tunnel is still around (it will stop once you quit your local terminal application), but you can find it with `ps uax | grep ssh` and then use `kill` to quit it.


# Modules
