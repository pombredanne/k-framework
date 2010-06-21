k_rootdir=~/k-framework
k_toolsdir=${k_rootdir}/tools
antlr_rootdir=${k_toolsdir}/antlr
makefile=Makefile.antlr
target=run
main=unwrapBuiltinsMain
filepath=${1%/*}
kmaude_file=${1##*/}
filename=${kmaude_file%%.*}
compiled_file=${filename}"-compiled.maude"
ml_file="ml-"${filename}".maude"
cwd=`pwd`

${k_toolsdir}/kompile.pl $1
(cd ${antlr_rootdir} && make -f ${makefile} ${target} MAIN=${main}) <${compiled_file} | sed "1d" | sed "s/subsort Int++ < Builtins \./\0\nsubsort Int++ < KResult \.\nsubsort Id < K \./g" >${cwd}/${ml_file}

