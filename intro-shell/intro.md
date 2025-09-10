Reasons to use a command line
-----------------------------

- Reproducible:
I can copy-paste commands, put them in a text file, and re-use them later, or send them to someone else. For a GUI (graphical user interface), I'll need to write down exactly what buttons to click, or create a screen-recording.

- Scripting / automating (closely related to the previous point):
I can write a shell script (a series of commands in a file) and execute it, which will be faster than manually clicking some buttons several times. GUIs are much harder to automate than a series of shell commands

- Less data traffic:
(More and more a thing of the past). If you have to work remotely, from your laptop on a different machine across the internet, that other machine may not have a matching OS for GUI use, and it may be a slow network connection. In the latter case, typing in a shell costs you one byte per character typed, instead of 2 million pixels with 3 byte color pixels streamed every 1/30 of a second or so.

- Faster (touch typist only perhaps):
Moving a mouse to click an icon or button is perhaps more intuitive, but harder to aim than typing the respective command.

- Often more versatile:
I can filter out a list of files with

`ls data-202506??-cluster[ABC].txt`

to get all files for clusters A, B and C produced in June 2025, than I can through a file browser.

Terminology
-----------

- Terminal: application which gives you access to a command line & shell

Terminals were single monitors with a keyboard, connected to a (large) computer somewhere else (mainframe); the monitor and the keyboard were endpoints (startpoint) for that computer, hence terminal.

- Command line: the line where you enter commands. Very straightforward name.

- Prompt: the (textual) indicator bit before the point where you enter commands. Can have things like a (part of) a path, user name, computer name, time; most often ends with a $ (for bash shell) or % (for z-shell); when it ends with a #, this means you are acting as the root user (beware!). This is all configurable, and some programs you run will alter your prompt to indicate some special status.

- Shell: The program that initially interprets what you typed on the command line. It provides editing capabilities of commands (try control-a to go to the start of a command, then control-e to go to the end of that line), history (use the up-arrow to see previously typed commands), tab-completion, matching multiple files (called globbing, with * and ?, and sometimes even other globbing options). Once processed by the shell, the command gets send onwards to the actual operating system (OS).

Hence the name "shell": it provides a shell around your commands, before sending things off to the OS.

