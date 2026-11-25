-- page_text: 15 pages carried HTML line breaks without the <HTML><BODY> wrapper the client needs to read them as HTML, so the
-- tags showed as text. Found on the Humble Monument 195119 at Grol'dom Farm (page 3568, Olgra's grave; play test 2026-11-24).
-- The other 634 multi-line pages use plain newlines, the formatted ones a full <HTML><BODY> document.
-- Plain pages: <br /> becomes a newline. 3568 Humble Monument (Northern Barrens), 3577/3578 Secret Lab (Azshara), 3616-3621
-- Electra-atrocity tome, 3737-3742 the old god sample notes, 3744 Prototype Reaper manual, 3755 Airbase-in-a-Box.
UPDATE `page_text` SET `text`=REPLACE(`text`,'<br />','\n')
WHERE `entry` IN (3568,3577,3578,3616,3617,3619,3620,3621,3737,3739,3740,3742,3744,3755);
-- 3567 (memorial 195014, Darkshore) uses centred <h1> headings: keep them and wrap the page as an HTML document.
UPDATE `page_text` SET `text`='<HTML>\n<BODY>\n<BR/><BR/>\n<H1 align="center">In Memory</H1>\n<BR/>\n<H1 align="center">Shaldyn, Gershala, Volcor</H1>\n<H1 align="center">and those who never made it home.</H1>\n</BODY>\n</HTML>'
WHERE `entry`=3567;
