#
DOC=FLStock.md
OUT=../$(DOC).pdf

HEADER=`git rev-parse --show-toplevel`/Template/jrc/header.tex

all: $(OUT)

$(OUT): $(DOC)
	pandoc -t beamer -S -H $(HEADER) $(DOC) -o $(OUT)

clean:
	rm -f $(OUT)
