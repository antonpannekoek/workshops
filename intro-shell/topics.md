Why shell / command line?
-------------------------

  * reproducible

    I can copy-paste commands, put them in a text file, and re-use them later, or send them to someone else. For a GUI (graphical user interface), I'll need to write down exactly what buttons to click, or create a screen-recording.

  * scripting / automating  (closely related to the previous point)

    I can write a shell script (a series of commands in a file) and execute it, which will be faster than manually clicking some buttons several times. GUIs are much harder to automate than a series of shell commands

  * less data traffic

    (More and more a thing of the past). If you have to work remotely, from your laptop on a different machine across the internet, that other machine may not have a matching OS for GUI use, and it may be a slow network connection. In the latter case, typing in a shell costs you one byte per character typed, instead of 2millions pixels with 3 byte color pixels streamed every 1/30 of a second or so.

  * faster (touch typist only perhaps): moving a mouse to click an icon or button is perhaps more intuitive, but harder to aim than typing the respective command (exception: touch screen, provided it is flat on the table, i.e. a table).

  * often more versatile.

   I can filter out a list of files with `ls data-202506??-cluster[ABC].txt` to get all files for clusters A, B and C produced in June 2025, than I can through a file browser (may depend on alphabetical ordering of such filenames).


* What are a terminal, command line, prompt, shell

  * There is a whole bunch of terminal apps.

    Also several flavours of shell: bash & zsh most common (Linux & macOS respectively)

  * prompt very customisable; outside of scope, but

    * some external programs may modify to show status (virtual / Conda environment; git)

    * ending in $ for bash, % for zsh, # for root (no shell, but admin user)

  * prompt shows status

    * other interactive programs also have their own prompts, e.g. Python

  * cursor: where you are typing

    technically between characters, but under character in front of which you'll insert text

* Why not simply program these things?

  * That is often more cumbersome, slower, and you'd be reinventing a lot of wheels (commands). Not everything can be done in a shell and sometimes needs to be programmed, but for quick file examination and chaining various commands (in a shell script), using the shell is often far more convenient.


Notation in this document
-------------------------

Text between back-quotes, `like this`, are commands or output from the shell. This is not always done; context should help

Items that should be filled in with an appropriate value, such as a suitable file name, are surrounding by angled brackets, <like so>, or <filename>.


Navigating and paths
--------------------

* commands for navigating

  pwd, ls, cd

* mkdir somedir; cd somedir; ls

* create a file with nano and a few lines. Close, and open the same file on the command line `nano somefile.txt`.


* Path:

  * `pwd` to see where we are in our filesystem.

  * / as directory separator

  * starts with /: absolute. Otherwise relative

    * absolute versus relative paths depend on context what to use. Relative paths tend to be more flexible, to a point. If you are working from another directory than where the files are, absolute paths can be better.

  * note root directory, / .

  * special directories:

    `.` means the current directory

    `..` means the parent directory

    `~` (tilde, or twiddle) means your home directory

  * generally, stick to your home directory and subdirectories therein; stay away from other directories, so you don't mess up your system.

  * cd conveniences:

    * `cd` by itself changes to your home directory

    * `cd -` returns to the previous directory. Handy if you switching between directories with long names.


Some differences between Linux and macOS
----------------------------------------

* be warned: Linux is case sensitive, macOS is case "preserving", Windows is case insensitive

  * ls may or may be case sensitive for its default sorting. This depends on the so-called "locale"; outside of scope

  * never rely on sorting of files, unless explicitly done (e.g., with ls -t, or the sort command)

    Also holds when programming: always explicitly sort

    This has caused errors in scientific articles


Note on copy-paste in the terminal
----------------------------------

Control-c, control-v and control-x don't work as normal in a terminal, since these are reserved key-combinations for the shell (nor does control-z, undo). For copying, pasting and cutting in a terminal, use shift-control-c, shift-control-v and shift-control-x.


Exploring ls and files
------------

* ls -l
  quickly explain a few properties (in particular, size)

  ls -h for human-readable sizes

* Options to ls

  * -F: file types (directories appended with /)

  * -a: all files, also hidden

  * -t: sort by time

  * -r: reverse sorting

  * -l: long listing: more file details, including size

