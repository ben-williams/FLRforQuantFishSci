#
DOC=Intro_FLR.md
OUT=../$(DOC).pdf

all: $(OUT)

$(OUT): $(DOC)
	pandoc -t beamer -S -H tex/header.tex $(DOC) -o $(OUT)

clean:
	rm -f $(OUT)
