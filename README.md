<!-- README written by Claude -->

# Master Thesis

TU Graz KOMA-Script thesis template. Root file is `main.tex`, the compiled PDF
lands in `out/main.pdf` (the whole `out/` directory is gitignored).

## Requirements

- **A TeX distribution with LuaLaTeX** — TeX Live 2025 (what CI uses), MiKTeX, or
  MacTeX. Install the full scheme (`scheme-full` / MiKTeX "complete") unless you
  enjoy chasing missing packages.
  LuaLaTeX is mandatory: `template/preamble.tex` loads
  `\usepackage[luatex]{graphicx}`, which hard-errors under pdfLaTeX.
- **latexmk** — needs Perl. Bundled with TeX Live and MiKTeX on Windows; on Linux
  install `perl` and `latexmk` from the package manager.
- **biber** — a separate binary, not a LaTeX package. Its version must match the
  installed biblatex version, otherwise you get
  `biber: Cannot find 'main.bcf'` or a version-mismatch warning.
- *Optional:* `fontconfig` + Noto CJK fonts, only if CJK glyphs appear in the
  text. CI installs `fontconfig font-noto-cjk font-noto-cjk-extra`.

### LaTeX packages

All included in a full TeX Live / MiKTeX install. Listed for minimal setups:

| Group | Packages |
| --- | --- |
| Class & layout | `koma-script` (scrbook, scrlayer-scrpage), `geometry`, `eso-pic`, `afterpage`, `placeins`, `footmisc`, `framed` |
| Bibliography & language | `biblatex`, `biblatex-apa`, `biber`, `babel` (ngerman + american), `csquotes` |
| Fonts & typography | `mathpazo`/`psnfss`, `lmodern`, `microtype`, `fontawesome5`, `pifont`, `soul`, `ulem` |
| Graphics & tables | `graphicx`, `subcaption`, `booktabs`, `amsmath`, `units`, `tcolorbox`, `xcolor` |
| Utilities | `etoolbox`, `ifthen`, `xspace`, `enumitem`, `lipsum`, `hyperref` |

## Building the PDF

`.latexmkrc` already sets the engine (LuaLaTeX), the bibliography backend (biber)
and the output directory (`out/`), so a bare `latexmk` is all it takes:

```bash
latexmk        # build main.tex -> out/main.pdf
latexmk -pvc   # watch and rebuild on every save
latexmk -c     # remove aux files, keep the PDF
latexmk -C     # remove everything, including the PDF
```

Do **not** run `lualatex main.tex` directly — `.latexmkrc` is what creates the
`out/content/`, `out/template/` subdirectories that `\include{}` needs, and what
runs biber. A first build takes several passes (lualatex → biber → lualatex ×2)
before references and the table of contents settle.

## VS Code

`.vscode/settings.json` is committed and configures the lualatex + biber recipe,
pins `main.tex` as the root file, sends output to `out/`, and enables the SyncTeX
preview. Nothing to set up per machine — just install the extensions below.

Build with `Ctrl+Alt+B`, or pick a recipe from the LaTeX sidebar
("latexmk (lualatex + biber)" or "latexmk clean").

### Suggested extensions

`.vscode/extensions.json` lists these, so VS Code offers them on first open:

- **`James-Yu.latex-workshop`** — required; the committed settings do nothing without it.
- `ltex-plus.vscode-ltex-plus` — grammar/style checking that understands LaTeX markup and the ngerman + american mix.
- `streetsidesoftware.code-spell-checker` + `streetsidesoftware.code-spell-checker-german` — spell checking in both languages.
- `tomoki1207.pdf` — fallback PDF viewer if you'd rather not use the Workshop tab.
- `nickfode.latex-formatter` — optional; note `editor.formatOnSave` is deliberately off for `[latex]`.

## CI

`.github/workflows/build.yml` compiles the thesis on every push and pull request
to `main` using `xu-cheng/latex-action@v4` with TeX Live 2025. The PDF is
uploaded as a build artifact and deployed to GitHub Pages. A green build is the
reference for "this still compiles on a clean machine".
