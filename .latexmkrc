use File::Path qw(make_path);

# ---- Engine ----
# This project requires LuaLaTeX: template/preamble.tex loads
# \usepackage[luatex]{graphicx}, which hard-errors under pdfLaTeX.
$pdf_mode  = 4;     # 4 = lualatex
$lualatex  = 'lualatex -synctex=1 -interaction=nonstopmode -file-line-error %O %S';

# ---- Bibliography ----
$bibtex_use = 2;    # run biber, and clean the generated .bbl
$biber      = 'biber %O %S';

# ---- Keep the source tree clean ----
# Everything (PDF, aux, log, synctex, bcf, bbl, fdb_latexmk) lands in out/.
$out_dir = 'out';
$aux_dir = 'out';

# LaTeX will not create nested output directories on its own, so
# \include{content/introduction} fails under -outdir unless out/content/
# already exists. Mirror the source tree's directories inside out/.
my @srcdirs = grep { !m{^\Q$out_dir\E(/|$)} }
              map  { my $d = $_; $d =~ s{/$}{}; $d }
              glob('*/ */*/');
make_path(map { "$out_dir/$_" } @srcdirs);

# `latexmk -c` / `-C` should also sweep these.
$clean_ext = 'bbl bcf run.xml synctex.gz fdb_latexmk fls';
