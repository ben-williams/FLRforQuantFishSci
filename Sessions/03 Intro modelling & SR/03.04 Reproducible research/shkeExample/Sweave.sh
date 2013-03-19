#!/bin/bash
#--------------------------------------------------------------------------
# What: Run Sweave and postprocess with LaTeX directly from command line
# Time-stamp: <2006-10-20 14:28:08 ggorjan>
# $Id: Sweave.sh,v 1.9 2006/10/20 12:28:20 ggorjan Exp $
#--------------------------------------------------------------------------
# Todo:
#  - nothing for now
#--------------------------------------------------------------------------
# Depends:
#  - R <http://www.r-project.com>
# Enhances:
#  - texi2dvi <http://www.gnu.org/software/texinfo/texinfo.html>
#  - standard LaTeX tools
#--------------------------------------------------------------------------
# Initial idea taken from:
# <http://www.ci.tuwien.ac.at/~leisch/Sweave/FAQ.html#x1-5000A.3>
#
# There was quite some talk about this issue on R-help mailing list (follow
# link bellow) and there are various ways to achive this task. I wrote this
# script in a way that covers most of my needs. Actually, I tried to cover
# "all possible" or at least most common LaTeX compiling paths. Do not
# hesitate to contact me or provide a patch, if you find that there is need
# for more.
#
# <https://stat.ethz.ch/pipermail/r-help/2005-February/065047.html>
#--------------------------------------------------------------------------
# Use under windows MS (via Cygwin):
# This tool can be used on UNIX alike OSes as well as on Windows under
# Cygwin. Cygwin can lack some TeX stuff and if you have a Windows
# installation of TeX you can tweak the system to use both of them. Try
# first to compile and then decide if you need to merge TeX paths of Cygwin
# and 'Windows'. On the other hand, you can of course always add TeX
# packages to Cygwin's TeX. Here is the list how to set the whole thing up
# and merge both TeX paths:
#
# - install R
#
# - install "TeX" distribution, such as MikTeX and follow instructions at
#   http://www.murdoch-sutherland.com/Rtools/ for fusing MikTeX and R
#
# - install Cygwin with tetex package
#
# - launch Cygwin terminal i.e. one bash shell session and do
#   vi /usr/share/texmf/web2c/texmf.cnf
#
# - find the lines bellow, where * means some directory place
#   TEXMFLOCAL = *
#   TEXMFHOME = *
#
# - change those * to something like (where your Windows TeX installation is)
#   TEXMFLOCAL = /cygdrive/c/Programs/tex/texmf
#   TEXMFHOME = /cygdrive/c/Programs/tex/localtexmf
#
# - find the lines where TEXMFLOCAL and TEXMFHOME appear and put them
#   behind TEXMFMAIN, so that under Cywgin first Cygwin TeX stuff will be
#   used, but in case anything is missing it will take a look in Windows
#   TeX installation i.e. MikTeX in this case.
#   TEXMF = {!!$TEXMFCONFIG,!!$TEXMFVAR!!$TEXMFSYSCONFIG,!!$TEXMFSYSVAR,!!$TEXMFMAIN,!!$TEXMFLOCAL,!!$TEXMFHOME,!!$TEXMFDIST}
#   SYSTEXMF = $TEXMFMAIN;$TEXMFLOCAL;$TEXMFHOME;$TEXMFDIST
#
# I am not really familiar with TEXMF variable syntax so this might be done
# in some other better/nicer way. You can definitely show me how ;)
#--------------------------------------------------------------------------

# --- Defaults ---
CLEAN=yes
FORCE=no
MODE=no

# Defaults for R
#OPTR='--no-save --no-restore'
OPTR='--no-save'
WEAVE=yes
TANGLE=no

# Defaults for LaTeX and friends
OPTTEXI2DVI='--clean --quiet'
OPTDVIPS=''
#OPTPS2PDF='-dCompatibility=1.3'
PS2PDFAPP=ps2pdf13
OPTLATEX=''
OPTPDFLATEX=''
OPTBIBTEX=''
OPTMAKEINDEX=''

# Defaults for viewers
PDFAPPIN=acroread
PSAPPIN=gv

