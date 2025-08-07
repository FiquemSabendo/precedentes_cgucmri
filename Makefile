.PHONY = download_files

download_files: data/processed/download_commands.txt
	cat $< \
		| xargs -L1 -P8 wget

data/raw/BuscaPrecedentes.csv:
	@mkdir -p data/raw
	wget https://dadosabertos-download.cgu.gov.br/BuscaPrecedentes/BuscaPrecedentes.csv -O $@

data/processed/busca_precedentes.csv: data/raw/BuscaPrecedentes.csv
	@mkdir -p data/processed
	iconv -f ISO-8859-1 -t utf-8 $< \
		| sed 's/[ \t]\+/ /g; s/^\s\+//; s/\;\s\+/\;/g; s/\s\+\;/\;/g; s/\s\+$$//' \
		> $@

data/processed/download_commands.txt: data/processed/busca_precedentes.csv
	@mkdir -p data/processed
	@mkdir -p data/raw/files
	cat $< \
		| grep -v "NomeArquivo;LinkArquivo" \
		| awk -f generate_wget_commands.awk \
		> $@

