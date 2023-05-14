return {},
    {
      -- snippet #init Document Header
      s({ trig = "#init", name = "Document Header" }, {
        t({
          "\\documentclass[12pt]{article}",
          "\\usepackage[T1]{fontenc}",
          "\\usepackage[width=16cm, height=21cm]{geometry}",
          "\\usepackage[ngerman]{babel}",
          "\\usepackage[hidelinks]{hyperref}",
          "",
          "\\usepackage{amsmath}",
          "\\usepackage{bm}",
          "",
          "\\usepackage{tabularx}",
          "\\usepackage{booktabs}",
          "",
          "\\usepackage{graphicx}",
          "\\usepackage{subcaption}",
          "",
          "\\usepackage{csquotes}",
          "\\usepackage{enumitem}",
          "\\usepackage{textcomp}",
          "",
          "\\usepackage{fontspec}",
          "\\defaultfontfeatures{Mapping=tex-text}",
          "\\defaultfontfeatures{Ligatures=TeX}",
          "",
          "\\begin{document}",
          "\\author{Hawo Höfer}",
          "\\title{" }),
        i(1, "title"),
        t({
          "}",
          "\\maketitle",
          "\\tableofcontents",
          "\\clearpage",
          ""
        }),
        isn(2, i(1, "document"), "$PARENT_INDENT  "),
        t({ "", "\\end{document}" })
      }),

      -- snippet #graph Graphic Figure
      s({ trig = "#img", name = "Image Figure" }, {
        t({ "\\begin{figure}[h]",
          "\\centering",
          "\\includegraphics[width=" }),
        i(1),
        t "\\textwidth]{", i(2),
        t({ "}",
          "\\caption{" }),
        i(3), t({ "}",
          "\\label{fig:" }),
        i(4, "label"),
        t({ "}", "\\end{figure}", "" }),
        i(5)
      }),

      s({ trig = "#Svg", name = "Image Figure" }, {
        t("\\begin{figure}[h]"),
        isn(1, {
          t({ "\\centering",
            "\\def\\svgwidth{" }),
          i(1, "size"), t({ "\\textwidth]}",
            "\\input{" }), i(2, "file"),
          t({ "}",
            "\\caption{" }), i(3), t({ "}",
            "\\label{fig:" }),
          i(4, "label"), t("}")
        }, "$PARENT_INDENT  "),
        t({ "", "\\end{figure}", "" }),
        i(5)
      }),

      s({ trig = "#tw", name = "textwidth" }, t [[\textwidth]]),

      s({ trig = "#s", name = "section" }, {
        t [[\section{]],
        i(1, "section"),
        t [[}]],
        i(2),
      }),
      s({ trig = "#Ss", name = "subsection" }, {
        t [[\subsection{]],
        i(1, "subsection"),
        t [[}]],
        i(2),
      }),
      s({ trig = "#SSs", name = "subsubsection" }, {
        t [[\subsubsection{]],
        i(1, "subsubsection"),
        t [[}]],
        i(2),
      }),
      s({ trig = "#pa", name = "paragraph" }, {
        t [[\paragraph{]],
        i(1, "paragraph"),
        t [[}]],
        i(2),
      }),

      s({ trig = "#frm", name = "Beamer frame" }, {
        t [[\begin{frame}{]], i(1, "frametitle"), t { "}", "  " },
        isn(2, { t { "  " }, i(1, "content") }, "$PARENT_INDENT  "),
        t { "", [[\end{frame}]] }
      }),

      s({ trig = "#mp", name = "Minipage" }, {
        t { [[\begin{minipage}[c]{0.5\textwidth}]], "" },
        isn(1, { t { "  " }, i(1, "content") }, "$PARENT_INDENT  "),
        t { "", [[\end{minipage}]] },
      }),

      s({ trig = "#oenv", name = "Environment with Options" }, {
        t [[\begin{]], i(1), t "}[", i(2, "option"), t { "]", "  " },
        isn(3, { t { "  " }, i(1, "content") }, "$PARENT_INDENT  "),
        t { "", [[\end{]] }, d(4, function(args) return sn(nil, { i(1, args[1]) }) end, { 1 }), t [[}]],
      }),
      s({ trig = "#env", name = "Environment" }, {
        t [[\begin{]], i(1), t { "}", "" },
        isn(2, { t { "  " }, i(1, "content") }, "$PARENT_INDENT  "),
        t { "", [[\end{]] }, d(3, function(args) return sn(nil, { i(1, args[1]) }) end, { 1 }), t [[}]],
      }),
      s({ trig = "#eqn", name = "Equation" }, {
        t { [[\begin{equation}]], "" },
        isn(1, { t { "  " }, i(1, "content") }, "$PARENT_INDENT  "),
        t { "", [[\end{equation}]] },
      }),

      s({ trig = "#imz", name = "Itemize" }, {
        t { [[\begin{itemize}]], "" },
        isn(1, { t { "  " }, i(1, "content") }, "$PARENT_INDENT  "),
        t { "", [[\end{itemize}]] },
      }),

      s({ trig = "#enum", name = "Enumerate" }, {
        t { [[\begin{enumerate}]], "" },
        isn(1, { t { "  " }, i(1, "content") }, "$PARENT_INDENT  "),
        t { "", [[\end{enumerate}]] },
      }),

      s({ trig = "#ii", name = "item" }, t [[\item ]]),
      s({ trig = "#i+", name = "item +" }, t [[\item[+] ]]),
      s({ trig = "#i-", name = "item -" }, t [[\item[-] ]]),

      s({ trig = "#l", name = "label" }, {
        t [[\label{]],
        i(1, "label"),
        t [[}]],
        i(2),
      }),
      s({ trig = "#r", name = "reference" }, {
        t [[\ref{]],
        i(1, "ref"),
        t [[}]],
        i(2),
      }),
      s({ trig = "#c", name = "citation" }, {
        t [[\cite{]],
        i(1, "cit"),
        t [[}]],
        i(2),
      }),
      s({ trig = "(.*)__", name = "subscript", regTrig = true }, {
        f(function(args, snip) return snip.captures[1] .. [[_\text{]]
        end, {}),
        i(1, "subscript"),
        t [[}]],
        i(2),
      }),
      s({ trig = "(.*)^^", name = "superscript", regTrig = true }, {
        f(function(args, snip) return snip.captures[1] .. [[^\text{]]
        end, {}),
        i(1, "superscript"),
        t [[}]],
        i(2),
      }),
      s({ trig = "%*(.*)%*", name = "bold", regTrig = true }, {
        f(function(args, snip) return [[\textbf{]] .. snip.captures[1] .. [[}]]
        end, {}),
      }),
      s({ trig = "#bf", name = "bold" }, {
        t [[\textbf{]],
        i(1, "bold"),
        t [[}]],
        i(2),
      }),
      s({ trig = "#mb", name = "math bold" }, {
        t [[\bm{]],
        i(1, "bold"),
        t [[}]],
        i(2),
      }),
      s({ trig = "#mr", name = "math roman" }, {
        t [[\mathrm{]],
        i(1, "roman"),
        t [[}]],
        i(2),
      }),
      s({ trig = "#cp", name = "clearpage" }, {
        t { [[\clearpage]], "", "" }
      }),

      s({ trig = "#tbx", name = "tabularx" }, {
        t [[\begin{tabularx}{]], i(1, "width"), t [[\textwidth}{]], i(2, "alignment"), t { "}", "" },
        isn(3, { t { "  " }, i(1, "content") }, "$PARENT_INDENT  "),
        t("", [[\end{tabularx}]], ""),
        i(4),
      }),

      s({ trig = "#tbl", name = "table float" }, {
        t { "\\begin{table}[h]", "" },
        isn(1, {
          t { [[\centering]], [[\begin{tabularx}{]] }, i(1, "width"), t [[\textwidth}{]], i(2, "alignment"), t { "}", "" },
          isn(3, { t { "  " }, i(1, "content") }, "$PARENT_INDENT  "),
          t { "", [[\end{tabularx}]], "" },
          t [[\caption{]], i(4, "caption"), t({ "}" }),
        }, "$PARENT_INDENT  "),
        t { "", [[\end{table}]] },
      }),

      s({ trig = "°", name = "degrees" }, t [[^{\circ}]]),
      s({ trig = "#Scb", name = "subcaptionbox" }, {
        t [[\subcaptionbox{]], i(1, "caption"), t "}{", { t { "  " }, i(2, "content") }, t "}", i(3)
      }),
      s({ trig = "#Sci", name = "subcaptionbox image" }, {
        t [[\subcaptionbox{]], i(1, "caption"), t "}{\\includegraphics[width=", i(2, "width"), t "\textwidth]{",
        i(3, "image path"), t "}"
      }),

      s({ trig = "(.*)#%(", name = "leftright(", regTrig = true }, {
        f(function(args, snip) return snip.captures[1] .. [[\left(]] end, {}),
        i(1),
        t [[\right)]],
        i(2),
      }),
      s({ trig = "(.*)#%[", name = "leftright[", regTrig = true }, {
        f(function(args, snip) return snip.captures[1] .. "\\left[" end, {}),
        i(1),
        t "\\right]",
        i(2),
      }),
      s({ trig = "(.*)#{", name = "leftright{", regTrig = true }, {
        f(function(args, snip) return snip.captures[1] .. [[\left{]] end, {}),
        i(1),
        t [[\right}]],
        i(2),
      }),

      s({ trig = "**", name = "cdot" }, t [[\cdot]]),
      s({ trig = "#>", name = "math rightarrow" }, t [[\rightarrow]]),
      s({ trig = "#<", name = "math leftarrow" }, t [[\leftarrow]]),
      s({ trig = "-->", name = "text rightarrow" }, t [[$\rightarrow$]]),
      s({ trig = "<--", name = "text leftarrow" }, t [[$\leftarrow$]]),
      s({ trig = "==>", name = "double rightarrow" }, t [[$\Rightarrow$]]),
      s({ trig = "<==", name = "double leftarrow" }, t [[$\Leftarrow$]]),
      s({ trig = "##>", name = "double rightarrow" }, t [[$\Rightarrow$]]),
      s({ trig = "<##", name = "double leftarrow" }, t [[$\Leftarrow$]]),

      s({ trig = [["(.*)"]], name = "enquote", regTrig = true }, {
        t [[\enquote{]],
        f(function(args, snip) return snip.captures[1] end, {}),
        t "}",
      }),

      s({ trig = [[//(.+)//]], name = "emph", regTrig = true }, {
        t [[\emph{]],
        f(function(args, snip) return snip.captures[1] end, {}),
        t [[}]],
      }),

      s({ trig = [[|(.+)/(.+)|]], name = "frac", regTrig = true }, {
        t [[\frac{]],
        f(function(args, snip) return snip.captures[1] end, {}),
        t [[}{]],
        f(function(args, snip) return snip.captures[2] end, {}),
        t [[}]],
      }),

      -- snippet #Sum Sum
      -- 	\sum_{${1:sub}}^{${2:super}}$3

      -- snippet #SSum Sum no super
      -- 	\sum_{${1:sub}}$3

      -- snippet #prod Product
      -- 	\prod_{${1:sub}}^{${2:super}}$3

      -- snippet #int Integral
      -- 	\int_{${1:sub}}^{${2:super}}$3

      -- snippet #fpgf pgf plot figure
      -- 	\begin{figure}[h]
      -- 		\centering
      -- 		\begin{tikzpicture}
      -- 			\begin{axis}[
      -- 				width = ${1:width}\textwidth,
      -- 				height = ${2:height}\textwidth,
      -- 				samples = 100,
      -- 				xlabel = {${3:xlabel}},
      -- 				ylabel = {${4:ylabel}},
      --			x label style = {at = {(axis description cs:1.0,0)}},
      --
      -- 				y label style = {at = {(axis description cs:0,1.0)}, rotate=90},
      -- 				line width = 1pt,
      -- 				axis y line = left,
      -- 				axis x line = bottom,
      -- 				axis line style = {->},
      -- 				legend cell align = left,
      -- 			]
      -- 				$5
      -- 			\end{axis}
      -- 		\end{tikzpicture}
      -- 	\end{figure}

      -- snippet #ppa pgf add plot
      -- 	\addplot[${1:opts}]{${2:func}};


      -- snippet #comptbl comparison table
      -- 	\begin{tabularx}{\textwidth}{X X}
      -- 		\toprule
      -- 		\textbf{Vorteile} & \textbf{Nachteile} \\\\
      -- 		\midrule
      -- 		\begin{itemize}[label={+}, topsep=0pt]
      -- 			\raggedright
      -- 			\item ${1:positives}
      -- 		\end{itemize}
      -- 			&
      -- 		\begin{itemize}[label={--}, topsep=0pt]
      -- 			\raggedright
      -- 			\item ${2:negatives}
      -- 		\end{itemize}
      -- 		\\\\
      -- 		\bottomrule
      -- 	\end{tabularx}

      -- snippet #deftbl definition table
      -- 	\begin{table}[h]
      -- 		\centering
      -- 		\begin{tabularx}{0.9\textwidth}{>{\bfseries\hsize=0.5\hsize}X >{\hsize=1.5\hsize}X}
      -- 			\toprule
      -- 			${1:content}
      -- 			\bottomrule
      -- 		\end{tabularx}
      -- 		\caption{${2:caption}}
      -- 	\end{table}

      -- snippet #tikzf Tikz picture Figure
      -- 	\begin{figure}[h]
      -- 		\centering
      -- 		\begin{tikzpicture}[
      -- 			std/.style={ draw, rectangle, text width=8em },
      -- 			line width=0.3mm,
      -- 			align=center,
      -- 			]
      -- 			${1:content}
      -- 		\end{tikzpicture}
      -- 		\caption{${2:caption}}
      -- 		\label{${3:label}}
      -- 	\end{figure}

      -- snippet #tg Tikz graph
      -- 		\tikz [>={Stealth[round, sep]}]
      -- 			\graph [layered layout,
      -- 							components go right top aligned,
      -- 							edges = rounded corners,
      -- 							nodes = {rectangle, rounded corners, draw}] {
      -- 			$1
      -- 		};
    }
