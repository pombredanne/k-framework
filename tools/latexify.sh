#!/bin/sh
MAUDE="maude"
function usage {
  echo "usage: $0 <source_file>[.maude] [<module_name>]
  
  If <module_name> is not specified, is asumed to be allcaps(<source_file>).
  <source_file> should ensure that a module <module_name> is loaded.
  Output is printed in <module_name>.tex and, if lucky, in <module_name>.PDF
  "
}

if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then 
  usage
  exit 1
fi
which $MAUDE 1>/dev/null 2>/dev/null
if [[ $? -ne 0 ]]; then
  echo "set MAUDE to the correct path of the maude executable in $0 on line 2"
  exit 1;
fi
MAUDE="$MAUDE -no-banner -batch -no-wrap"
echo "q" | $MAUDE >/dev/null
RUNNER=`which "$0"`
KBASE=`dirname "$RUNNER"`/..
FILE=${1/.*/}
if [[ $# -eq  2 ]]; then
  LANG="$2"
else
  LANG=`echo $FILE | tr a-z A-Z`
fi


echo "
load \"$KBASE/tools/k-to-latex\"
set show advisories off .
load  \"$KBASE/k-no-comm-prelude\"
select $LANG .
set show advisories on .
select LATEX-PRINT-LOOP .
loop latex-print .
(print $LANG .)
q
" | maude -no-banner -no-wrap $1 | grep -A 10000 "documentclass" | sed '$d' >$LANG.tex
echo "LaTeX file generated.  now compiling through pdflatex"
echo "Q" | pdflatex -interaction=errorstopmode $LANG.tex |tail -5


