#
DOC=FLStock

all:
	pandoc -t beamer -H tex/header.tex -i $(DOC).md -o $(DOC).pdf

tex:
	pandoc -t beamer -H tex/header.tex -i $(DOC).md -o $(DOC).tex

clean:
	rm -f $(DOC).aux $(DOC).log $(DOC).out

cleanall: clean
	rm -f $(DOC).pdf
