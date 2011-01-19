#!/bin/bash
# To get Osirix Plugin Generator

svn export https://osirixplugins.svn.sourceforge.net/svnroot/osirixplugins/_help
pushd _help
unzip Osirix\ Plugin\ Generator.zip
mv Osirix\ Plugin\ Generator.app ../
popd
rm -rf _help
