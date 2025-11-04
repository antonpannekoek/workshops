Introduction to the Linux shell
===============================

Note: this is a first version, and there may be all kinds of errors. Hopefully nothing too disastrous (a bad `rm` command would be), but typos or inconsistencies may appear here and there. Please let me know if you spot any mistakes.


Notation and terminology in this document
-----------------------------------------

Text between back-quotes, `like this`, are commands you have to type, or output from the shell. This may not always be done; context should indicate what it is. (Note: the back-quotes may not show, if the text is rendered through e.g. Markdown. But the style of the text will change.

Items that should be filled in with an appropriate value, such as a suitable file name, are surrounding by angled brackets, `<like so>`, or `<filename>`; it may also indicate a special key, e.g. `<tab>` or `<control>`. If the value is optional, it may be surrounded by square brackets, `[like this]`.

- OS: operating system

- GUI: graphical user interface

- Unix (plural: Unices): the operating system after which Linux is modelled, with roots in the late '60s and early '70s. Multiple variants of Unix existed in the '80s and '90s, but Linux popularity has pushed most of those away. macOS derives from a Unix variant called BSD (Berkely Software Distribution), which in itself has several variants (freeBSD, openBSD, netBSD, among others). BSD and macOS are closely related to Linux, but differ in some way.

  Unix or Unices is often used to denote Linux and macOS (and others), to distinguish from e.g. Windows or the classic Mac operating systems.


Setup
-----

You'll need a terminal program. If you are on Linux or macOS, there is one already installed. On macOS, this is the Terminal application. On Linux, this depends on your flavour of Linux and desktop, but its icon will probably look like a black square, and its name probably contains "terminal" (exception: the Konsole program). On Linux, the keyboard combination control-alt-t will often start a terminal.

### Windows

On Windows, there is a default terminal, but that is not a Unix-like terminal, so avoid this. The best solution to use a Linux-style terminal that I'm aware of, is to install two programs:

- the Windows Subsystem for Linux, WSL: https://learn.microsoft.com/en-us/windows/wsl/install

- the Windows Terminal: https://learn.microsoft.com/en-us/windows/terminal/install

If you install them in this order, the Windows Terminal can likely detect (and start, in the background) the WSL once you select it from the tab menu. You now have a fully working Linux shell running under Windows.



Why use the shell / command line?
---------------------------------

* Reproducible

  I can copy-paste commands, put them in a text file, and re-use them later, or send them to someone else. For a GUI (graphical user interface), I'll need to write down exactly what buttons to click, or create a screen-recording.

* Scripting / automating  (closely related to the previous point)

  I can write a shell script (a series of commands in a file) and execute it, which will be faster than manually clicking some buttons several times. GUIs are much harder to automate than a series of shell commands

* Less data traffic

  (More and more a thing of the past). If you have to work remotely, from your laptop on a different machine across the internet, that other machine may not have a matching OS for GUI use, and it may be a slow network connection. In the latter case, typing in a shell costs you one byte per character typed, instead of 2 million pixels with 3 byte color pixels streamed every 1/30 of a second or so.

* Faster (touch typist only perhaps): moving a mouse to click an icon or button is perhaps more intuitive, but harder to aim than typing the respective command (exception: touch screen, provided it is flat on the table, i.e. a tablet).

* Often more versatile.

  I can more easily filter out a list of files with `ls data-202506??-cluster[ABC].txt` to get all files for clusters A, B and C produced in June 2025, than I can through a file browser (this may depend on alphabetical ordering of such filenames).

* Why not simply program these things?

  * That is often more cumbersome, slower, and you'd be reinventing a lot of wheels (commands). Not everything can be done in a shell and sometimes needs to be programmed, but for quick file examination and chaining various commands (in a shell script), using the shell is often far more convenient.


What are a terminal, command line, prompt, shell?
-------------------------------------------------

* Terminal: the application that allows you to work with the shell, and the computer, through text commands.

* Command line: quite literal: the line where you type the commands.

* Prompt: an indicator that input is expected, and optionally what kind of input. For example, type `echo "hello` without the closing double quote, type neter, and you'll move to the next line with a different prompt, indicating that you are in the middle of a string with an unclosed double quote (in this particular case, if you happen to use Z-shell, or zsh, the prompt may change to `dquote>` to actually indicate that, dquote meaning double quote. In bash, it's likely a simple `>` instead). (If you just typed `echo "hello`, either enter the double quote to finish the command, or use the key combination "control-c" to cancel the command.)

  Prompts can be modified to your liking, with practical information or just for fanciness. Some programs will do this automatically for you, such as when you are using a Python or Conda/Mamba virtual environment: they will show the environment in the prompt name, so that you know what environment you are using. Options also exist, for example, to show the status of a Git repository.

  For bash, the prompt ends with a `$` sign by default. For zsh, it ends with a `%` by default. If you ever have a prompt ending in a `#`, that would mean you are using the root account, which is generally *not* what you want(!)

  We won't dive into prompt customisation in this tutorial.

