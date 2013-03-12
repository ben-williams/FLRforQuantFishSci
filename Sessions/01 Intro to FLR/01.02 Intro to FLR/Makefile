#
DOC=Intro_FLR

all:
	pandoc -t beamer -i $(DOC).md -o $(DOC).pdf

md2tex:
	pandoc -t beamer -i $(DOC).md -o $(DOC).tex

adapt:
	perl -pe 's/\\section/\\end{frame}\n\\begin{frame}/' -i $(DOC).tex
	perl -pe 's/\\end{document}/\\end{frame}\n\\end{document}/' -i $(DOC).tex

pdflatex:
	pdflatex $(DOC).tex </dev/null
	pdflatex $(DOC).tex </dev/null

clean:
	rm -f $(DOC).aux $(DOC).log $(DOC).out

cleanall: clean
	rm -f $(DOC).pdf
