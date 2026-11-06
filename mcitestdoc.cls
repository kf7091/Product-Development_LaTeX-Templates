% =====================================================================
%  mcitestdoc.cls  --  MCI Test Plan / Test Report
%  LaTeX-Umsetzung der Word-Vorlagen "Test Plan Template.docx"
%  und "Test Report Template.docx".
%
%  Klassenoptionen:
%    plan     -> Dokumenttyp "Test Plan"   (Doc. No. TPYY-###)  [Standard]
%    report   -> Dokumenttyp "Test Report" (Doc. No. RPYY-###)
%    final    -> blendet alle blauen Hinweistexte (\hint, hintblock)
%                und die NOTE-Zeile aus
%
%  Kompilieren: pdflatex, XeLaTeX oder LuaLaTeX (latexmk empfohlen)
% =====================================================================
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{mcitestdoc}[2026/11/06 v1.0 MCI Test Plan / Test Report]

% ---------------------------------------------------------------------
%  Optionen
% ---------------------------------------------------------------------
\newif\if@mci@report \@mci@reportfalse
\newif\ifmcihints    \mcihintstrue
\DeclareOption{plan}{\@mci@reportfalse}
\DeclareOption{report}{\@mci@reporttrue}
\DeclareOption{final}{\mcihintsfalse}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

\LoadClass[11pt,a4paper]{article}

% ---------------------------------------------------------------------
%  Pakete
% ---------------------------------------------------------------------
\RequirePackage{iftex}
\ifPDFTeX
  \RequirePackage[T1]{fontenc}
  \RequirePackage[utf8]{inputenc}
  % Carlito = metrisch kompatibler Calibri-Klon; sonst Helvetica
  \IfFileExists{carlito.sty}
    {\RequirePackage[sfdefault,lf]{carlito}}
    {\RequirePackage[scaled=0.92]{helvet}\renewcommand*\familydefault{\sfdefault}}
\else
  % XeLaTeX / LuaLaTeX: Calibri verwenden, falls installiert
  \RequirePackage{fontspec}
  \IfFontExistsTF{Calibri}
    {\setmainfont{Calibri}\setsansfont{Calibri}}
    {\IfFontExistsTF{Carlito}{\setmainfont{Carlito}\setsansfont{Carlito}}{}}
\fi
\RequirePackage[english]{babel}
\RequirePackage[a4paper,top=2.5cm,bottom=2cm,left=2.5cm,right=2.5cm,
                headheight=1.1cm,headsep=0.5cm,footskip=1cm]{geometry}
\RequirePackage[table]{xcolor}
\RequirePackage{graphicx}
\RequirePackage{array,tabularx,multirow}
\RequirePackage{fancyhdr}
\RequirePackage{lastpage}
\RequirePackage{titlesec}
\RequirePackage{enumitem}
\RequirePackage{caption}
\RequirePackage{float}
\RequirePackage{etoolbox}
\RequirePackage{microtype}
\RequirePackage[hidelinks]{hyperref}

% ---------------------------------------------------------------------
%  Farben (aus der Word-Vorlage)
% ---------------------------------------------------------------------
\definecolor{hintblue}{HTML}{4472C4}     % blaue Hinweistexte
\definecolor{placeholder}{HTML}{FF0000}  % rote Platzhalter
\definecolor{tablehead}{HTML}{D9D9D9}    % graue Tabellenkopfzeile
\definecolor{captiongray}{HTML}{44546A}

% ---------------------------------------------------------------------
%  Dokumentdaten
% ---------------------------------------------------------------------
\newcommand*\mci@ph[1]{\textcolor{placeholder}{#1}}
\if@mci@report
  \newcommand*\mci@doctype{Test Report}
  \newcommand*\mci@docnumber{\mci@ph{RPYY-\#\#\#}}
\else
  \newcommand*\mci@doctype{Test Plan}
  \newcommand*\mci@docnumber{\mci@ph{TPYY-\#\#\#}}
\fi
\newcommand*\mci@doctitle{\mci@ph{TITLE}}
\newcommand*\mci@docrevision{1.0}
\newcommand*\mci@originator{\mci@ph{Originator}}
\newcommand*\mci@logo{mci_logo}

\newcommand*\doctitle[1]{\renewcommand*\mci@doctitle{#1}}
\newcommand*\docnumber[1]{\renewcommand*\mci@docnumber{#1}}
\newcommand*\docrevision[1]{\renewcommand*\mci@docrevision{#1}}
\newcommand*\originator[1]{\renewcommand*\mci@originator{#1}}
\newcommand*\doctype[1]{\renewcommand*\mci@doctype{#1}}
\newcommand*\doclogo[1]{\renewcommand*\mci@logo{#1}}

% Zugriff im Dokument (z. B. in der Revisionstabelle)
\newcommand*\thedoctitle{\mci@doctitle}
\newcommand*\thedocnumber{\mci@docnumber}
\newcommand*\thedocrevision{\mci@docrevision}
\newcommand*\theoriginator{\mci@originator}

\AtBeginDocument{%
  \hypersetup{pdftitle={\mci@doctype}, pdfsubject={\mci@doctype}}}

% ---------------------------------------------------------------------
%  Seitenzahl "x of y"
% ---------------------------------------------------------------------
\newcommand*\mci@pageof{\textbf{\thepage} of \textbf{\pageref*{LastPage}}}

% ---------------------------------------------------------------------
%  Kopf Seite 1 (großer Kasten mit Logo) -> \makeheader
% ---------------------------------------------------------------------
\newcommand\makeheader{%
  \thispagestyle{mcifirst}%
  \vspace*{-1.3cm}%
  \noindent
  {\small\renewcommand\arraystretch{1.25}%
   \setlength\tabcolsep{4pt}%
   \begin{tabularx}{\linewidth}{|>{\raggedright\arraybackslash}p{0.40\linewidth}|X|>{\raggedright\arraybackslash}p{0.17\linewidth}|}
     \hline
     \parbox[c][2.4cm][c]{\linewidth}{\centering
       \IfFileExists{\mci@logo.png}{\includegraphics[height=1.9cm]{\mci@logo}}{%
         \IfFileExists{\mci@logo.pdf}{\includegraphics[height=1.9cm]{\mci@logo}}{\textbf{MCI}}}}
       & \multicolumn{2}{c|}{\Large\mci@doctype} \\
     \hline
     Title: \mci@doctitle & Doc. No.: \mci@docnumber & Rev.: \mci@docrevision \\
     \hline
     Originator: \mci@originator & \multicolumn{2}{r|}{Page \mci@pageof} \\
     \hline
   \end{tabularx}}%
  \par\vspace{1.2em}%
  \ifmcihints
    \noindent{\color{hintblue}\bfseries\itshape\small NOTE: Blue italic text shall be removed.}\par
    \vspace{0.6em}%
  \fi
}

% ---------------------------------------------------------------------
%  Kopf Folgeseiten (einzeilige Tabelle)
% ---------------------------------------------------------------------
\newcommand\mci@contheader{%
  {\footnotesize\renewcommand\arraystretch{1.1}%
   \setlength\tabcolsep{4pt}%
   \begin{tabularx}{\headwidth}{|>{\raggedright\arraybackslash}X|*{4}{>{\centering\arraybackslash}p{0.13\headwidth}|}}
     \hline
     Title: \mci@doctitle
       & Doc. No.:\newline \mci@docnumber
       & Rev.:\newline \mci@docrevision
       & Originator:\newline \mci@originator
       & Page:\newline \mci@pageof \\
     \hline
   \end{tabularx}}}

\fancypagestyle{mcifirst}{%
  \fancyhf{}%
  \renewcommand\headrulewidth{0pt}%
  \renewcommand\footrulewidth{0pt}}
\fancypagestyle{mcicont}{%
  \fancyhf{}%
  \fancyhead[C]{\mci@contheader}%
  \renewcommand\headrulewidth{0pt}%
  \renewcommand\footrulewidth{0pt}}
\pagestyle{mcicont}

% ---------------------------------------------------------------------
%  Überschriften: "1.0  Facility", "6.1  Description ..."
% ---------------------------------------------------------------------
\setcounter{secnumdepth}{3}
\titleformat{\section}
  {\fontsize{16}{19}\selectfont}{\makebox[1.4cm][l]{\thesection.0}}{0pt}{}
\titleformat{\subsection}
  {\fontsize{13}{16}\selectfont}{\makebox[1.4cm][l]{\thesubsection}}{0pt}{}
\titleformat{\subsubsection}
  {\fontsize{12}{14}\selectfont}{\makebox[1.4cm][l]{\thesubsubsection}}{0pt}{}
\titlespacing*{\section}{0pt}{1.4em}{0.3em}
\titlespacing*{\subsection}{0pt}{0.9em}{0.2em}
\titlespacing*{\subsubsection}{0pt}{0.8em}{0.2em}

% Absätze wie in Word: kein Einzug, Abstand danach
\setlength\parindent{0pt}
\setlength\parskip{0.5em plus 0.2em}

% Listen
\setlist{nosep, leftmargin=1.8em}
\setlist[enumerate]{label=\alph*.}

% ---------------------------------------------------------------------
%  Hinweistexte (blau, kursiv) -- entfallen mit Option "final"
%    \hint{...}                      kurzer Hinweis
%    \begin{hintblock} ... \end{hintblock}   Hinweis mit Listen etc.
% ---------------------------------------------------------------------
\newcommand\hint[1]{\ifmcihints\leavevmode{\color{hintblue}\itshape\small #1}\fi}
\NewDocumentEnvironment{hintblock}{+b}
  {\ifmcihints{\color{hintblue}\nobreak\itshape\small #1\par}\fi}{}

% ---------------------------------------------------------------------
%  Tabellen
% ---------------------------------------------------------------------
\captionsetup[table]{position=top, labelsep=period, justification=raggedright,
  singlelinecheck=false, font=small, skip=3pt}
\newcolumntype{L}{>{\raggedright\arraybackslash}X}
\renewcommand\arraystretch{1.3}
% Kopfzeilen-Zelle:  \hd{Role:}
\newcommand\hd[1]{\cellcolor{tablehead}\textbf{#1}}
% Mindesthöhe für leere Tabellenzeilen: \strutrow & & \\ \hline
\newcommand\strutrow{\rule{0pt}{1.3em}}

% Unterschriftentabelle (Abschnitt "Signatures")
\newcommand\signaturetable{%
  \par\noindent
  {\small
   \begin{tabularx}{\linewidth}{|>{\raggedright\arraybackslash}p{2.2cm}|X|X|X|X|}
     \hline
     \parbox[t][1.8cm][t]{2.2cm}{Development\\Team} & & & & \\ \hline
     \parbox[t][1.8cm][t]{2.2cm}{Testing Team}      & & & & \\ \hline
   \end{tabularx}}\par}

\endinput
