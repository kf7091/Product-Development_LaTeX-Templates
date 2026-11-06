# MCI LaTeX-Vorlagen: Test Plan & Test Report

LaTeX-Umsetzung von `Test Plan Template.docx` und `Test Report Template.docx`.

| Datei | Inhalt |
|---|---|
| `Test_Plan.tex` | Test Plan (Doc. No. `TPYY-###`) |
| `Test_Report.tex` | Test Report (Doc. No. `RPYY-###`) |
| `mcitestdoc.cls` | Gemeinsame Dokumentklasse (Layout, Kopfzeilen, Tabellen) |
| `mci_logo.png` | MCI-Logo aus der Word-Vorlage |

## Verwendung

1. Gewünschte `.tex`-Datei kopieren (Klasse und Logo im selben Ordner lassen).
2. Dokumentdaten in der Präambel eintragen. Solange sie fehlen, erscheinen die roten Platzhalter wie in Word:
   ```latex
   \doctitle{Fatigue Test of Bracket XY}
   \docnumber{TP26-001}
   \docrevision{1.0}
   \originator{Max Mustermann}
   ```
3. Kompilieren: `latexmk -pdf Test_Plan.tex` (pdfLaTeX, XeLaTeX und LuaLaTeX funktionieren).

## Blaue Hinweistexte

Die Ausfülltexte der Word-Vorlage stehen in `\hint{...}` bzw. `\begin{hintblock} ... \end{hintblock}`.
Statt sie von Hand zu löschen, reicht die Klassenoption `final`:

```latex
\documentclass[plan,final]{mcitestdoc}
```

Damit verschwinden alle Hinweise und die Zeile „NOTE: Blue italic text shall be removed.“

## Tabellen

- Kopfzeilen-Zelle: `\hd{Role:}` (fett, grau hinterlegt)
- Leere Zeile mit Mindesthöhe: `\strutrow & & \\ \hline`
- Unterschriftenblock: `\signaturetable`
- Originator in der Revisionstabelle: `\theoriginator`

## Schrift

Word nutzt Calibri. Mit pdfLaTeX wird **Carlito** (metrisch identischer Calibri-Klon, Paket `carlito`) verwendet,
falls installiert, sonst Helvetica. Mit XeLaTeX/LuaLaTeX wird Calibri direkt genutzt, wenn sie auf dem System vorhanden ist.
