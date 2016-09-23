Project Renard Homebrew Tap
===================

[![Build Status](https://travis-ci.org/project-renard/homebrew-project-renard.svg?branch=master)](https://travis-ci.org/project-renard/homebrew-project-renard)

This [Homebrew](http://mxcl.github.com/homebrew/) tap provides formulas for
[Project Renard](https://project-renard.github.io/).

First, use this command to set up the Project Renard Homebrew tap:

    brew tap project-renard/project-renard

Now you can install the Curie application:

    brew install curie

Interested in hacking on Curie? Of course you should
[fork it](https://github.com/project-renard/curie/fork), and then install the dependencies
for maintaining Curie:

    brew install curie_maint_depends

Just want the latest from Git without forking? Use the `--HEAD` option to
install Curie (and the maintenance dependencies):

    brew install curie --HEAD

License
-------

The Project Renard Homebrew Tap formulas are distributed as
[public domain](http://en.wikipedia.org/wiki/Public_Domain) software. Anyone
is free to copy, modify, publish, use, compile, sell, or distribute the
original Project Renard Homebrew Tap formulas, either in source code form or as a
compiled binary, for any purpose, commercial or non-commercial, and by any
means.

Acknowledgments
---------------

These formulae were based on the [Homebrew tap for Sqitch](https://github.com/theory/homebrew-sqitch),
a database schema change management system.
