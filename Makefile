project_description.pdf: project_description.tex
	pdflatex project_description.tex
	pdflatex project_description.tex
	rm project_description.{out,log,aux}
