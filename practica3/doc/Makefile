all: main.pdf 

main.pdf: *.tex
	mkdir -p figures
	pdflatex -shell-escape main.tex
	pdflatex -shell-escape main.tex

clean:
	rm -rf *.out *.pdf *.aux *.auxlock *.log *.bcf *.bbl *.blg *.run.xml *.toc figures/