* Quick explanation

  * arguments: anything after the command

  * options: optional arguments. Generally preceded with a `-`

    * sometimes options take their own arguments (mostly just one)

    * short and long options

    * short options can be combined, provided none of them (or only the last one) takes an argument. E.g., `ls -haltr`

    * Some commands (from days past, i.e., archaic) take options without the `-` in front (tar, ps; confusingly, sometimes the `-` itself is optional (`tar`) or using it changes the meaning somewhat `ps aux / ps -aux`; `ps` is just weird), or have a single `-` for a long option (`-name` for `find)`


* To get a general idea of what a file might contain, use `file file.txt`


* cat file.txt

  cat for concatenate, but also lists (dumps) a file to the terminal (use nano-created file)

* notes on filenames:

  - extensions are useful, but technically, they can be ignored (but some programs are picky about extensions.

    They are more a quick indicator for humans than required.

    Use them, but don't rely on them fully.


  - avoid tricky characters (non-alphanumeric, including accented characters).

    If you have to deal with them: surround them in single quotes or double quotes (on or the other), or escape (backslash) each "tricky" character. Accented characters will usually be fine, but the whole slew of !@#$%^&*()[]{}:;,<>/? are best to be avoided.

    To handle quotes and backslashes as part of a filename: escape them with a backslash: \\, \", \'.

    This mainly applies to reading / listing such files, not to creating them yourselves. But tab-completion (see further) helps here!


* cp output.txt data.txt; mv data.txt data.csv

  cp and mv also work on directories:

  mkdir temp

  cp data.csv temp

  ls temp

  mv output.txt temp

  ls temp

  ls

  * copy recursively (directory and contents, including subdirs):

    cp -r temp temp2


  * cp and mv can work on more than one file, if the last argument is a directory: copies or movies all files to that directory.


* rm: anything removed is removed permanently!

  * Safer alternatively: rename to an obvious name, and only delete (much) later

    mv temp temp_aside

  * actually deleting things

    cd temp2

    ls

    rm output.txt

    rm data.csv

    ls

    cd ..

    rmdir temp2

  * to remove a directory and all of contents at once (permanently!)

    rm -r temp2

  * rm has a safety (sometimes, this is set as a default on systems)

    `rm -i` will ask for a confirmation for each file to be deleted.

    Useful when deleting multiple files, and removing completely directories.

    But impractical when deleting 100s of (temporary) files


* download a large file

  * curl -O https://github.com/antonpannekoek/workshops/blob/main/intro-shell/data/hipparcos.dat.gz

  * wget as alternative; but sometimes not installed, while curl nearly always is

  * Files is compressed. .gz is an alternative to zip. Use `gunzip hipparcos.gz`. Note g(un)zip only compresses single files: not a container for multiple compressed files like zip. (More on compression in the extras at the bottom)


* cat is too long; head, head -n20, tail, tail -n20

* wc, wc -l, wc -c


* pagers

  more, less. space to page, q to quit, w to go up, /keyword to search, n to go through them one by one


* grep: finding a line with a specific word in a file

  `grep 117668 hipparcos.dat`

  Surround words with special characters (including spaces) with single quotes, or escape them. `grep '117668|' hipparcos.dat`

  When searching through code, it can be convenient to show lines surrounding your found line. Use the -C option (context), with the number of lines surrounding:

  `grep -C3 '117668|' hipparcos.dat`

  to show 7 lines, with HIP 117668 in the middle.


* examining files

  `file <filename>` gives an idea what a file likely is. (It peeks at the first few characters, which often follow some convention per file type

  `which <command>` tells you where a command can be found. `type <command>` is also useful.

  `file` also tells you if a file is binary. You don't really want to use cat, head, or tail for these!

   If you accidentally do, and your terminal gets messed up, here's a useful follow command:

   `reset`

* aliases

  Sometimes, you may find it useful to provide an "alias" for a specific command, perhaps with specific options set, to save typing / remembering. For example, `ls -larth` can be lls (long listing). You can set an alias like

   alias lls='ls -larth'

   You can set these in your ~/.bashrc or ~/.zshrc, by simply adding a line like above.

   More importantly, some OSes / sysadmins have set up default aliases, which can lead to confusion. So, for example, there may be this alias

   `alias rm='rm -i'`

   which is both safer when removing files, but also more annoying when removing many files.
   More dangerously, if you get used to being asked to delete a file when running `rm`, then this likely will not be the case on other systems.

   So be aware of system-wide aliases.



Some command line editing
-------------------------

* tab-completion

* warning for control-d

  * at an empty line: quits your shell! (logout)

  * halfway a line: deletes letter under cursor (like <del>)

  * end of line: like tab-completion

  (also works for e.g. the Python cmdline interpreter)

* command line editing keyboard shortcuts / special controls

  type a long line, then

  control-a

  control-e

  left/right arrow keys

  control-k: delete to end of line

  control-u: delete whole line


More differences
-----------------

* commands differ slightly between Linux and macOS

  options in particular: they may not be available on the other platform, or function (slightly) differently.

  In general, things will work equally on both platforms, but be aware.


* difference between bash (Linux default) and zsh (macOS default)

  Little, only very specific cases that I've come across. Generally, zsh can handle bash specifics fine. but one example is the history command

  Use bash if you're not sure, in particular for shell scripts


Shell history
-------------

  * history

    up-arrow

    control-r: search for part of a previous command.

      move arrow key to edit; <enter> to execute

   * `history`

     Has some options, but dependent on shell:

     bash:

       `history 15` shows last 15 commands

     zsh:

       `history -15` shows last 15 commands

       `history 15 shows commands from number 15`

   * select a specific number from the `history` listing:

     !631

     (exclamation mark followed by the history number)


  * when typing / editing a command

    control-c: cancel (delete) line.




Some process handling
---------------------

* a process is a running command.

* control-c: cancel (interrupt) a current running process

  A process is any command. Most take a fraction of a second (ls, pwd, git, curl), some take longer

  $ sleep 10

  control-c

* control-z: suspend a currently running process

  $ sleep 600

  control-z

  (note message)

  $ jobs

  $ fg

  ($ fg %1)

  control-z

  $ bg

  $ jobs

  $ ps  (process status)

  PID: process identifier

  This is the way to find a process that you can't access anymore from a terminal.
  Can't bring it back to the terminal, but can stop (cancel) it:

  kill <PID>

* ps uax / ps -ef

  list all processes. Note root owner

  ps -efu <username> will list only processes by that user


* control-d: functions as tab-completion when not at start of command line

  otherwise: logout. Quits the shell (& sometimes terminal), so be careful using it.



Note: control is often spelled ctrl, ctl, or even written ^, e.g. ^C.



Handling / searching through multiple files
-------------------------------------------

* globbing (wildcards): use special characters that can stand in for zero, one or multiple characters in file names.

  Globbing patterns are handled by the shell, and expanded by the shell *before* passed to the relevant command. Keep this in mind: the command will not see a specific globbing pattern as its argument (unless escaped or quoted)

  The * can mean zero, one or more of any character.

     ls *.txt

     cp *.txt newdir/

     Use this never or very very rarely and carefully, to remove all files and subdirectories in the current directory: rm -r *
     (as before: prefer renaming the current directory)

       As an anecdote: some installer script by a big company had something similar to  `rm -r *.txt, except that there was an extra space: `rm -r * .txt`.

  The ? means exactly 1 of any character (not 0).

    ls numbers?.txt

  A sequence between [] means any of those characters:

    ls numbers[0123].txt

  You can even have ranges with a - inside a []

    ls numbers[0-3].txt

    ls letters[a-f].txt

  ** means the current directory, any sub- or subsub (etc) directory.

    ls **/*.txt

    matches any text file in the current directory or any of its subdirectories

* globbing works with other commands as well (if it makes sense at least). Find a specific keyword in any text file:

   grep keyword **/*.txt

* Just be careful: globbing makes it easier to accidentally overwrite files.

  * Some shells allow you to expand the the pattern before you run the command, using <tab>: `ls *.py<tab>` may expand to `ls spam.py egg.py bacon.py`.


Redirecting output and input
----------------------------

* send output to file

  ls > files.txt

  (This will actually includes files.txt in files.txt)

* append output to file

  ls >> files.txt

* send file to input

  grep files < files.txt

  Note how grep takes either a file, or input. That is, you could use grep interactively:

  grep files

  (now type some lines, including one with the word files; use control-d to exit this mode: control-d here indicates "end of file")


* stdin, stdout and *stderr*

  Standard input, standard output and standard error. These are "secretly" special files, but refer to input (from the keyboard, basically) or output (to the terminal, mainly).

  * stderr is different. If really wanted, `2> error.txt` to capture that

  (in part this is a result from past days, where errors were printed somewhere else than on the terminal. It is still useful today to separate errors from normal output.)

* "but I want to catch *and* view the output!"

  ls | tee output.txt

  (which leads directly to the topic below: pipes)


Chaining commands: pipes
------------------------

You can chain commands together. That is, you can send the output of one command directly as input to another command.

This works particularly well because some commands, like grep, head, or tail, accept a file as well as stdin

* head -n20 hipparcos.dat | tail -n5

  shows lines 15 to 20

* ls -l | sort -nk5

  Sort output by file size: -k5 is fifth field (white-space separated), -n is numerical order

  Variant: `ls -lh | sort -hk5` . Sorts "human-readable", so file size postfixes are taken into account.

* grep '|F5' hipparcos.dat | sort -t '|' -gk10 | tail -n20

  Sort all F5 type stars by declination, and show the last 20 (at largest declination)

  -g is the more generic variant of -n, but slower (try changing -g to -n to see the difference: the + sign in front of the declination becomes an issue)



Environment variables
---------------------

* if you type

  `env`

  You'll get a list of capital-cased variables and their values. These are called environment variables (envvars), and they influence some programs or how your shell works.

  A few interesting ones:

  * PATH . This is a colon-separated list of directories where your shell will look for commands to execute, so that you don't have to type the full path. There are probably `/usr/bin/`, `/bin/`, `/usr/local/bin` a few similar, which are the most basic directories that you always want to have on your PATH, since these directories contain important commands (check `ls /bin` or `ls /usr/bin`).

   Important to know is that order matters. If you have two commands with the same name, then this command is searched in order of directories listed in your PATH.

  To append a new directory to your PATH, do

  export PATH=$PATH:/new/directory

  The `export` is necessary in case you are using subshells (that is, if you use shells cripts). Note that assign is using PATH, but evaluating is using $PATH.

  * HOME. Your home directory. Don't change this.

  * USER . Your user name. Used by some programs. Don't change this.

  * PWD, OLDPWD . The current and previous directory (`cd -` will use OLDPWD)

  * EDITOR . The default editor. Used by some programs, like git when interactively creating a commit

  * PAGER . The default pager for programs that may produce a lot of output. It probably defaults to less

  * PROMPT . This is the variable you would need to change to modify your prompt. But with the amount of options available, modifying the prompt is a whole workshop in itself.

* Some programs require specific environment variables to be set, often to a directory where their output is stored or their auxiliary programs are located. This is normally mentioned in the (installation) manual. It is similar to setting PATH. Let's say you set the environment variable APIDIR

   export APIDIR=$APIDIR:/where/ever/directory

   The fact that APIDIR didn't initially exist doesn't matter; $APIDIR will just result in an empty string, i.e., nothing.

* You can make these envvar settings more permanent by putting such `export ...` lines in your `~/.bashrc` or `~/.zshrc`.

  Some programs do this for you upon installation (although they often inform or ask you first), e.g., if you are installing miniconda or micromamba.


Extras
-----

* find

  find is a very useful, but at times cumbersome, command

  Basic usage

  * find <dir> -name <filename>

    (note -name, not --name)

    Finds a file <filename> in <dir> and its subdirectories

    Example: find . -name files.txt

  * find . -name \*.txt

    Find any file with the .txt extension. Note we need to escape the globbing pattern, to avoid the shell expanding the globbing pattern; this way, it gets passed to find.

  * find .

    List all files and subdirectories in the current directory. Useful in other contexts, not so much by itself.

  * find . -type d

    List all directories (type d). Files are of type 'f'.

  * find . -name \*.txt -exec grep keyword {} \;

    Find all text files, and run grep on each of them, searching for keyword. Note the awkward syntax. More practical is `grep keyword **/*.txt`.

    I generally use xargs instead of -exec, with a pipe:

  * find . -type f | xargs grep keyword

    Find all files (skip directories, because grep doesn't handle directories), and pass the output as input to grep, through xargs. Directly passing it to grep would result in grep interpreting the list of files as single input, so grep would be searching for keyword in a list of filenames, not searching through the files themselves. xargs changes that, passing the output of find as separate arguments to grep.

    Since xargs separates the arguments by newlines, to avoid problems with bad filenames, that is, filenames with newlines, use the special nul-character to split the arguments, on both the find and xargs side.

  * find . -type f -print0 | xargs -0 grep keyword

    Finally, xargs can hand out the input to parallel processes; convenient for something that requires a bit of calculation

    find . - type f -print0 | xargs -0 -P8 grep keyword

  By this time, you're almost better off with programming a short Python script or similar.


* Permissions

Each file (and directory) has permissions: which user can do what with a file.

The basic permissions are read, write and execute. Programs, including shell scripts, would normally be executable, otherwise you can't run them.

The main use of these permissions are on systems where there are multiple users. This can prevent other users from reading (or writing = modifying!) your files.

There are three levels of permissions: user level (just for yourself), group level (a specific group of users on a single system), and other/world (everyone else). This difference can make it convenient, on multi-user systems, to share files and directories between users belonging to one group.

You see the permissions if you use `ls -l`, in the form of

  -rw-r--r--

For a directory, it would be

  drwxr-xr-x

The `d` at the start obviously indicating this is a directory.

Each group of 3 characters is rwx, or a dash if a value is unset. r means read, w write, and x means executable. A directory should always be executable and readable to be able to read files inside the directory.

The first group is for the user permissions, the second for the group permissions, and the third for the world permissions.

By default on most systems, files will have -rw-r--r-- permissions: read and writeable for the user, readable for their group and the rest of the world.


You can change permissions with the `chmod` command. You specify whether this is for a user, group or other (u, g or o; can be combined), then whether you want to add or remove a permission. For example

   chmod go-r personal.txt

Removes the read permission for both group and other/world.

Important to keep in mind is that the directory where a file is located, will also need to be readable for a file to be readable (by that user/group/other). And if you want to modify a file (including changing its permissions), you will need to have write (and execute) permissions for its parent directory. This is usually the default for files in your home directory and its subdirectories.

Sometimes, you'll find guides with just a number for permissions, like 644 or 755. These should be read as three separate octal numbers, 6 4 4, each indicating a combination of execute (0/1), write (0/2) and read (0/4). In the above examples, 644 (or 0644, the leading 0 indicating octal) is the same as rw-r--r--, and 755 is rwxr-xr-x (often the default for directories).

You may occasionally come across a guide or some tip to set your permissions to 777. While this is generally still safe on your own laptop, avoid this: it will set files and directories readable *and writeable* for everyone that has access to the system.

Behind the scenes, permissions are often used to limit what a process can do. Processes sometimes have their own user (not root), and permissions minimize what this user (and thus the process) can read or write.

Finally: the "root" user can override everything. A root user on a shared system can look in your files (but they really shouldn't).


* compression (zipping)

compress <file>: compress a file (older algorithm). Extension .Z

uncompress <file>: uncompress a file (older algorithm)

gzip <file>: compress a file. Extension .gz

gunzip <file>: uncompress a file

bzip <file>>; bunzip <file>. Newer compression, extension .bz2


unzip <file>: unzip a file(s)

unzip -l <file>: list what will be unzipped

* tar combines file (it's short for tape-archive. Indeed, from back in the days when files were regularly stored on or retrieved from tapes)


tar -cvf <tarfile> <files/directory>: combine files (or a directory contents) into a tar file

tar -tvf <tarfile>: list contents of tar file

tar -xvf <tarfile>: extract contents of tar file

tar -z[xvt]vf <tarfile>: apply (gzip) compression on the (resulting) tar file.

tar -j[xvt]vf <tarfile>: apply (bzip) compression on the (resulting) tar file.

The `-` is optional for tar options! `tar -tvf` and `tar tvf` are the same.


* viewing actively running processes

    `q` or `ctrl-c` to quit.

    Some versions of `top` combine usage for multithreaded programs, so the CPU usage can get above 100%

  * `htop` is nicer a top (`q` or `ctrl-c` to quit)

  If you want to see it in action, download https://github.com/antonpannekoek/workshops/blob/main/intro-shell/data/par.py and run it with multiple processes: `python par.py 6`. It performs avery simple Monte Carlo simulation to calculate the area of various circles, each in parallel, and you should see the CPU usage go up, as well as multiple threads being active.

* letting a process run while quitting the terminal / logging out of the shell

  You can start a process as normal, but redirect stdout and stderr. Once you have exited the terminal, there is no way to connect the process back to a terminal for viewing output. E.g., `sleep 300`, or, for more activity and output, use the above Python script, with the repeat option: `python par.py 2 --repeat 100 > par.py.out`. Start the program in a fresh terminal, so you don't lose any work (shell history) when exiting the terminal.

  Once started, suspend it and put it in the background: control-z, bg.

  Then, get its job id (probably %1); you don't need the PID, then use

  disown %1

  Type `jobs` to see the process doesn't exist anymore

  Run `ps` to see it's still there.

  Now quit the terminal (try "logout" on the command line).

  Start a new terminal, and run `ps`. Also check the output file. You can "follow the output file with tail: `tail -f par.py.out` keeps checking for new additions to the file and printing them to the terminal.

  kill <PID> if you want to quit the process early.
