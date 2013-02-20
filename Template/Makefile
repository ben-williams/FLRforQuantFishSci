gitroot=`git rev-parse --show-toplevel`
FILE=template

all:

knit:
	R -e "library(knitr); knit('$(FILE).Rmd')"

pdf: $(FILE).md
	pandoc -S --biblio $(FILE).bib $(FILE).md -o $(FILE).pdf

hmtl: $(FILE).md
	pandoc -S --biblio $(FILE).bib $(FILE).md -o $(FILE).html

clean:
	rm -rf *.log *.bbl *.blg *.out *.spl
