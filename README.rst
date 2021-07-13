==========
 ddkbuild
==========

* Download the `latest release 7.4r60`_ (`PGP signature`_).
* The companion project `DDKWizard can be found here`_.

About
-----
*Note:* ``ddkbuild.cmd`` is indeed a complete rewrite of ddkbuild.bat_ from OSR_,
using the advanced possibilities of the NT script interpreter. Thus, even though
the command line options are mostly compatible, many of the internals of both
scripts are quite different.

Further down in this little README file I want to address some of the tricks
used during to make ``ddkbuild.cmd`` work just the way it works. However, I will
not describe basic concepts of NT shell scripting but rather those that set
``ddkbuild.cmd`` apart.

Download
--------
I have PGP-signed all historical releases in April 2016, after verifying their
integrity, and they are available from the `download section`_. Use GPG_ to
verify the downloads against my signatures.

Techniques used in ddkbuild
---------------------------
Perhaps ``ddkbuild.cmd`` is one of the biggest scripts ever written for the NT
script interpreter.

If you are interested in how ``ddkbuild.cmd`` ticks, read on. Otherwise use the
`DDKWizard manual`_ to find out how to configure your system and Visual Studio
for use with ``ddkbuild`` and use the help output (call ``ddkbuild`` without
parameters) to find out more about its command line options.

Hiding information and hiding errors
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
While undoubtedly one of the fundamental uses of ``ddkbuild`` is as a wrapper of
the ``BUILD`` utility from the DDK, there are things to do before and after
calling. Some of these things involve ugly messages that be better hidden from
the end user.
As an example we can have a look at the code that tries to check whether the
``FINDSTR`` utility is available on the users' systems::

   findstr /? > NUL 2>&1 || echo "Error" && goto :EOF

This line is pretty simple and and any Bash afiniciados might readily be able to
decipher it without further comment. The part before the two pipe characters
attempts to call ``FINDSTR`` and redirects its ``STDOUT`` as well as ``STDERR``
to ``NUL`` (which, btw, is the name of a pseudo-file in every single directory
on a Windows system). ``2>&1``, similar to the Bash syntax actually says to
redirect ``STDERR`` (handle 2) to the same pipe as ``STDOUT`` (handle 1).

The two consecutive pipe characters tell the script interpreter to only run the
code to the right of it if the ``ERRORLEVEL`` variable (i.e. the exit code of
the attempted execution of ``FINDSTR``) is zero. This means that the command
left of those pipe characters executed successfully. This trick also works for
most other commands/executables and in fact ``ddkbuild`` uses it to check
whether the ``REG.EXE`` utility is available. While existent in Windows XP, on
some Windows 2000 systems it is only part of the supplementary tools from the
install CD.

Use ``::`` instead of ``REM``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

``REM``, meaning "remove", denotes a comment line in batch scripts and is also
available in NT scripts for compatibility reasons. However, in NT scripts you
have the option of using the more readable syntax with ``::`` instead.

Technically lines starting with ``:`` are labels and ``::`` is an *invalid*
label. See `this Stackoverflow question`_ and its answers for more details.

Using ``::`` to start a comment line makes the whole script more readable,
however, because it is more distinct from other commands that are usually
comprised of words or parts of words (call them mnemonics if you like). ``REM``
just looks like any other command and therefore you are often at a loss in long
scripts if your editor doesn't have syntax highlighting for NT scripts.

Sadly though, many editors still don't support these makeshift comments in their
syntax highlighters.

Using subroutines
~~~~~~~~~~~~~~~~~
Just like with real programming languages, ``GOTO`` is usually  not the way to
do things anymore, although it is often more convenient than not using it.

I suggest you get and read the book "NT Shell Scripting" for a primer on how to
use subroutines in batch and NT scripts. The ``CALL`` command can not just be
used to call external scripts (if you simply called and external script without
``CALL``, the execution could potentially get stuck in the other script and
never return). ``CALL`` can also be used to call subroutines - aka "labels" -
similar to the way you can use ``GOTO``.

If you define a particular label and end its execution path by a ``GOTO :EOF``,
the latter one can be used in the same way as "return" in other languages.

In this case ``:EOF`` is an implicitly defined label created by the interpreter.

There is only a minor caveat with this approach in that the flow of execution
*before* any subroutines has to be ended by ``GOTO :EOF`` as well, because it
would otherwise run into the first of the subroutines.

Furthermore subroutines take their own set of parameters that can be addressed
using the variables ``%1`` through ``%9`` and used within the routine using the
syntax described under ``FOR /?``, such as ``%~1`` in order to remove the outer
double quotes from the parameter. This is a pretty neat feature for
normalization of parameters or processing of file names.

.. _latest release 7.4r60: https://sourceforge.net/projects/ddkbuild/files/legacy-releases/ddkbuild_v74r60.zip/download
.. _PGP signature: https://sourceforge.net/projects/ddkbuild/files/legacy-releases/ddkbuild_v74r60.zip.asc/download
.. _DDKWizard can be found here: https://sourceforge.net/projects/ddkwizard/
.. _ddkbuild.bat: http://www.osronline.com/article.cfm?article=43
.. _OSR: http://osronline.com
.. _download section: https://sourceforge.net/projects/ddkwizard/files/
.. _GPG: https://www.gpg4win.org/index.html
.. _DDKWizard manual: https://sourceforge.net/projects/ddkwizard/files/legacy-releases/DDKWizard_Help.pdf/download
.. _this Stackoverflow question: https://stackoverflow.com/a/16632555
