_These instructions are incomplete and anyone interested in contributing is invited to discuss on [the TeX-hyphen mailing list](http://tug.org/mailman/listinfo/tex-hyphen)_

# Contributing pattern files for an existing language.

If you want to modify patterns for a language that already exists in our
repository, you should make sure that your additions don’t interfere with the
current patterns.  It’s not recommended to manually add patterns to a list
generated by `patgen`: instead, modifications should be made in the hyphenated
word list that was used as a source, and the full set should be regenerated.
This of course does not apply to hand-generated patterns.
