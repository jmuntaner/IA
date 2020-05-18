all: main.pdf presentation.pdf

main.pdf: *.tex *.bib
	mkdir -p figures
	pdflatex -shell-escape main.tex
	biber main
	pdflatex -shell-escape main.tex
	pdflatex -shell-escape main.tex

presentation.pdf: presentation.md
	pandoc -t beamer presentation.md -o presentation.pdf --highlight-style zenburn

clean:
	rm -rf *.pdf *.aux *.log *.bcf *.bbl *.blg *.run.xml figures/