* Shell: a program that interprets your commands on the command line before sending them off to the actual computer to be run. It kind-of wraps around your commands, and thus acts as a shell. It also helps making some work on the command line easier (history search or tab-completion can be such things).

  Bash (Bourne-again shell) and zsh (Z-shell) are common shells: bash tends to be the default on Linux, while zsh is the default on macOS. They are very similar, but not exactly. For the most basic commands and editing, they'll be the same, but for more advanced use, including shell scripts (not used in this tutorial), it is good to be aware of which shell you are using.

  Shell behaviour can be heavily customised using special files. They are mentioned here, but otherwise not really explored in this tutorial:

  `.bashrc` in your home directory for bash, and similarly `.zshrc` for zsh. Note the leading dot of these files. (The `rc` part may stand for "run commands", or "run control", or even "resource configuration"; I tend to think of the files as the latter.) Some other related ones are `.bash_profile`, `.profile`, or `.zshenv`. You may not have any of these (you don't need them), but you may come across them. Note that some software may alter your `.bashrc` or `.zshrc` upon installation, to add some configuration of their own, such as the miniconda or micromamba installers. Most of the time, this is done to add a directory to the `PATH` variable; see further below.

* Cursor: where you are typing

  Technically, the cursor is between characters, but it is generally under/over the character in front of which you'll insert text


* Note there is a whole bunch of terminal applications, in different flavours. For Linux, The "Gnome Terminal" and "Konsole" are quite common, while on macOS "Terminal" is the default, but you can, for example, install "iTerm" (which has more options than Terminal). All flavours will work fine for the far majority of usage.

* The prompt is more general than just for a terminal. A program like Python, when executed by itself on the command line, has its down prompt, `>>> `, to indicate it is expecting Python commands (for more modern languages that have a command line prompt, like Julia, it is a bit clear: `julia> `). Be aware of these various usages of prompt, and what prompt you are seeing.

  NB: to exit the Python or Julia prompt, you can use the key combination "control-d". But be aware that control-d can *also* exit your shell (if in a bash or zsh) and that may exit your whole terminal session, losing all information you had in that session.


To determine which shell you are using, you can look at the prompt, but a better way is to print the `SHELL` environment variable, by typing `printenv SHELL`.

Navigating and paths
--------------------

NB: "directory" tends to be the Unix term; folder is often used with file browsers instead.


* commands for navigating

  `pwd`: print working directory
  `ls`: list files in the directory
  `cd <name>`: change to a directory

* Create a directory and change to it:

  ```
  mkdir somedir
  cd somedir
  pwd
  ls
  ```

* For light text editing of files, a simple text editor like `nano` is available.

* create a file with nano and add a few lines. Close, and open the same file on the command line: `nano newfile.txt`.

  (There is also an editor called `pico`, though it may not be installed on your system. Another modern editor is `micro`, which offers a more user-friendly experience.)

* Path:

  * `pwd` to see where we are in our filesystem.

  * `/` is used as directory separator

  * A path that starts with a `/` is an absolute path. Otherwise it is a relative path

    * absolute versus relative paths depend on context what to use. Relative paths tend to be more flexible, to a point. If you are working from another directory than where the files are, absolute paths can be better.

  * note the root directory, `/` . This essentially makes paths absolute

  * special directories:

    `.` means the current directory

    `..` means the parent directory

    `~` (tilde, or twiddle) means your home directory

  * generally, stick to your home directory and subdirectories therein; stay away from other directories, so you don't mess up your system.

  * cd conveniences:

    * `cd` by itself changes to your home directory

    * `cd -` returns to the previous directory. Handy if you switching between directories with long names.

  * Note: different disks (including e.g. USB pen drives), or even different machines, are also reached through paths, and from the root directory. For example, through the `/mnt/` directory, or `/media/`, or (on Helios), through `/zfs/helios/` (which leads to the storage machines).

    This is different than on Windows, where these show up with a drive letter (old style), or some network device. macOS also hides this in the Finder, as do file browsers on Linux, but here you can find them in the terminal directly as a directory. For example, a USB pen drive on macOS is available (once plugged in and mounted) at `/Volumes/`.

* From our current working directory `somedir`, the following all results in the same:

  ```
  cd ..
  cd ~
  cd ~<your-username>
  cd
  ```

  Change back to `somedir` with `cd -`.


* Your home directory is probably something like `/home/<username>` on Linux, and `/Users/<username>` on macOS.

* A side note on `mkdir`: it can create only one level of a directory; if you want to create a directory and one or more subdirectories in one go, use the `-p` option, for example: `mkdir -p somedir/subdir/subsubdir`. Also, `mkdir` will give an error when you try to create a directory that already exists; the `-p` option will also ignore any existing directories, that is, not give an error. This is why you'll often see mkdir with the `-p` option.

Some differences between Linux and macOS
----------------------------------------

* be warned: Linux is case sensitive, macOS is case "preserving", Windows is case insensitive.

  * ls may or may not be case sensitive for its default sorting. This depends on the so-called "locale"; outside of scope

  * never rely on sorting of files, unless explicitly done (e.g., with ls -t, or the sort command)

    Also holds when programming: always explicitly sort

    This has caused errors in scientific articles

  * on Linux, if you create a file with (all) lower case letters, and then create a file with the same name but with one or more letters upper case, they are different. On macOS (and Windows), the second file will overwrite the first file. This has caused problems in the past, for example when people copied files from Linux to macOS (example: C source code are generally ended with `.c`, and historically, some people named their C++ source code files ending with `.C`. That works on Linux (and some other Unices), but caused issues on macOS or Windows).

    *Never* distinguish files or directories by the case of the letters.

  * While a habit by some, there is no need for directory names to start with a capital. This has become a convention (on Linux and macOS) for directories in your home directory, such as `Documents` and `Downloads`. Of course, don't change the names of these files (other parts of your system may become slightly upset by such changes), but your own directories can be all lowercase, all uppercase or just start with a capital.

  * Historically, important files tend to use all upper case, since that would put them at the top in a listing (a `README` file is a prime example of this, as are `INSTALL` files). There are many (awkward) naming conventions this way.


* several commands differ slightly in their usage. Sometimes in their output, often in the optional arguments (option) they can take. This, unfortunately, doesn't make things fully compatible between the two OSes, and a specific command for Linux may not run properly on macOS. It is rare, but does happen.


Note on copy-paste in the terminal
----------------------------------

Control-c, control-v and control-x don't work as normal in a terminal, since these are reserved key-combinations for the shell (nor does control-z, undo). For copying, pasting and cutting in a terminal, use shift-control-c, shift-control-v and shift-control-x.


Exploring ls and files
-----------------------

* `ls -l`

  The `-l` option indicates a long listing. You see extra information about the file. The first column, with items `-rw-r--r--` and `drwxr-xr-x`, indicates permissions; more on those later. The two name columns are the user and the group to whom the file belongs (group is less important on single-user machines). The next column is the size in bytes. Then the date and timestamp, and then the file name.

  Use `ls -h` for human-readable sizes; combine the options: `ls -lh`.

* Further options to ls

  * -F: file types (directories appended with /)

  * -a: all files, also hidden

  * -t: sort by time

  * -r: reverse sorting (most practical in combination with `-t`: shows the most recent file last / at the bottom of the list).

* Quick explanation of arguments and options

  * arguments: anything after the command

  * options: optional arguments. Generally preceded with a `-`

    * sometimes options take their own arguments (mostly just one). For example, `head -n2` shows the first two lines of a (text) file, whereas the default without the `-n` option, shows the first ten lines.

    * short and long options: `-` followed by a single letter is short, while `--` followed by a "word" is long.

    * short options can be combined, provided none of them (or only the last one) takes an argument. E.g., `ls -haltr`.

    * Some commands (from days past, i.e., archaic) take options without the `-` in front (tar, ps; even more confusingly, sometimes the `-` itself is optional (`tar`) or using it changes the meaning somewhat `ps aux / ps -aux`; `ps` is just weird); or commands use a single `-` for a long option (the `find` command, with options like `-name`, `-type`, `-print` etc).



* `cat newfile.txt`

  cat for concatenate, but also lists (dumps) a file to the terminal (use your nano-created file)

* notes on filenames:

  - extensions are useful, but technically, they can be ignored (but some programs are picky about extensions, and do require them).

    They are mostly a quick indicator for humans. Extensions are also very practical for sorting files by their extension.

    Use them, but don't rely on them fully.

    Executable files (that is, programs), don't need a `.exe` or `.bin` extension either, and by default they don't have an extension. This is why the programs are `git` and `python`, not `git.exe` and `python.exe` (nor `ls.exe` or `ls.bin`).


  - avoid tricky characters (non-alphanumeric, including accented characters).

    If you have to deal with them: surround them in single quotes or double quotes (on or the other), or escape (backslash) each "tricky" character. Accented characters will usually be fine, but the whole slew of !@#$%^&*()[]{}:;,<>/? are best to be avoided.

    To handle quotes and backslashes as part of a filename: escape them with a backslash: `\\, \", \'`.

    This mainly applies to reading / listing such files, not to creating them yourselves. But tab-completion (see further) helps here!


Copying, renaming, and moving files
-----------------------------------

`cp` copies files; `mv` renames files (or moves a file to another directory). Note that both commands will overwrite the destination file if it already exists, without warning.

```
cp newfile.txt data.txt

mv data.txt data.csv
```

cp and mv also work on directories:

```
mkdir temp

cp data.csv temp

ls temp

mv file.txt temp

ls temp

ls
```

where `cp` and `mv` will copy or move a file if the second argument is an existing directory (ie., `temp`).

`cp` and `mv` can work on multiple files, provided the last argument is a directory: all other (file) arguments will be copied or moved to that directory:

```
cd temp
cp data.csv file.txt ../.
ls
cd ..
ls
```

which copies the two files up a directory.


* copy recursively (directory and contents, including subdirs):

```
  cp -r temp temp2
```


* rm: anything removed is removed permanently!

  * Safer alternative: rename to an obvious "not-used-anymore" name, and only delete (much) later

```
    mv temp temp_aside
```

  * actually deleting things

```
    cd temp2
    ls
    rm output.txt
    rm data.csv
    ls
    cd ..
    rmdir temp2
```

  * to remove a directory and all of contents at once (permanently!)

```
    rm -r temp
```


  * rm has a safety (sometimes, this is set as a default on systems)

    `rm -i` will ask for a confirmation for each file to be deleted.

    Useful when deleting multiple files, and removing completely directories.

    But impractical when deleting 100s of (temporary) files


* download a file

  * curl -O https://raw.githubusercontent.com/antonpannekoek/workshops/refs/heads/main/intro-linux-shell/data/exoplanets.csv.gz

  * wget as alternative; but sometimes not installed, while curl nearly always is: `wget https://raw.githubusercontent.com/antonpannekoek/workshops/refs/heads/main/intro-linux-shell/data/exoplanets.csv.gz` (note: no `-O` flag if you use `wget`).

  * The file is compressed. `.gz` is an alternative to zip. Use `gunzip exoplanets.csv.gz`. Note g(un)zip only compresses single files: it is not a container for multiple compressed files like zip. (More on compression in the extras at the bottom)


  This is a heavily reduced version of the actual exoplanets table from https://exoplanet.eu ; for example, all error columns have been removed.


* cat is too long for this file. Use `head` to view the first 10 (5) lines, `tail` to view the last 10 (5) lines.

```
  head exoplanets.csv
  head -n5 exoplanets.csv
  tail exoplanets.csv
  tail -n5 exoplanets.csv
```

The command `tail -n+5 exoplanets.csv` (with the explicit `+`) shows all lines *beginning* at the fifth line.


* Use `wc`, "word count", to count the number of lines (`-l`) or bytes (`-c`):

```
  wc -l exoplanets.csv
  wc -c exoplanets.csv
```

(the number of bytes is of course also viewed with `ls -l`.)


* pagers: stepping through a text file screen by screen.

  Use `more` or `less`: `less` is more than `more` here (that is, it was developed as an improved `more`), so generally you want to use `less`:

```
  less exoplanets.csv
```

  Keys to use while in pager mode:

  - Use the space bar to page down, `w` to go up, `/<keyword>` to search, `n` to go through search results one by one.

  - Press `q` to quit.

  Note the cursor at the bottom left, preceeded with a colon. If you see this mode elsewhere, that often means a pager like `more` or `less` is being used to show text, and you can use the above keys to navigate. For example, the long `--help` option for `git` subcommands, e.g. `git clone --help`, will put you in pager mode (but not the short variant, `git clone -h`; that shows only a quick help).


* grep: finding a line with a specific word in a file.

  Grep is an amazingly simple but useful tool to find a specific word, or more generally, any string of characters, in a file:

  `grep BEBOP exoplanets.csv`

  will show you the exoplanets results from the BEBOP project.

  Surround words that contain special characters (including spaces) with single quotes, or escape them. `grep 'WTS-2 b' exoplanets.csv`.

  When searching through code, it can be convenient to show lines surrounding your found line. Use the -C option (context), with the number of lines surrounding as argument:

  `grep -C3 'WTS-2 b' exoplanets.csv`

  to show 7 lines (3 before, 3 after, and the matched line itself in the middle.

  Side note: it is more logical to use something like Python's Pandas or a dedicated tool to read and parse a CSV file; but grep applies to any text file, and this is obviously just for demonstration purposes.


* examining files

  `file exoplanets.csv` gives an idea what a file likely is. (It peeks at the first few characters, which often follow some convention per file type.)

  `which <command>` tells you where a command can be found. `type <command>` is also useful. For example, `which git` or `which curl`.

  There is also `type`, which is similar.

  `file` also tells you if a file is binary (like an image file, a FITS file or a HDF-5 file). You don't really want to use cat, head, or tail for these; or open these in a text editor like `nano`!


   If you accidentally do (use `cat` on a binary file), you'll see a lot of awkward characters. If your terminal ends up messed up afterwards, here's a useful follow command (you may have to type it blindly, since the characters would be mixed up):

   `reset`

* aliases

  Sometimes, you may find it useful to provide an "alias" for a specific command, perhaps with specific options set, to save typing / remembering. For example, `ls -larth` can be lls (long listing). You can set an alias like

```
   alias lls='ls -larth'
```

   You can set these in your ~/.bashrc or ~/.zshrc, by simply adding a line like above on its own in one of those files.

   More importantly, some OSes / sysadmins have set up default aliases, which can lead to confusion. So, for example, there may be this alias

   `alias rm='rm -i'`

   which is both safer when removing files, but also more annoying when removing many files.

   More dangerously, if you get used to being asked to delete a file when running `rm`, then this likely will not be the case on other systems where the alias does not exist; and suddenly you may have removed many files without confirmation. So be aware of system-wide aliases.

  `alias` by itself shows you existing aliases. `type <command>` can also tell you if a command is an alias.


Some command line editing
-------------------------

* You can use tab-completion: this will complete a command or filename from a unique part to the next unique part. Try `ls ex` followed by tab to list `exoplanets.csv`. If another file is called `exoplanets.dat`, tab will complete up to the extension. Hit tab twice to see all available options once completion stops (this may depend on your shell).

* warning for the control-d key combination

  * at an empty line: this quits your shell! (logout)

  * If halfway a line: deletes letter under cursor (like <del>)

  * At the end of line: works like tab-completion

  (the quit and delete option of control-d also work for e.g. the Python cmdline interpreter.)

* command line editing keyboard shortcuts / special controls

  type a long line, then:

  - control-a: go to the beginning of the line

  - control-e: go the end of the line

  left/right arrow keys: move the cursor

  control-k: delete to end of line

  control-u: delete whole line

* control-c will cancel a command, either while you are still typing, or when it is executing.

  This is why copy in the terminal is control-shift-c: control-c is much older shortcut than the copy shortcut, and it interrupts currently running programs, which may not be your intention.

  Sometimes, a stuck program will not even respond to the `control-c` interrupt command. But it may still respond to suspending it with `control-z`. In that case, suspend the program, then use `kill %1` or similar to stop it (more on the `kill` command below).


Note: control (the key) is often spelled ctrl, ctl, or even written ^, e.g. ^C (the capital letter just indicates the key, it doesn't require the shift key).



Shell history
-------------

* history

  Use the up-arrow to step through previous commands. You can edit them, or execute them directly again.

  Use control-r to search for part of a previous command. Use control-r multiple times if you have a non-unique search string: it will step through all matching previous commands.


 * `history`

   Has some options, but dependent on shell:

   bash:

     `history 15` shows last 15 commands

   zsh:

     `history -15` shows last 15 commands (interestingly, the `-15` is not so much a option, but more an argument that is a negative number. Dashes can be confusing in their meaning at times).

     `history 15` shows commands from number 15 instead

* select a specific number from the `history` listing and execute it again (no editing beforehand!) by using the exclamation mark followed by the history number:

```
 !631
```

* Beware: some shells also interpret the `!` in the middle of a command / line as a special history commands. If you need an exclamation mark in the middle of a line, prefix it with a backslash to make sure it is not interpreted as something special by the shell. As an example, zsh does this. Let's say I have the following history:

```
...
 1677  echo "hello"
```

So `!1677` runs `echo "hello"` again.

Now I run `echo !1677`, and that outputs:
```
echo echo "hello"
echo hello
```

so the `!1677` is expanded into the `echo` command, and then the actual echo command is run, giving "echo hello" as output. The top line shows the actual command being executed.

I wanted
```
echo \!1677
```

which indeed shows `!1677` as output.




Some process handling
---------------------

* a process is a running command.

* control-c: cancel (interrupt) a current running process

  A process is any command. Most take a fraction of a second (ls, pwd, git, curl), some take longer

```
  $ sleep 10

  control-c
```

`sleep`, pause ("sleeping") for 10 seconds here, is often useful for testing, as a stand-in for long-running processes.)


* control-z: suspend a currently running process

```
  $ sleep 600

  control-z
```

  (note message)

```
  $ jobs
```

(processes are sometimes called jobs; hence the command name to view current processes.)

The process is still there, just not running.

```
  $ fg
```

or more explicitly

```
  $ fg %1
```

brings it back to the foreground. The `%1` refers to the `[1]` in the `jobs` output.

```
  control-z

  $ bg
  $ jobs
  $ ps
```

`ps` shows the process status. In particular, the first column shows the PID, the process identifier. Each process has a unique PID. Since there is a maximum value that PID can be, these numbers are recycled and a later process may end up with a lower PID. Note that `bg` was run without `%1`: it refers to the most recently suspended program.

Note that `jobs` and `ps` list processes in the current shell (or terminal; this may depend on the terminal used); not all processes. The shell or terminal is the parent process of all those processes.

If you have a process that you can't stop with `control-c` from the command line, but you can see it in the `ps` output, use it PID to "kill" the process.

```
  kill <PID>
```

Note that commands like `bg` or `fb` can also take a PID as argument, without any `%` prefix. Similarly, kill can use `%1` to kill a suspended or backgrounded job from the `jobs` output list.


* `ps uax` or `ps -ef`

  list all processes, including those not originating from your terminal. The first column lists the owner of the process; note the root owner. The second column lists the PID. You can only kill processes you own.

  Using `ps` with these options can be useful if you have a hanging process that doesn't quit normally, and you can try to kill it this way. It is somewhat equivalent to using something like a "Activity Monitor" (on macOS) and use a force-quit.

  `ps -efu <username>` will list only processes by that user


* Ending a command with an ampersand, `&`, immediately puts the command in the background:

```
  sleep 600 &
  jobs
```

Be wary when you do this in a (shell for/while) loop for CPU or memory intensive processes: the processes will run simultaneously, eating up CPU resources or memory.


Note on "root" in Unix
----------------------

There are multiple (related) uses of the term "root" in Unix:

- the root directory, `/`, is the bottom (or top) of the directory tree. So the name makes obvious sense, as a full directory listing is a bit like a sprawling tree.

  As mentioned, any file or directory, or external disk or remote computer, is essentially accessible from the root directory, through one of its various subdirectories.

- the root user is the super user, or administrative user, on a system. It is an actual user account called "root", and its home directory is at `/root` on Linux, and `/var/root` on macOS. You don't really want to use those directories, and rarely use the root account.

### sudo

The root user can do anything on your system. If you are on a single-user system, you can login to the root account, likely with your normal or your admin password (depending on how you set up your system), but you want to avoid that: it is too easy to make a mistake as root that destroys part of your OS.

For that reason (and a few others), there is the `sudo` command: super-user do. It is followed by the command you actually want to run as the root / super user, but requires you to type your password first. The `sudo` prefix should mainly be regarded as an extra "are you sure you want to do this" moment.

I mention it here, as lots of guides show the use of `sudo`, sometimes far more than necessary (it has gotten better over time); same for LLMs: if ChatGPT or similar suggests you need to prefix a command with `sudo`, first ask it again if the `sudo` is really necessary.

Note that mutliple uses of `sudo` within a set timespan (say, five minutes or so) only require a password on the first use; this is a convenience setting, but you lose a bit of the "are you sure" moment when you issue sudo commands.


Handling / searching through multiple files
-------------------------------------------

* globbing (wildcards): use special characters that can stand in for zero, one or multiple characters in file names.

  Globbing patterns are handled by the shell, and expanded by the shell *before* passed to the relevant command. Keep this in mind: the command will not see a specific globbing pattern as its argument (unless escaped or quoted)

  The * can mean zero, one or more of any character.

* Make a few simple files ending in `.txt`, e.g. `filea.txt`, `fileb.txt`, `filec.txt`, and a (temporary) directory `newdir`. Or use existing files and alter the commands below appropriately.

  List and copy all text files to `newdir/`.

```
  ls *.txt

  cp *.txt newdir/
```

  Use the following never, or very very rarely and carefully, to remove all files and subdirectories in the current directory: `rm -r *` (do NOT use it for this exercise.)

  (as before: prefer renaming the current directory)

  As a cautionary tale: some installer script by a big company had something similar to  `rm -r *.txt, except that there was an extra space: `rm -r * .txt`. As a bonus, the script worked at root level, wiping whole directories owned by the root (= administrative) user.


  The `?` in a filename means exactly 1 of any character (not 0).

```
  ls file?.txt
```

  Characters between `[]` means any one (only one) of those characters:

```
  ls file[ab].txt
```

  You can even have ranges with a `-` inside a `[]` (it still matches only one character):

```
  ls numbers[0-3].txt

  ls file[a-c].txt
```

  `**` means the current directory, any sub- or subsub (etc) directory. Whether this works depends on your shell, and whether recursive globbing is enabled: For zsh, it is enabled by default; for bash, you may need to enable it first (add a line `shopt -s globstar` in your `~/.bashrc`, or for a one-off, run `shopt -s globstar` on the command line).

```
  ls **/*.txt
```

   matches any text file in the current directory or any of its subdirectories.


* globbing works with other commands as well (if it makes sense at least). Find a specific keyword in any text file:

```
   grep keyword **/*.txt
```

* Just be careful: globbing makes it easier to accidentally overwrite files.

  * Some shells allow you to expand the the pattern before you run the command, using tab: `ls *.py<tab>` may expand to `ls spam.py egg.py bacon.py`.


Random useful commands
----------------------

A few useful commands

* `echo "some text"`

  will write "some text" (without quotes) to the terminal. This is useful in a shell script.

* `touch somefile.txt`

  will create an empty file "somefile.txt". If the file already exists, it updates the timestamp for its last modification to current.

* `df`

  shows the amount of disk space used and free (disk free). Use the `-h` option to get more human-readable output.

* `du`

  shows the disk usage, for this directory and all its subdirectories individually. Use `du -chs` for a (human readable) summary of this directory.

* `time <command>`

  measures the time used for a command. It shows subsecond precision, and usually measures total, but also active (CPU) time. Try for example, `time sleep 3`: the CPU time is 0%, but the total time is 3 seconds. That is a good thing: it shows that `sleep` is using very few CPU resources while being active.

* `clear` (shortcut: `control-l`)

  clears the terminal of current text (you can scroll up to still see it, so it's a bit like an empty page-down).


Redirecting output and input
----------------------------

* You can send output from a command to a file

```
  ls > files.txt
```

  This will actually includes files.txt in files.txt. Use `cat files.txt` to see the contents.

* You can also append output to file

```
  ls >> files.txt
```

* send the contents of a file as input to a command (less used):

```
  grep files < files.txt
```

  Note how grep takes either a file, or input. That is, you could use grep interactively:

```
  grep files
```

  Now type some lines, including one with the word files; use control-d to exit this mode: control-d here indicates "end of file/input".)


* stdin, stdout and stderr

  Unix has the concept of standard input, standard output and standard error. These are "secretly" special files, but refer to input (from the keyboard, basically) or output (to the terminal, mainly). They are usual named stdin, stdout and stderr.

  * stderr is a different output "stream" than stdout. If really needed, use `2> error.txt` to capture that

  In part this is a historical artefact, where errors were printed somewhere else than on the terminal. It is still useful today to separate errors from normal output: if you have a program that produces a lot of output, you would redirect that to a file. But you still want to see (e.g. in the terminal) if an error occurs.

* Redirecting stdout is simple, with the `>` or `>>`. For stderr, you need to prepend a `2`: `ls doesnotexist.txt 2> ls.err`.

  stdout is usually associated with a so-called file descriptor (fd), which has a number: 1. stderr has fd 2. Indeed, `ls 1> files.txt` is the same as `ls > files.txt`.

* If you want to redirect both stdout and stderr, simply use

```
  ls doesnotexist.txt *.txt > files.txt 2> ls.err
```

  (The `*.txt` is necessary to also list existing files and produce something that goes to stdout.)

  I often using an extension like .err or .stderr, but this is not necessary: it is simply (another) text file. For stdout, this is more context dependent: here, `files.txt` makes sense, but `ls.stdout` or `ls.out` is also a decent option.

* You can redirect both stdout and stderr to the same file. This is slightly more cumbersome:

```
  ls doesnotexist.txt *.txt > files.txt 2>&1
```

  The ampersand, `&`, is necessary: otherwise you would be redirecting the stderr to a file named `1`. And no, it doesn't background `ls`, since the `&` isn't the last character.

If you want to append to file, you have the following options:

```
  ls doesnotexist.txt *.txt > files.txt 2>> ls.err

  ls doesnotexist.txt *.txt >> files.txt 2>&1
```


* "but I want to capture *and* view the output!". Use `tee`:

```
  ls | tee output.txt
```

  That is the vertical line, usually located above the backslash on the key above the <enter> key; but on less Western keyboards, it may be somewhere else (e.g., the top-left key, or not even be visible and you'd need to use a special key combination). If you are really lost for special keys: copy-paste can be help for one-off occasions.

  This example leads directly to the topic below: pipes

  The command `tee` owns its name because it acts like the letter T: it gets one input (say, the vertical line), and sends output to both a file (its argument) and stdout.


Chaining commands: pipes
------------------------

You can chain commands together. That is, you can send the output of one command directly as input to another command.

This works particularly well because some commands, like grep, head, or tail, accept a file as well as stdin.

The character `|` is called a "pipe" in Unix terms. And you can use it as a verb as well: you pipe the output of one command into another command. Which makes sense if you think of input and output as water/oil/gas pipes between several applicances or stations.

*
  ```
  head -n20 exoplanets.csv | tail -n5
  ```

  shows lines 15 to 20

*
  ```
  ls -l | sort -nk5
  ```

  Sort output by file size: -k5 is fifth field (white-space separated) which is the filesize column, -n is numerical order

  Variant: `ls -lh | sort -hk5` . Sorts "human-readable", so file size postfixes are taken into account. Note how `sort` also has a `-h` option, but not for the output but to understand the input as "human readable".

*
```
  du -h | sort -h
```

  lists the amount of space used per subdirectory in the current directory (cumulatively), with human-readable prefixes for sizes. `sort` also can take a `-h` option, to handle such prefixes.

*
  ```
  grep refereed exoplanets.csv | sort -t '|' -gk3 | tail -n20
  ```

  Sort all refereed exoplanet findings by their mass, and show the last (heaviest) 20 exoplanets.

  -g is the more generic variant of -n (numeric), to allow for floating point values.

  (Of course, this is the point where you want to use more dedicated software for tabular data.)



The combination of pipes and redirection is one the fundamentals of Unix & friends: it allows chaining small programs together, where each program is optimised for nearly just one job.

A potential lack is that the output of various commands is not really standardised: it is produced in a human-readable format, which can make it challenging to pipe into another command (e.g., `ps` has a header, so you would probably need to discard the first line first to use that output with tail. E.g., `ps | tail -n+1`). `cut` is also helpful here, to cut out a specific column. Here is an example of a rather long chain of piped commands:

```
tail -n+1 exoplanets.csv | cut -d',' -f10 | sort | uniq
```

will grab the tenth column (field: `-f`) of the exoplanets.csv file (minus the header), using the comma as a column delimiter (`-d`), sort it (alphabetically) and use `uniq` to remove consecutive duplicate lines.

You will see that the output is a bit weird. This is because cut doesn't care about CSV fields with double quotes (inside of which a comma isn't a column separator), and as a result, column 10 isn't always column 10. For CSV files, dedicated command line tools or a simple Python program are much better; here, it is merely to demonstrate the use of piping, and potential issues you may run in to.


### Command substitution

You may also need the output of one command as an argument (that is, not input, but command line argument) of another command. In that case, you can use command substitution. This requires the command-to-be-substituted ("inner command") to be surrounded by `$()`, e.g. `$(pwd)`. A silly example would be

```
file $(ls *.txt)
```

to determine the file type of all .txt files. Of course, these would all be "ASCII text" or "Unicode text", and you would simply use `file *.txt`. Often, command substitution is not necessary, and you can use shell utilities like globbing instead.


Environment variables
---------------------

* if you type

```
  env
```

  You'll get a list of capital-cased variables and their values. These are called environment variables ("envvars"), and they influence some programs or how your shell works.

  A few interesting ones:

  * PATH . This is a colon-separated list of directories where your shell will look for commands to execute, so that you don't have to type the full path. There are probably `/usr/bin/`, `/bin/`, `/usr/local/bin` a few similar, which are the most basic directories that you always want to have on your PATH, since these directories contain important commands (check `ls /bin` or `ls /usr/bin`).

   Important to know is that order matters. If you have two commands with the same name, then this command is searched in order of directories listed in your PATH.

  To append a new directory to your PATH, do

  export PATH=$PATH:/new/directory

  The `export` is necessary in case you are using subshells (that is, if you use shells cripts); otherwise a variable set in a resource script such as `~/.bashrc` will not be exported to the shell where the script is run. Note that when you assign, you use `PATH` (the actual name), but when you evaluate (read) the envvar, you prefix it with the dollar sign: `$PATH`.

  * HOME. Your home directory. Don't change this.

  * USER. Your user name. Used by some programs. Don't change this.

  * PWD, OLDPWD. The current and previous directory (`cd -` will use OLDPWD)

  * EDITOR. The default editor. Used by some programs, like git when interactively creating a commit

  * PAGER. The default pager for programs that may produce a lot of output. It probably defaults to less

  * PROMPT. This is the variable you would need to change to modify your prompt. But with the amount of options available, modifying the prompt is a whole workshop in itself.

* Some programs require specific environment variables to be set, often to a directory where their output is stored or their auxiliary programs are located. This is normally mentioned in the (installation) manual. It is similar to setting PATH. Let's say you set the environment variable APIDIR

   export APIDIR=$APIDIR:/where/ever/directory

   The fact that APIDIR didn't initially exist doesn't matter; $APIDIR will just result in an empty string, i.e., nothing.

* You can make these envvar settings more permanent by putting such `export ...` lines in your `~/.bashrc` or `~/.zshrc`.

  Some programs do this for you upon installation (although they often inform or ask you first), e.g., if you are installing miniconda or micromamba.


Scripts
-------

Shell scripting is not dealt with in this introduction (it's long enough as it is); which means you miss out on some conveniences like for loops or if-else statements. But, with the above (and below) set of commands, you can always put these on separate lines in a text file, then run the text file with a simple

```
bash commands.sh
```

This will simply execute the given shell commands in `commands.sh` line by line.

`.sh` or `.bash` is a good extension to use for anything that resembles a shell script; or perhaps `.rc` if it's mostly setting up environment variables.

Note that I prefer to use `bash` here, not `zsh`, as `bash` tends to
be more generally installed on OSes than zsh (but `zsh` is almost
everywhere available, just perhaps not installed).


Extras
------

(section for some useful commands that didn't fit a topic.)


* A semicolon, `;`, separates multiple commands on the same line: `ls *.txt; grep text *.txt` will execute first ls, then grep.

* There is a special "file", `/dev/null`, which works like a black hole: any output from a program redirected to this file will just be absorbed, and nothing shown; the same works for error output (`stderr`), although I don't advice to send errors to `/dev/null`.

Example: `ls > /dev/null` will send the listing of files to `/dev/null`, causing no output to be shown. (To be clear: it is the output of `ls`, the *listing*, that goes to `/dev/null`, not the files themselves.)


### Symbolic links

Files can be aliased: another file, a so-called symbolic link, can point to the actual file (a short term is "symlink". This doesn't take up any space, as it's just an alias for convenience. If you remove a symbolic link, the original file will stay; if you remove the original file instead, you get a "broken" symbolic link.

Symbolic links can serve as a shorthand (alias), and can be in the same directory. But symbolic links can also be in separate directories, allowing for the same file to appear in multiple directories: if you edit the file in one place, the file is changed everywhere. Multiple symlinks for the same file can exist; you can even have symlinks to symlinks.

Directories can also be symlinked, with the same effect. To remove a symlink to a directory, don't use the `-r` option with `rm`: just `rm <my-symlinked-directory>` is enough.

Symbolic links can be seen with `ls -l`: their permission list starts with an `l`. They are also often differently coloured, and the long listing often shows them with an arrow pointing to their original, like `symlinked-file.txt -> file.txt`.

To create a symbolic link, use the `ln -s` command (`ln` for link, `-s` for symbolic):

```
ln -s file.txt symlinked-file.txt
ln -s somedir symlinked-directory
rm symlinked-file.txt symlinked-directory
```

Note that without the `-s`, you create so-called "hard links", which are actual linked duplicates, using the same data on disk; change one and you'll change the other. Hard links are often used by a backup program for incremental backups: you can create a duplicate of the same file at another backup date without needed extra space. But deleting the copy or the original still keeps the other around in a valid state, unlike symbolic links. Note that hard links work on files only; they don't work on directories.


### Find


  `find` is a very useful, but at times cumbersome, command

  Basic usage:

  *
    ```
    find <dir> -name <filename>
    ```

    (note `-name`, not `--name`)

    Finds a file <filename> in <dir> and its subdirectories

    Example: `find . -name files.txt`

  *
    ```
    find . -name \*.txt
    ```

    Find any file with the .txt extension.

	Note we need to escape the globbing pattern, to avoid the shell expanding the globbing pattern; this way, the full "*.txt" string gets passed to find.

  *
    ```
    find .
    ```

    List all files and subdirectories in the current directory. Useful in other contexts, not so much by itself. The results when run in your home directory or the root directory may be a little overwhelming.


  *
    ```
    find . -type d
    ```

    List all directories (type d). Files are of type 'f'.

  *
    ```
    find . -name \*.txt -exec grep keyword {} \;
    ```

    Find all text files, and run grep on each of them, searching for keyword. Note the awkward syntax. More practical is `grep keyword **/*.txt`.

    I generally use `xargs` instead of -exec, with a pipe:

  *
    ```
    find . -type f | xargs grep keyword
    ```

    Find all files (skip directories, because grep doesn't handle directories), and pass the output as input to grep, through `xargs`. Directly passing it to grep would result in grep interpreting the list of files as single input, so grep would be searching for keyword in a list of filenames, not searching through the files themselves. xargs changes that, passing the output of find as separate arguments to grep.

    Since xargs separates the arguments by newlines, to avoid problems with bad filenames, that is, filenames with newlines, use the special nul-character to split the arguments, on both the find and xargs side.

  *
    ```
    find . -type f -print0 | xargs -0 grep keyword
    ```

    Finally, xargs can hand out the input to parallel processes; convenient for something that requires a bit of calculation

    ```
    find . -type f -print0 | xargs -0 -P8 grep keyword
    ```

  By this time, you're almost better off with programming a short Python script or similar.


### Permissions

Each file (and directory) has permissions: which user can do what with a file.

The basic permissions are read, write and execute. Programs, including shell scripts, would normally be executable, otherwise you can't run them.

The main use of these permissions are on systems where there are multiple users. This can prevent other users from reading (or writing = modifying!) your files.

There are three levels of permissions: user level (just for yourself), group level (a specific group of users on a single system), and other/world (everyone else). This difference can make it convenient, on multi-user systems, to share files and directories between users belonging to one group.

You see the permissions if you use `ls -l`, in the form of
```
  -rw-r--r--
```

For a directory, it would be
```
  drwxr-xr-x
```

The `d` at the start obviously indicating this is a directory.

Each group of 3 characters is rwx, or a dash if a value is unset. r means read, w write, and x means executable. A directory should always be executable and readable to be able to read files inside the directory.

The first group is for the user permissions, the second for the group permissions, and the third for the world permissions.

By default on most systems, files will have -rw-r--r-- permissions: read and writeable for the user, readable for their group and the rest of the world.


You can change permissions with the `chmod` command. You specify whether this is for a user, group or other (u, g or o; can be combined), then whether you want to add (`+`) or remove (`-`) a permission. For example

```
   chmod go-r personal.txt
```

Removes the read permission for both group and other/world.


Important to keep in mind is that the directory where a file is located, will also need to be readable for a file to be readable (by that user/group/other). And if you want to modify a file (including changing its permissions), you will need to have write (and execute) permissions for its parent directory. This is usually the default for files in your home directory and its subdirectories.

Sometimes, you'll find guides with just a number for permissions, like 644 or 755. These should be read as three separate octal numbers, 6 4 4, each indicating a combination of execute (0/1), write (0/2) and read (0/4). In the above examples, 644 (or 0644, the leading 0 indicating octal) is the same as rw-r--r--, and 755 is rwxr-xr-x (often the default for directories).

You may occasionally come across a guide or some tip to set your permissions to 777. While this is generally still safe on your own laptop, avoid this: it will set files and directories readable *and writeable* for everyone that has access to the system.

Behind the scenes, permissions are often used to limit what a process can do. Processes have their own user, and permissions minimize what this user (and thus the process) can read or write.

Finally: the "root" user can override everything. A root user on a shared system can look in your files (but they really shouldn't).


### Compression (zipping) and archive files


`compress <file>`: compress a file (older algorithm). Extension .Z

`uncompress <file.Z>`: uncompress a file (older algorithm)

`gzip <file>`: compress a file. Extension .gz

`gunzip <file.gz>`: uncompress a file

`bzip <file>` and `bunzip <file.bz2>`. Newer compression, extension .bz2

`unzip <file.zip>`: unzip a zip file(s)

`unzip -l <file.zip>`: list what will be unzipped


* tar combines file (it's short for tape-archive. Indeed, from back in the days when files were regularly stored on or retrieved from tapes):


  `tar -cvf <tarfile.tar>` <files/directory>: combine files (or a directory contents) into a tar file

  `tar -tvf <tarfile.tar>`: list contents of tar file

  `tar -xvf <tarfile.tar>`: extract contents of tar file

  `tar -z[xct]vf <tarfile.tgz>`: apply gzip compression on the (resulting) tar file.

  `tar -j[xct]vf <tarfile.tar.bz2>`: apply bzip compression on the (resulting) tar file.

  The `-` is optional for tar options! `tar -tvf` and `tar tvf` are the same.

  Tar normally only packs file together, it doesn't compress the files (or the tar file). But over the years, for convenience a few compression options have been added to tar.

  Note the `.tgz` extension: this is extension that you may come across that stands for `.tar.gz`.

  The `file` command is useful when dealing with compressed or tar files and it is not directly clear from the extension what compression method is used: sometimes, a .Z or .gz file may have been named with the .zip extension and zip will fail to uncompress such a file, causing confusion.


### Viewing actively running processes


* You can use the command `top` to view currently running processes. This will take up the full current terminal tab/pane/window. Use `q` or `ctrl-c` to quit.

    Some versions of `top` combine usage for multithreaded programs, so the CPU usage can get above 100%

* `htop` is nicer a top (`q` or `ctrl-c` to quit). If it's not installed on your system, your package manager probably has it (for Linux); on macOS, I like to use Homebrew as a package manager for extra Unix tools such as `htop`.


  If you want to see it in action, download https://raw.githubusercontent.com/antonpannekoek/workshops/refs/heads/main/intro-linux-shell/data/par.py and run it with multiple processes: `python par.py 6`. It performs a very simple Monte Carlo simulation to calculate the area of various circles, each in parallel, and you should see the CPU usage go up, as well as multiple threads being active.

### Letting a process run while quitting the terminal / logging out of the shell


Normally, if you quit the terminal application (or log out of the shell; this is more in the context of remote connections), any process started in that shell will exit as well. This is even the case if you put the process in the background with `bg`.

For the following, you can use e.g. `sleep 600` as a test program.

To keep it running, use the following steps:

* Once started, suspend it and put it in the background, as before: `control-z`, `bg`.

* Then, get its job id (probably %1; you don't need the PID), then use

* `disown %1`

  `disown` is the key command: it detaches the backgrounded job from its parent application (the shell, and ultimately the terminal).


  Type `jobs` to see the process doesn't exist anymore as a child process in the current shell.

  Run `ps` to see it's still there.

  Now quit the terminal (try `logout` on the command line; or `control-d`).

  Start a new terminal, and run `ps`.

  `kill <PID>` if you want to quit the process early. (There is no job-id anymore, since it's detached, so the `%1` variant can't be used.)

With the above steps, you will lose any output. Both stdout and stderr don't go to the terminal anymore. To keep the output, redirect this to a file. A separate file for stdout and stderr is a good option, although sending both to the same file can also be fine:

  * `sleep 600 > sleep.out 2> sleep.err`

  and to a combined file

  * `sleep 600 > sleep.out 2>&1`

  Also

  * `sleep 600 >> sleep.out 2>&1`

  will append to `sleep.out`.


When a process is running (detached or normally) and it has continuous output going to a file, you can "follow the output file with tail: `tail -f sleep.out` keeps checking for new additions to the file and printing them to the terminal.


You can start a process as normal, but redirect stdout and stderr. Once you have exited the terminal, there is no way to connect the process back to a terminal for viewing output. E.g., `sleep 300`, or, for more activity and output, use the above Python script, with the repeat option: `python par.py 2 --repeat 100 > par.py.out 2> par.py.err`. Start the program in a fresh terminal, so you don't lose any work (shell history) when exiting the terminal.


* `nohup`

  `nohup` (no hangup) can be an alternative to `disown` for letting a program run in the background. It is used to immediately secure a program in case the terminal exits:

```
  nohup python par.py 1 &
```

  You still need to manually put it in the background.

  An output file, `nohup.out`, is created, which contains the stdout and stderr from the program (note that it appends if the file already exists).

  If you now quit the terminal, the process keeps running and writing to this file. (Note that shells, if I type control-d to exit the shell and terminal, may warn that you have running process. Doing control-z again will confirm that, yes, you really want to exit, and kill the program if you didn't disown or nohup it.

  If you redirect stdout manually, `nohup.out` only contains the stderr results. If you also redirect the stderr, there will be no `nohup.out` file (or not appended to.


As a final note on this topic: processes will keep running, whether you exit the terminal, close a remote connection if you're logged into another machine, or log out from your desktop environment. If you put your machine to sleep (suspend), common on laptops, the process will also be suspended until the laptop wakes up. And if you shut down or reboot the machine, the process will be killed, and *not* automatically restart (doing that is a whole other topic again).