Various shells exists, the most common in Linux being bash: Bourne Again SHell (once upon a time, there was just "sh", shell; then came the Bourne shell (named after Stephen Bourne, not Jason). The other popular shell is zsh, Z-shell, which is common nowadays on Mac. Though less frequent nowadays, you could encounter ksh, csh and tcsh. Generally, try to stick to bash or zsh: they have very similar syntax.


The various terms Terminal, Command line, Prompt and Shell are often intermixed, with essentially the same meaning:

- type in your terminal
- type on the command line
- type at the prompt
- type in your shell



(Bonus:

- Cursor: point where you are typing. Since it's all characters, the cursor can't be exactly between characters: the left side of the cursor is often the point where new characters will appear

)

Linux & macOS
------------

Linux & macOS both are Unix-like OSes. Unix hails from the late 1960s, and variants were made by different companies over the decades (companies that sold computers for e.g. universities and research labs, such as HP (HP-UX), IBM (AIX), Sun (Solaris). It never really reached home computers (Mac, DOS and Windows did that), but early 1990s, Linux, a free and open source Unix-style OS was capable of running on home machines. With the popularity of simple(r) desktop machines, Linux become more popular, and become the cheap alternative to Unix.

Apple adapted another free Unix-like OS, called BSD, and created a new variant of its OS around that, called macOS, early 2000s.

This different origin of macOS vs Linux, both Unix-like, makes the systems very similar, but not exactly the same.

(The main reason behind this is software license: Linux requires changes to its code to be made public, and Apple didn't want to do this. BSD doesn't require this. For a similar reason, Apple switched from using bash as the default shell to using zsh as a default, since newer versions of bash have licenses that Apple doesn't like.)

This becomes noticeable with certain commands, which are essentially the same command, but behave ever so slightly differently. And some commands may have options in Linux that don't exist for BSD/macOS.

So if you have a shell script that works on Linux and try to use it on macOS, it sadly is not guaranteed to work. 90% of the time, it works fine, but 10% (or thereabouts) is still a lot of times you need to fiddle around with it.


copy-paste in the terminal
--------------------------

Generally, you can use the mouse to select text, not a problem.

To copy in a Linux terminal, often (but not guaranteed), use control-shift-c, and control-shift-v to paste, since control-c and control-v are reserved for other things in a terminal (control-c will interrupt a running program, for example).

In a macOS terminal, you can use command-C and command-V for copy and paste, since there is a separate control key.



case sensitivity
----------------


In Windows, you can type filenames in lower- or uppercase or a mixture, and Windows doesn't care: myfile.txt is the same as MYFILE.TXT or MyFilE.tXT .

In Linux, case does matter. This becomes particularly important, because sometimes, people or programs have a habit of using extensions that differ only by their case. For example, this (used to be/is) a thing for C++ program sources: myfile.c would be a C file, and myfile.C would be a C++ file. But in Windows, these would be exactly the same.

macOS made it, in my opinion, worse: it will show upper and lower case file and directory names differently (called "case-preserving"), but it will still interpret them the same. So you can see a `myfile.C` in a directory, but typing `rm myfile.c` will remove exactly that file.

The key points are

- don't rely on upper- or lowercase to distinguish file or directory names

- when sorting a list of files (either in shell or in a program), don't rely on the output from e.g. `ls` or globbing (the latter may be completely unsorted). Shell commands follow the OS logic, and sorting results may differ: in Windows, the order for two files may be aaa.txt, Ab.txt, while in Linux this would be Ab.txt, aaa.txt (capital letters tend to come before lowercase letters). Confusingly, the sorting order of a command like `ls` depends on your so-called "locale", and you may find that the order is case-independent on Linux even. All in all, don't rely on this, and sort explicitly (`sort`, or `sort -f` to ignore the case).
  This has caused scientific errors (in published papers).



Deleting files & directories
----------------------------


If you're not entirely sure a file (or multiple files, or whole directories), can really be deleted, just rename them, to something obvious, to be deleted later. For example,

`mv mydirectory mydirectory_aside`


Once you're satisfied everything still works and you really don't need the file (say, after a few days, weeks or a month or so; give it time), you can remove the `*_aside` directories and files. Sometimes, you may forget about it, and then it only becomes necessary when you run out of disk space.

This is essentially what dragging something to the Trash does: it has been moved to a different directory.
I would suggest not to do exactly this, because if you do need the file or directory back, you may not remember in which directory exactly it should go. With `_aside`, you can just leave it in the right directory (unless of course you have a program that reads all files in that directory, and this particular file should not be read).



Annoying characters in file names
---------------------------------


Spaces, quotes (single & double), backslashes and forward slashes, are tricky characters in file names. If you can avoid them, do so.
Additionally, try and avoid accented characters (this makes it easier for most of the western world to type your file names, as well causing less problems with sorting), and most other special characters.

Generally, I'd suggest to use lowercase letters, numbers, underscores and dashes, and a period to separate the filename stem from its extension.

Uppercase letters are not really needed, and appear to be a newer thing (such as directory names in a user directory, like Documents, Desktop and Downloads, whereas system directories are more standard named lowercase: /usr, /bin, /var, /proc etc. There is no need for a capitalised directory name: `ls -F` or a colored `ls` output tells you quickly enough what is a directory).

Dashes are generally fine in filenames, although very occasionally these may be interpreted by some (badly written) program as a minus sign (I've never had a problem though), so if you want to be really safe, use underscores instead.

If you do encounter filenames with parentheses, slashes, spaces etc, quote them, in either single or double quotes: "Some (annoying) file.txt". Alternatively, escape all special characters with a backslash: Some\ \(annoying\)\ file.txt. If you use tab completion (Som<tab>), the shell will do the latter. Tab-completion is very convenient for such filenames, but the backslashes can make them hard to read.

