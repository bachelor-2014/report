MD = header.md titlepage.md abstract.md toc.md introduction.md goals.md architecture.md hardware.md software.md computer_vision.md discussion.md conclusion.md references.md
BIB = bibliography.bib

all: report.pdf

report.pdf: $(MD) $(BIB)
	pandoc --bibliography=$(BIB) -o report.pdf $(MD)