# Nothing to configure below!
#---------------------------------------------------------------------------

NAME=$(basename $0)

# --- Usage ---
usage () {
    cat <<EOF
NAME
    $NAME - Run Sweave and postprocess with LaTeX directly from command line

SYNOPSIS
    $NAME [OPTION] ...

DESCRIPTION
    Run Sweave directly from command line and optionally postprocess with
    LaTeX. Following options can be used:

    -nc, --noclean
      Remove all intermediate files. These are PDF and EPS pictures and TeX
      file from R run of Sweave and DVI file and other TeX temporary files
      from LaTeX run. It is default with all postprocessing options
      i.e. -t*, -l*, -ot* and -ol*, but not in only Sweave mode.

    -f, --force
      Force when error appear during execution. Default is to stop when
      error is ancountered. Error is checked by means of $? environmental
      variable i.e. difference from number 0. Warnings are always printed.
      Checks are performed after R and after all texi2dvi, latex, dvips and
      ps2pdf runs. Exit status of bibtex and makeindex in hardcoded set
      aren't checked.

    -h, --help
      Print this output.

    -m, --mode
      By default all input files are first processed with Sweave and then
      all by LaTeX.  With this option each file is processed with Sweave
      and directly after that with LaTeX and next file with Sweave and
      ... There is no difference for only one input file.

    -nw, --noweave
      Do not weave i.e do not run Sweave function on given file(s). Note
      that with this option old 'TeX' file might be processed if 'TeX'
      options are used. Might be usefull with -t option.

    -nq, --noquiet
      Work quietly as possible, which is default. Works only with options
      -t* and -ot* due to availability of --quiet option in 'texi2dvi'.

    -t, --tangle
      Tangle i.e. extract R code from given file(s). If this option is set,
      produced R file is not removed in cleaning part, otherwise it is, if
      it exists of course.

    There are now the following ways of LaTeX processing:

      Command and path       Script option              Used tools
       - texi2dvi
          |-> PS              -tp, --texi2dvi2ps        texi2dvi and dvips
          |-> PS -> PDF       -tld, --texi2dvi2ps2pdf   texi2dvi, dvips and ps2pdf
          `-> PDF             -td, --texi2dvi2pdf       texi2dvi with pdf option
       - latex
          |-> PS              -lp, --latex2dvi2ps       hardcoded set of 'latex and friends' and dvips
          `-> PS -> PDF       -lld, --latex2dvi2ps2pdf  hardcoded set of 'latex and friends', dvips and ps2pdf
       - pdflatex
          `-> PDF             -ld, --latex2pdf          hardcoded set of 'pdflatex and friends'

    Open produced files (PDF or Postscript) via options bellow, which are
    one step further of options above and always imply them:

    -otp=gv, --opentexi2dvi2ps=gv
    -otld=acroread, --opentexi2dvi2ps2pdf=acroread
    -otd=acroread, --opentexi2dvi2pdf=acroread
    -olp=gv, --openlatex2dvi2ps=gv
    -olld=acroread, --openlatex2dvi2ps2pdf=acroread
    -old=acroread, --openlatex2pdf=acroread
      Files are opened with given application. Defaults are values taken
      from environmental variables PDFAPP and PSAPP. If these are not
      defined 'acroread' is taken for PDF and 'gv' for Postscript. Quotes
      are necessary in case of "bad" filenames.

    -optr=, --optionsr=
    -optt=, --optionstexi2dvi=
    -optp=, --optionsdvips=
    -optf=, --optionsps2pdf=
    -optl=, --optionslatex=
    -optd=, --optionspdflatex=
    -optb=, --optionsbibtex=
    -optm=, --optionsmakeindex=
      Any additional options that might be usefull in R or LaTeX
      postprocessing for each tool that might be used. Multiple options
      for one tool must be given within quotes (single or double) e.g.
      -optp="-Ppdf -GO".

DETAILS
    R is launched with following options:
     - don't save it i.e. --no-save
     - don't restore anything i.e. --no-restore

    Hardcoded set of 'latex/pdflatex and friends' in the context means:
     - hardoced set of LaTeX and friends is used (look bellow), where latex
       can be pure latex or pdflatex. There may appear some errors on
       screen if there is no need for bibtex and/or makeindex, since these
       two are also on the list.

       The list of commands is:
        latex
        bibtex
        makeindex
        latex
        latex

    Options might not be combined like -cotld, but should be given
    separatelly like -c -otld. Look in examples.

    This script has also capability to compile LyX files. Given LyX files
    are exported to LaTeX via LyX export function, then moved to file with
    Rnw extension and compiled as usual. LyX file type is determined via
    file extension .lyx. Note that this approach work only with LyX files
    that have S code chunks inserted within TeX insets. Follow URL bellow,
    if you are interested in a noweb styled LyX files:

    <http://thread.gmane.org/gmane.editors.lyx.general/18847>.

    Only files with extensions .Rnw, .Snw, .nw and .lyx are accepted,
    otherwise script exits.

EXAMPLE
    Process only with Sweave
    $NAME Sweave-test-1.Rnw

    Create postscript via texi2dvi and do not clean temporary files
    $NAME -tp -nc Sweave-test-1.Rnw

    Create PDF via texi2dvi-latex and open it
    $NAME -otld Sweave_prosper_slides.Rnw

    Create PDF via texi2dvi-latex with special options
    $NAME -tld -optp="-Ppdf -GO" -optf=-dPDFsettings=/prepress \
          Sweave_prosper_slides.Rnw

    Create PDF via texi2dvi-latex and open it with "non-standard" viewer
    $NAME -otld=acrobat Sweave_prosper_slides.Rnw

    Create PDF via texi2dvi-pdflatex and open it
    $NAME -otd Sweave_beamer_slides.Rnw

    Create PDF via pdflatex from LyX file
    $NAME -ld Sweave-test-1.lyx

AUTHOR
    Gregor GORJANC <gregor.gorjanc at bfro.uni-lj.si>

EOF
}

# --- Options ---
OPTIONS=$@
for OPTION in "$@"; do
    case "$OPTION" in
        -nc | --noclean )
            CLEAN=no
            OPTIONS=$(echo $OPTIONS | sed -e "s/--noclean//" -e "s/-nc//")
            OPTIONS_ECHO="$OPTIONS_ECHO - noclean mode\n"
            ;;
        -f | --force )
            FORCE=yes
            OPTIONS=$(echo $OPTIONS | sed -e "s/--force//" -e "s/-f//")
            OPTIONS_ECHO="$OPTIONS_ECHO - force mode\n"
            ;;
        -h | --help )
            usage
            exit 0
            ;;
        -m | --mode )
            MODE=yes
            OPTIONS=$(echo $OPTIONS | sed -e "s/--mode//" -e "s/-m//")
            OPTIONS_ECHO="$OPTIONS_ECHO - direct mode\n"
            ;;
        -nq | --noquiet )
            QUIET=no
            OPTIONS=$(echo $OPTIONS | sed -e "s/--noquiet//" -e "s/-nq//")
            OPTIONS_ECHO="$OPTIONS_ECHO - noquiet mode\n"
            ;;
        -nw | --noweave )
            WEAVE=no
            OPTIONS=$(echo $OPTIONS | sed -e "s/--noweave//" -e "s/-nw//")
            OPTIONS_ECHO="$OPTIONS_ECHO - do not weave\n"
            ;;
        -t | --tangle )
            TANGLE=yes
            OPTIONS=$(echo $OPTIONS | sed -e "s/--tangle//" -e "s/-t//")
            OPTIONS_ECHO="$OPTIONS_ECHO - tangle\n"
            ;;
        -tp | --texi2dvi2ps)
            TEX=yes
            TEXI2DVI=yes
            DVIPS=yes
            OPTIONS=$(echo $OPTIONS | sed -e "s/--texi2dvi2ps//" -e "s/-tp//")
            OPTIONS_ECHO="$OPTIONS_ECHO - create PS via texi2dvi\n"
            ;;
        -otp* | --opentexi2dvi2ps*)
            TEX=yes
            TEXI2DVI=yes
            DVIPS=yes
            PSOPEN=yes
            PSAPP1=$(echo $OPTION | sed -e "s/--opentexi2dvips=//"\
                                        -e "s/--opentexi2dvips//"\
                                        -e "s/-otp=//"\
                                        -e "s/-otp//")
            OPTIONS=$(echo $OPTIONS | sed -e "s|$OPTION||")
            if [ ! -n "$PSAPP1" -a ! -n "$PSAPP" ]; then
                PSAPP1=$PSAPPIN
            elif [ -n "$PSAPP" ]; then
                PSAPP1=$PSAPP
            fi
            OPTIONS_ECHO="$OPTIONS_ECHO - create PS via texi2dvi and open it with $PSAPP1\n"
            ;;
        -tld | --texi2dvi2ps2pdf)
            TEX=yes
            TEXI2DVI=yes
            DVIPS=yes
            PS2PDF=yes
            OPTIONS=$(echo $OPTIONS | sed -e "s/--texi2dvi2ps2pdf//" -e "s/-tld//")
            OPTIONS_ECHO="$OPTIONS_ECHO - create PS and PDF via texi2dvi\n"
            ;;
        -otld* | --opentexi2dvi2ps2pdf*)
            TEX=yes
            TEXI2DVI=yes
            DVIPS=yes
            PS2PDF=yes
            PDFOPEN=yes
            PDFAPP1=$(echo $OPTION | sed -e "s/--opentexi2dvi2ps2pdf=//"\
                                         -e "s/--opentexi2dvi2ps2pdf//"\
                                         -e "s/-otld=//"\
                                         -e "s/-otld//")
            OPTIONS=$(echo $OPTIONS | sed -e "s|$OPTION||")
            if [ ! -n "$PDFAPP1" -a ! -n "$PDFAPP" ]; then
                PDFAPP1=$PDFAPPIN
            elif [ -n "$PDFAPP" ]; then
                PDFAPP1=$PDFAPP
            fi
            OPTIONS_ECHO="$OPTIONS_ECHO - create PS and PDF via texi2dvi and open PDF with $PDFAPP1\n"
            ;;
        -td | --texi2dvi2pdf)
            TEX=yes
            TEXI2DVI=yes
            PDFLATEX=yes
            OPTIONS=$(echo $OPTIONS | sed -e "s/--texi2dvi2pdf//" -e "s/-td//")
            OPTIONS_ECHO="$OPTIONS_ECHO - create PDF via pdflatex\n"
            ;;
        -otd* | --opentexi2dvi2pdf*)
            TEX=yes
            TEXI2DVI=yes
            PDFLATEX=yes
            PDFOPEN=yes
            PDFAPP1=$(echo $OPTION | sed -e "s/--opentexi2dvi2pdf=//"\
                                         -e "s/--opentexi2dvi2pdf//"\
                                         -e "s/-otd=//"\
                                         -e "s/-otd//")
            OPTIONS=$(echo $OPTIONS | sed -e "s|$OPTION||")
            if [ ! -n "$PDFAPP1" -a ! -n "$PDFAPP" ]; then
                PDFAPP1=$PDFAPPIN
            elif [ -n "$PDFAPP" ]; then
                PDFAPP1=$PDFAPP
            fi
            OPTIONS_ECHO="$OPTIONS_ECHO - create PDF via texi2dvi-pdflatex and open it with $PDFAPP1\n"
            ;;
        -lp | --latex2dvi2ps)
            TEX=yes
            LATEX=yes
            DVIPS=yes
            OPTIONS=$(echo $OPTIONS | sed -e "s/--latex2dvi2ps//" -e "s/-lp//")
            OPTIONS_ECHO="$OPTIONS_ECHO - create PS via latex\n"
            ;;
        -olp* | --openlatex2dvi2ps*)
            TEX=yes
            LATEX=yes
            DVIPS=yes
            PSOPEN=yes
            PSAPP1=$(echo $OPTION | sed -e "s/--openlatex2dvi2ps=//"\
                                        -e "s/--opentexi2dvi2pdf//"\
                                        -e "s/-olp=//"\
                                        -e "s/-olp//")
            OPTIONS=$(echo $OPTIONS | sed -e "s|$OPTION||")
            if [ ! -n "$PSAPP1" -a ! -n "$PSAPP" ]; then
                PSAPP1=$PSAPPIN
            elif [ -n "$PSAPP" ]; then
                PSAPP1=$PSAPP
            fi
            OPTIONS_ECHO="$OPTIONS_ECHO - create PS via latex and open it with $PSAPP1\n"
            ;;
        -lld | --latex2dvi2ps2pdf)
            TEX=yes
            LATEX=yes
            DVIPS=yes
            PS2PDF=yes
            OPTIONS=$(echo $OPTIONS | sed -e "s/--latex2dvi2ps2pdf//" -e "s/-lld//")
            OPTIONS_ECHO="$OPTIONS_ECHO - create PS and PDF via latex\n"
            ;;
        -olld* | --openlatex2dvi2ps2pdf*)
            TEX=yes
            LATEX=yes
            DVIPS=yes
            PS2PDF=yes
            PDFOPEN=yes
            PDFAPP1=$(echo $OPTION | sed -e "s/--openlatex2dvi2ps2pdf=//"\
                                         -e "s/--openlatex2dvi2ps2pdf//"\
                                         -e "s/-olld=//"\
                                         -e "s/-olld//")
            OPTIONS=$(echo $OPTIONS | sed -e "s|$OPTION||")
            if [ ! -n "$PDFAPP1" -a ! -n "$PDFAPP" ]; then
                PDFAPP1=$PDFAPPIN
            elif [ -n "$PDFAPP" ]; then
                PDFAPP1=$PDFAPP
            fi
            OPTIONS_ECHO="$OPTIONS_ECHO - create PS and PDF via latex and open PDF with $PDFAPP1\n"
            ;;
        -ld | --latex2pdf)
            TEX=yes
            PDFLATEX=yes
            OPTIONS=$(echo $OPTIONS | sed -e "s/--latex2pdf//" -e "s/-ld//")
            OPTIONS_ECHO="$OPTIONS_ECHO - create PDF via pdflatex\n"
            ;;
        -old* | --openlatex2pdf*)
            TEX=yes
            PDFLATEX=yes
            PDFOPEN=yes
            PDFAPP1=$(echo $OPTION | sed -e "s/--openlatex2pdf=//"\
                                         -e "s/--openlatex2pdf//"\
                                         -e "s/-old=//"\
                                         -e "s/-old//")
            OPTIONS=$(echo $OPTIONS | sed -e "s|$OPTION||")
            if [ ! -n "$PDFAPP1" -a ! -n "$PDFAPP" ]; then
                PDFAPP1=$PDFAPPIN
            elif [ -n "$PDFAPP" ]; then
                PDFAPP1=$PDFAPP
            fi
            OPTIONS_ECHO="$OPTIONS_ECHO - create PDF via pdflatex and open it with $PDFAPP1\n"
            ;;
        -optr=* | --optionsr=*)
            NEW=$(echo $OPTION | sed -e "s/--optionsr=//"\
                                     -e "s/-optr=//")
            OPTIONS=$(echo $OPTIONS | sed -e "s|$OPTION||")
            OPTR="$OPTR $NEW"
            OPTIONS_ECHO="$OPTIONS_ECHO - use $OPTR in R\n"
            ;;
        -optt=* | --optionstexi2dvi=*)
            NEW=$(echo $OPTION | sed -e "s/--optionstexi2dvi=//"\
                                     -e "s/-optt=//")
            OPTIONS=$(echo $OPTIONS | sed -e "s|$OPTION||")
            OPTTEXI2DVI="$OPTTEXI2DVI $NEW"
            OPTIONS_ECHO="$OPTIONS_ECHO - use $OPTTEXI2DVI in texi2dvi\n"
            ;;
        -optp=* | --optionsdvips=*)
            NEW=$(echo $OPTION | sed -e "s/--optionsdvips=//"\
                                     -e "s/-optp=//")
            OPTIONS=$(echo $OPTIONS | sed -e "s|$OPTION||")
            OPTDVIPS="$OPTDVIPS $NEW"
            OPTIONS_ECHO="$OPTIONS_ECHO - use $OPTDVIPS in dvips\n"
            ;;
        -optf=* | --optionsps2pdf=*)
            NEW=$(echo $OPTION | sed -e "s/--optionsps2pdf=//"\
                                     -e "s/-optf=//")
            OPTIONS=$(echo $OPTIONS | sed -e "s|$OPTION||")
            OPTPS2PDF="$OPTPS2PDF $NEW"
            OPTIONS_ECHO="$OPTIONS_ECHO - use $OPTPS2PDF in ps2pdf\n"
            ;;
        -optl=* | --optionslatex=*)
            NEW=$(echo $OPTION | sed -e "s/--optionslatex=//"\
                                     -e "s/-optl=//")
            OPTIONS=$(echo $OPTIONS | sed -e "s|$OPTION|")
            OPTLATEX="$OPTLATEX $NEW"
            OPTIONS_ECHO="$OPTIONS_ECHO - use $OPTLATEX in latex\n"
            ;;
        -optd=* | --optionspdflatex=*)
            NEW=$(echo $OPTION | sed -e "s/--optionspdflatex=//"\
                                     -e "s/-optd=//")
            OPTIONS=$(echo $OPTIONS | sed -e "s|$OPTION||")
            OPTPDFLATEX="$OPTPDFLATEX $NEW"
            OPTIONS_ECHO="$OPTIONS_ECHO - use $OPTPDFLATEX in pdflatex\n"
            ;;
        -optb=* | --optionsbibtex=*)
            NEW=$(echo $OPTION | sed -e "s/--optionsbibtex=//"\
                                     -e "s/-optb=//")
            OPTIONS=$(echo $OPTIONS | sed -e "s|$OPTION||")
            OPTBIBTEX="$OPTBIBTEX $NEW"
            OPTIONS_ECHO="$OPTIONS_ECHO - use $OPTBIBTEX in bibtex\n"
            ;;
        -optm=* | --optionsmakeindex=*)
            NEW=$(echo $OPTION | sed -e "s/--optionsmakeindex=//"\
                                     -e "s/-optm=//")
            OPTIONS=$(echo $OPTIONS | sed -e "s|$OPTION||")
            OPTMAKEINDEX="$OPTMAKEINDEX $NEW"
            OPTIONS_ECHO="$OPTIONS_ECHO - use $OPTMAKEINDEX in makeindex\n"
            ;;
        * ) # no options, just run Sweave and defaults
            ;;
    esac
done

# File list
FILES=$OPTIONS

# Options effect
if [ ! -n "$TEX" ]; then
    CLEAN=no
fi
if [ "$CLEAN" = "no" ]; then
    OPTTEXI2DVI=$(echo $OPTTEXI2DVI | sed -e "s/--clean//" -e "s/-c//")
fi
if [ "$QUIET" = "no" ]; then
    OPTTEXI2DVI=$(echo $OPTTEXI2DVI | sed -e "s/--quit//" -e "s/-q//")
fi

# Print usage if there is no input files
if [ ! -n "$FILES" ]; then
    echo -e "\nError: There is no input files! Usage is:\n"
    usage
    exit 1
fi

# --- Functions ---

# Weave & Tangle
sweaveWeave ()
{
    # $1 - file
    # $2 - logical [yes|no], should we weave?
    # $3 - logical [yes|no], should we tangle?
    if [ "$2" = "yes" -a "$3" = "no" ]; then
        echo "Sweave(\"$1\")" | R $OPTR
    elif [ "$2" = "yes" -a "$3" = "yes" ]; then
        echo "Stangle(\"$1\") ; Sweave(\"$1\")" | R $OPTR
    elif [ "$2" = "no" -a "$3" = "yes" ]; then
        echo "Stangle(\"$1\")" | R $OPTR
    fi
}

# Clean
sweaveClean ()
{
    # $1 - file
    # $2 - logical [yes|no], did we tangle?
    # R plots
    rm -f ${1}-*.pdf ${1}-*.eps Rplots.ps ${1}.dvi
    # Standard LaTeX
    rm -f ${1}.tex ${1}.log ${1}.aux ${1}.out ${1}.dvi
    # Other LaTeX
    rm -f ${1}.toc ${1}.lot ${1}.lof ${1}.loa ${1}.bbl ${1}.blg
    rm -f ${1}.bm ${1}.idx ${1}.ilg ${1}.ind ${1}.tex.dep
    if [ "$2" = "no" ]; then
        rm -f ${1}.R
    fi
}

# Check for error
sweaveError ()
{
    # $1 - character string, name of the "process"
    EXIT=$(echo $?)
    if [ "$EXIT" != "0" ]; then
        echo -e "\nAn error after use of '$1'!"
        if [ "$FORCE" = "no" ]; then
            echo -e "Quiting."
            exit 1
        fi
    fi
}

sweaveExt ()
{
    # $1 - file
    # Strip of .Rnw, .Snw or .nw from filename
    FILE=$(echo $1 | sed -e 's/\.[Rr][Nn][Ww]$//'\
                         -e 's/\.[Ss][Nn][Ww]$//'\
                         -e 's/\.[Nn][Ww]$//')
    echo $FILE
}

# The LaTeX machine
sweaveLatex ()
{
    # $1 - file
    # File extension
    FILE=$(sweaveExt $1)
    # texi2dvi
    if [ "$TEXI2DVI" = "yes" ]; then
        echo -e " - using 'texi2dvi'"
        if [ "$DVIPS" = "yes" ]; then
            echo -e "\nPostscript creation"
            texi2dvi $OPTTEXI2DVI ${FILE}.tex
            sweaveError "texi2dvi $OPTTEXI2DVI ${FILE}.tex"
            dvips $OPTDVIPS ${FILE}.dvi -o ${FILE}.ps
            sweaveError "dvips $OPTDVIPS ${FILE}.dvi -o ${FILE}.ps"
            if [ "$PSOPEN" = "yes" ]; then
                echo -e "\nPS opening"
                $PSAPP1 ${FILE}.ps &
                sweaveError "$PSAPP1 ${FILE}.ps &"
            fi
            if [ "$PS2PDF" = "yes" ]; then
                echo -e "\nPDF creation"
                $PS2PDFAPP $OPTPS2PDF ${FILE}.ps ${FILE}.pdf
                sweaveError "$PS2PDFAPP $OPTPS2PDF ${FILE}.ps ${FILE}.pdf"
                if [ "$PDFOPEN" = "yes" ]; then
                    echo -e "\nPDF opening"
                    $PDFAPP1 ${FILE}.pdf &
                    sweaveError "$PDFAPP1 ${FILE}.pdf &"
                fi
            fi
        elif [ "$PDFLATEX" = "yes" ]; then
            echo -e "\nPDF creation"
            texi2dvi $OPTTEXI2DVI --pdf ${FILE}.tex
            sweaveError "texi2dvi texi2dvi $OPTTEXI2DVI --pdf ${FILE}.tex"
            if [ -n "$PDFOPEN" ]; then
                echo -e "\nPDF opening"
                $PDFAPP1 ${FILE}.pdf &
                sweaveError "$PDFAPP1 ${FILE}.pdf &"
            fi
        fi
    # LaTeX and friends
    elif [ "$LATEX" = "yes" ]; then
        echo -e " - using hardcoded list of 'LaTeX and friends' commands"
        if [ "$DVIPS" = "yes" ]; then
            echo -e "\nPostscript creation"
            latex $OPTLATEX $FILE
            sweaveError "latex $OPTLATEX $FILE"
            bibtex $OPTBIBTEX $FILE
            makeindex $OPTMAKEINDEX $FILE
            latex $OPTLATEX $FILE
            sweaveError "latex $OPTLATEX $FILE"
            latex $OPTLATEX $FILE
            sweaveError "latex $OPTLATEX $FILE"
            dvips $OPTDVIPS ${FILE}.dvi -o ${FILE}.ps
            sweaveError "dvips $OPTDVIPS ${FILE}.dvi -o ${FILE}.ps"
            if [ "$PSOPEN" = "yes" ]; then
                echo -e "\nPS opening"
                $PSAPP1 ${FILE}.ps &
                sweaveError "$PSAPP1 ${FILE}.ps &"
            fi
            if [ "$PS2PDF" = "yes" ]; then
                echo -e "\nPDF creation"
                $PS2PDFAPP $OPTPS2PDF ${FILE}.ps ${FILE}.pdf
                sweaveError "$PS2PDFAPP $OPTPS2PDF ${FILE}.ps ${FILE}.pdf"
                if [ "$PDFOPEN" = "yes" ]; then
                    echo -e "\nPDF opening"
                    $PDFAPP1 ${FILE}.pdf &
                    sweaveError "$PDFAPP1 ${FILE}.pdf &"
                fi
            fi
        fi
    # pdfLaTeX and friends
    else
        echo -e " - using hardcoded list of 'pdfLaTeX and friends' commands"
        echo -e "\nPDF creation"
        pdflatex $OPTPDFLATEX $FILE
        sweaveError "pdflatex $OPTPDFLATEX $FILE"
        bibtex $OPTBIBTEX $FILE
        makeindex $OPTMAKEINDEX $FILE
        pdflatex $OPTPDFLATEX $FILE
        sweaveError "pdflatex $OPTPDFLATEX $FILE"
        pdflatex $OPTPDFLATEX $FILE
        sweaveError "pdflatex $OPTPDFLATEX $FILE"
        if [ -n "$PDFOPEN" ]; then
            echo -e "\nPDF opening"
            $PDFAPP1 ${FILE}.pdf &
            sweaveError "$PDFAPP1 ${FILE}.pdf &"
        fi
    fi

    # Remove PDF and EPS pictures, DVI files and other tmp LaTeX files
    if [ "$CLEAN" = "yes" ]; then
        sweaveClean $FILE $TANGLE
    fi
}

# -- Title ---
echo -e "\nRun Sweave and postprocess with LaTeX directly from command line"

# --- Report options ---
echo -e "$OPTIONS_ECHO"

# --- Main program ---
# Check file types
for FILE in $FILES; do
    LYX=$(echo $FILE | grep '.[Ll][Yy][Xx]$')
    RNW=$(echo $FILE | grep '.[Rr][Nn][Ww]$')
    SNW=$(echo $FILE | grep '.[Ss][Nn][Ww]$')
    NW=$(echo $FILE | grep '.[Nn][Ww]$')
    if [ -n "$LYX" ]; then
        NAME=$(echo $FILE | sed -e "s/\.[Ll][Yy][Xx]$//")
        echo -e " - exporting $FILE to ${NAME}.Rnw"
        lyx $FILE -e latex
        mv -f ${NAME}.tex ${NAME}.Rnw
        FILE=$(echo $FILE | sed -e "s/\.[Ll][Yy][Xx]$/\.Rnw/")
    elif [ ! -n "$RNW" -a ! -n "$SNW" -a ! -n "$NW" ]; then
        echo "$FILE is not supported file type!"
        echo "It should be one of .lyx, .Rnw, .Snw. or .nw"
        exit 1
    fi
    NEWFILES="$NEWFILES $FILE"
    unset LYX RNW SNW NW
done
FILES=$NEWFILES

# Clean old products
if [ "$CLEAN" = "yes" ]; then
    rm -f ${FILE}.pdf ${FILE}.ps
    sweaveClean $FILE $TANGLE
fi

# Sweave and LaTeX in direct mode
for FILE in $FILES; do
    if [ "$WEAVE" = "yes" -o "$TANGLE" = "yes" ]; then
        sweaveWeave $FILE $WEAVE $TANGLE
    fi
    sweaveError "R"
    if [ "$TEX" = "yes" -a "$MODE" = "yes" ]; then
        echo -e "\nLaTeX on produced TeX file i.e direct mode"
        sweaveLatex $FILE
    fi
done

# LaTeX in late mode
if [ "$TEX" = "yes" -a "$MODE" = "no" ]; then
    echo -e "\nLaTeX on produced TeX files"
    for FILE in $FILES; do
        sweaveLatex $FILE
    done
fi

# --- Exit ---
exit 0

#--------------------------------------------------------------------------
# Sweave.sh ends here
