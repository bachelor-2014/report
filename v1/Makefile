MD = titlepage.md abstract.md toc.md introduction.md problem_statement.md existing_robot.md goals.md architecture.md hardware.md choice_of_language.md gui.md programmability.md logging.md tracking.md scanning.md discussion.md conclusion.md acknowledgements.md references.md
BIB = bibliography.bib
ARGS = --number-sections --bibliography=$(BIB) --include-in-head=header.tex --chapters --variable documentclass=report

default: report.pdf

report.pdf: $(MD) header.tex $(BIB)
	pandoc $(ARGS) -o report.pdf $(MD)

MD2 = toc.md report2.md
report2.pdf: $(MD2) header.tex
	pandoc $(ARGS) -o report2.pdf $(MD2)
