# Workshop introduction to cluster computing



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


## Copying files across ssh


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

The default OS on Helios is somewhat barebones, and certainly scientific utilities and packages for astronomy are not available by default. Some tools are also somewhat outdated. For example, the default Python version,

```
python3 --version
```

is

```
Python 3.6.8
```

(yes, that is bad: Python 3.6 is from 2016 and received no maintenance releases since 2022. Don't use it.)

There luckily is `python3.11`, so use that one.

But most software you'll need that is more up to date can be found in "modules". Modules are like packages that set up your environment to use additional or newer tools. They don't really provide a virtual environment, but they will adjust your `PATH` and `LD_LIBRARY_PATH` so that the utilities from loaded modules precede the system utilities.

You can view available modules with 

```
module available
```

but the subcommands can be abbreviated to the first unique characters:

```
module av
```

You'll see these are grouped; there is one group of OpenHPC modules (the "ohpc" part). One of the more useful modules in there is the "gnu12" module, which will load the GNU veresion 12 toolset of compilers, and other tools compiled with this toolset. (The default gcc compiler version on the OS is 8.5.) There are also modules for specific astronomy use, with "sw-astro" in their name. Note the various anaconda modules, which provide various Python versions. 

Each module has a name, and a specific version after the slash. Some modules have identical names, but different versions; one of these will have a "(D)" behind its name: that is the default module that is loaded if you specify just the name, not name and version.

You can activate a module with

```
module load gnu12
```

and check with

```
which gcc
gcc --version
```

If you now run

```
module av
```

again, you'll set a list of submodules for the "gnu12" module: these are tools compiled with the GNU 12 toolset. So sometimes, you have to dig a level deeper to find your specific module. For example, to use OpenMPI 4, that is now available, with "gnu12" loaded. You still have to load the "openmpi4" module explicitly:

```
module load openmpi4
```

To see all loaded modules, use

```
module list
```


To remove a module, unload it:

```
module unload openmpi4
module unload gnu12
```

but to remove all modules, you can "purge" them:

```
module purge
```

and you can see that `gcc` is back to the old 8.5 version. `module list` will be empty.

Purging modules is a good thing to do in script, to ensure you start a script with a clean slate. You would then load only your required modules in the script.

For the anaconda modules, these come with some Python packages installed in the base environment:

```
module load anaconda3
conda list
which python
python --version
```

Warning: be aware that unloading the anaconda module does not get rid of the conda environment. Instead, you will first have to run `conda deactivate`, and then unload or purge the anaconda module.

As to the anaconda modules: I recommended to avoid them, and use the system's Python 3.11 instead, and set up a virtual environment with that Python where you install all the necessary packages. 


Finally, if you are looking for a specific module, you can use the spider command, with the `-r` (recurse) flag and a bit of regular expressions:

```
module -r spider '.*mpi.*'
```

(the `*` are not wildcard, but part of the `.*` regular expression: any number (`*`) of any character (`.`)).

This will also list any prerequisite module to be loaded first in the chain.


More module subcommands can be viewedd with a simple `module help`.


# SLURM: cluster control

SLURM, the Simple Linux Utility for Resource Management, is a job scheduler, useful for clusters. It can handle multiple users wanting to run various programs on a cluster, or any machine really, while keeping track of memory and CPU use, as well as doing some bookkeeping in case there are limits to the number of CPU hours for a user. Another similar utility is TORQUE (Terascale Open-source Resource and Queue Manager), but most clusters I have encountered use SLURM. Since Helios uses SLURM, that is the obvious choice for this workshop to show.

To get started, see what is available with `sinfo` (all SLURM commands start with an `s`):

```
sinfo
```

shows

```
PARTITION    AVAIL  TIMELIMIT  NODES  STATE NODELIST
short           up    2:00:00      1   idle helios-cn019
all*            up 14-00:00:0      2  drain helios-cn[013,017]
all*            up 14-00:00:0      8    mix helios-cn[001-002,004,006,014-016,018]
all*            up 14-00:00:0      8   idle helios-cn[003,005,007-012]
neutron-star    up 31-00:00:0     13    mix helios-cn[023-035]
neutron-star    up 31-00:00:0      7   idle helios-cn[020-022,036-039]
astera          up 31-00:00:0      3    mix helios-cn[040,042-043]
astera          up 31-00:00:0      1   idle helios-cn041
```

On the right, the nodelist, shows the various compute nodes ("helios-cnxyz"), where computations can be done. These are grouped into partitions, which limit the access for users: the "all*" partition is available for everyone, but some groups have their own partitions. Note the "short" partition, which has only one compute node and is for running compute jobs that take up to two hours maximum. The timelimit shows what is allowed for one continuous job: 2 hours for the short partition, two weeks for the all partition, and one month for the other two partition.

For some details, the short and all compute nodes are AMD EPYC processors, two per node, each containing 24 cores (and thus 48 threads with hyperthreading; but see the note below). So each node has 48 cores or 96 threads. Each of these nodes has a total of 256 GB memory available.

Note: threads, used with hyperthreading, are often twice the amount of actual cores available. For processes that don't use a CPU core 100% of the time, that is fine: another process can then alternate with this process. For pure computations, provided these are efficiently programmed, a single process will use a CPU core 100% of the time, and hyperthreading is of no use, and would even be detrimental to the whole computation. So for such programs, only use as many physical cores as are available on a node (48 for short and all), not the number of threads. Simulations and similar will use this. For data reductions, where there may be I/O overhead with reading and writing to disk, it *may* be possible to schedule more processes than available cores, but check carefully beforehand (in part, this can be done on your local machine).


To view currently processes, you use `squeue`. That will show a list of currently running or pending processes. The "jobid" is useful if you need to stop your job early, while "name" is a name you can give yourself to a SLURM job. The partition and the machines used are also shown, and the time the process has been running. Perhaps most interesting is the status, "ST", which can be "R", running; "PD", pending (SLURM will try and run your job once compute space is available), "CG", completing, "CA", cancelled, "S", suspended, "TO", timeout (perhaps on the short partition), and "F", failed. A list of all status codes can be found in the `squeue` man-page, `man squeue` (towards the bottom), if you ever encounter a unknown status code.

## Running a first test job

Firstly, before you run a compute job on Helios, test it (with small inputs, obviously) on a local machine, so you know exactly how it behaves and what setup (environment) you need.

For a first test job, we create a very simple shell script, that only requires one core, `test1.sh`:

```
#!/bin/bash

# Produce some standard output
echo "Starting a test script"

# Produce some standard error
ls nonexistent.txt

# Do some processing
sleep 10

# Done!
echo "Finished"
```

You can test this script locally, or even on the head node (as it doesn't really require compute power), with `bash test1.sh`.


To run it through SLURM, we have to write an sbatch script (a SLURM batch script), that gives SLURM some extra information to handle your compute job properly. Write the following script, `test1.sbatch`:

```
#!/bin/bash

#SBATCH --job-name test1

srun bash test1.sh
```

Note that this is essentially a bash script, with a special SLURM directive, `#SBATCH`, that passes extra information to SLURM. In this case, we only give it a job name. 

The last line executes our actual program. The `srun` is strongly advised, and necessary for multithreaded programs: it helps SLURM handle the requirements of your script properly, and also lets SLURM do some bookkeeping afterwards (e.g., how much memory and CPU core time your script has used).

To submit the job to the queue, use

```
sbatch test1.sbatch
```

and check the queue with `squeue`. You should see it pending or running, and after some 10 seconds, it will not show up in the queue anymore. Since there may be multiple people running the same script, you can use `squeue --me` to view only your processes.


Once your job is finished, you'll find a `slurm-xyz.out` file in your directory. This contains the output from your script, both standard output and standard error; conveniently, the job ID of the (completed) program has been added to the name. Of course, actual output should be written from the program itself to specific files (data files, CSV files, etc). In that file, you'll find the expected messages:

```
Starting a test script
ls: cannot access 'nonexistent.txt': No such file or directory
Finished
```

## Getting information about your job

With the job ID from the queue or from the output file, let's have a look at what our program actually required:

```
seff 12345
```

shows something like

```
Job ID: 12345
Cluster: linux
User/Group: <USER>/domain users
State: COMPLETED (exit code 0)
Nodes: 1
Cores per node: 2
CPU Utilized: 00:00:00
CPU Efficiency: 0.00% of 00:00:22 core-walltime
Job Wall-clock time: 00:00:11
Memory Utilized: 11.33 MB
Memory Efficiency: 11.33% of 100.00 MB
```

This gives us an idea of the CPU usage (we already knew that was 1 core, and little usage), but perhaps more interestingly, the amount of memory required: about 11 MB.


## Adding extra SBATCH info

We'll add some extra useful information for SLURM to our sbatch script:

```
#!/bin/bash

#SBATCH --job-name test1

# Use the short partition.
#SBATCH --partition short

# Explicitly request only one node
#SBATCH -N 1
# If you set the above, use --tasks-per-node to be explicit
# about the number of cores/threads you want
#SBATCH --tasks-per-node 1

# Separate stderr and stdout. %j is the job ID
#SBATCH -o slurm-%j.out
#SBATCH -e slurm-%j.err

# Limit the amount of memory
#SBATCH --mem 20MB

# Maximum allowed time (in case your program may get stuck)
#SBATCH --time 00:00:30

srun bash test1.sh
```

Note: an `=` sign is optional between the option and the value.

If you check `seff <job-id>` afterwards, you'll notice that the memory efficiency has gone up quite a bit: obviously a good thing.



