<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns="http://www.w3.org/1999/xhtml"
                version="2.0">

    <xsl:output method="html" indent="yes"/>
    <xsl:preserve-space elements="p"/>
    <!-- Pagina html che, all'apertura, visualizza titolo, blocco main e footer. Nel blocco main sono elencati gli articoli codificati per il progetto. Ciascuno di essi è cliccabile e rende visibile il div che contiene articolo e immagini corrispondenti, che si apre sotto l'elenco degli articoli.
    -->

    <xsl:template match="/">
        <html>
            <!-- Metadata della pagina HTML -->
            <head>
                <title>
                    <!-- Estrazione del titolo -->
                        <xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
                </title>
                <link rel="stylesheet" href="stile.css"/>
                <script src="script.js"></script>
                <script src="https://code.jquery.com/jquery-3.6.4.min.js" integrity="sha256-oP6HI9z1XaZNBrJURtCoUT5SUnxFr8s3BzRl+cbzUq8=" crossorigin="anonymous"></script>
                <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js" integrity="sha256-lSjKY0/srUM9BE3dPm+c4fBo1dky2v27Gdjm2uoZaL0=" crossorigin="anonymous"></script>
            </head>
            <body>
                <header>
                    <!-- Titolo -->
                    <h1 id="titPrincip">
                        <xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
                    </h1>
                    <h4>
                        <!-- i nostri nomi -->
                        <xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:respStmt"/>
                        <br/><br/>
                        <!-- la data dell'esame -->
                        <xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:date"/>
                    </h4>
                </header>
                <main>
                    <!-- Contenitore menù articoli (cliccabili) -->
                    <div id="menuArticoli">
                        <h3 id="h3Articoli">Seleziona l'articolo che vuoi visualizzare</h3>
                        <!-- Chiamo il template che visualizza titoli e informazioni degli articoli codificati -->
                            <xsl:apply-templates select="/tei:TEI//tei:body/tei:div[@type='article']"/>
                            <xsl:apply-templates select="/tei:TEI//tei:body/tei:div[@type='bibarticle']"/>
                        
                    </div>
                    <!-- Contenitore bibliografie-->
                    <!-- Contenitore persone, organizzazioni etc-->
                    <div id="bibliografie">
                        <h3 id="h3Bibl">Consulta l'Appendice dei nomi e la Bibliografia</h3>
                        <div class="appenBiblio" onclick="appAppBibl(appendice)">APPENDICE DEI NOMI</div>
                        <div id="appendice">
                            <xsl:apply-templates select="/tei:TEI//tei:back/tei:listPerson"/>
                        </div>
                        <div class="appenBiblio" onclick="appAppBibl(bibliografiaCompleta)">BIBLIOGRAFIA</div>
                        <div id="bibliografiaCompleta">
                            <xsl:apply-templates select="/tei:TEI//tei:back/tei:listBibl"/>
                        </div>
                    </div>
                    <div id="legenda">
                        <h3>Leggenda</h3>
                        <p class="personLeg">Nomi di persone reali - al clic rimandano all'Appendice</p>
                        <p class="ficPerson">Nomi di persone finzionali</p>
                        <p class="titleLeg">Titoli di opere e riviste - al clic rimanndano alla Bibliografia</p>
                        <p class="placeName">Nomi di luoghi</p>
                        <p class="orgName">Nomi di organizzazioni</p>
                        <p class="tema">Temi fondamentali del Verismo (istruzione, questione femminile, realismo-idealismo etc)</p>
                    </div>
                </main>
                <footer>
                    <p>
                        <!-- info Codifica -->
                        <xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:note"/>
                    </p>
                </footer>
            </body>
        </html>
    </xsl:template>

    <!-- Teplate che chiama titoli e date degli articoli (tutti tranne bibliografia, che ha una struttura diversa) -->
    <xsl:template match="/tei:TEI//tei:div[@type='article']">
        <div class="art">
            <xsl:attribute name="onclick">
                appArticoli(<xsl:value-of select="tei:div[@type='textarticle']/@xml:id"/>)
            </xsl:attribute>
            <!-- Assegna al div l'id dell'articolo corrispondente -->
            <xsl:attribute name="id">
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
            <!-- Selezione del volume al quale appartiene -->
            <p><xsl:value-of select="tei:div[@type='intestazione']"/></p>
            <!-- Selezione dell'head dell'articolo -->
            <p><xsl:value-of select="tei:div[@type='textarticle']/tei:head"/></p>
        </div>
        <!-- Un div per oggni coppia articolo+immagini, generato come sopra-->
        <div class="ArtImg">
            <!-- Assegna al div l'id del testo articolo corrispondente -->
                <xsl:attribute name="id">
                    <xsl:value-of select="tei:div[@type='textarticle']/@xml:id"/>
                </xsl:attribute>
                <!-- Estrae il testo dell'articolo -->
                <div class="testo">
                    <xsl:for-each select="tei:div[@type='textarticle']/tei:head/following-sibling::*">   
                    <!-- Per ogni sibling, chiama l'apply-templates -->
                        <p><xsl:apply-templates/></p>
                    </xsl:for-each>
                    <!-- <p><xsl:value-of select="tei:div[@type='textarticle']/tei:head/following-sibling::*"/></p> -->
                </div>
            </div>
    </xsl:template>

    <!-- Teplate che chiama titoli e date degli articoli della bibliografia !-->
    <xsl:template match="/tei:TEI//tei:div[@type='bibarticle']">
        <div class="art">
            <xsl:attribute name="onclick">
                appArticoli(<xsl:value-of select="tei:div[@type='textarticle']/@xml:id"/>)
            </xsl:attribute>
            <!-- Assegna al div l'id dell'articolo corrispondente -->
            <xsl:attribute name="id">
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
            <!-- Selezione del volume al quale appartiene -->
            <p><xsl:value-of select="tei:div[@type='intestazione']"/></p>
            <!-- Selezione dell'head dell'articolo -->
            <p><xsl:value-of select="tei:div[@type='textarticle']/tei:head"/></p>
        </div>
        <!-- Un div per oggni coppia articolo+immagini, generato come sopra-->
        <div class="ArtImg">
            <!-- Assegna al div l'id del testo articolo corrispondente -->
                <xsl:attribute name="id">
                    <xsl:value-of select="tei:div[@type='textarticle']/@xml:id"/>
                </xsl:attribute>
                <!-- Estrae il testo dell'articolo -->
                <div class="testo">
                    <xsl:for-each select="tei:div[@type='textarticle']/tei:head[@type='subtitle']/following-sibling::*">   
                        <!-- Per ogni div fratello di head, stampa il titolo e il contenuto -->
                            <h4><xsl:value-of select="tei:head"/></h4>
                            <xsl:for-each select="tei:p">
                                <p><xsl:apply-templates/></p>
                            </xsl:for-each>
                    </xsl:for-each>
                    <!-- <p><xsl:value-of select="tei:div[@type='textarticle']/tei:head/following-sibling::*"/></p> -->
                </div>
            </div>
    </xsl:template>

    <!-- Template per la visualizzazione dell'Appendice dei nomi -->
    <xsl:template match="/tei:TEI//tei:back/tei:listPerson">
        <!-- Suddivsione dell'appendice in articoli-->
        <h3 class="titoliAppendici"><xsl:value-of select="tei:head"/></h3>
            <xsl:for-each select="tei:person">
                <xsl:sort select="tei:persName/tei:surname"/>
                <div class="singolaBiblio">
                 <!-- Assegno a ogni div l'id della listPerson riferita -->
                    <xsl:attribute name="id">
                        <xsl:value-of select="@xml:id"/>
                    </xsl:attribute>
                    <p><xsl:apply-templates/></p>
                </div>
            </xsl:for-each>
    </xsl:template>

        <!-- Template per la visualizzazione della bibliografia finale -->
        <xsl:template match="/tei:TEI//tei:back/tei:listBibl">
            <!-- Suddivsione dell'appendice in articoli-->
            <h3 class="titoliAppendici"><xsl:value-of select="tei:head"/></h3>
                <xsl:for-each select="tei:biblStruct">
                    <xsl:sort select="tei:monogr/tei:author"/>                    
                    <div class="singolaBiblio">
                     <!-- Assegno a ogni div l'id della biblStruct riferita -->
                        <xsl:attribute name="id">
                            <xsl:value-of select="@xml:id"/>
                        </xsl:attribute>
                        <p><xsl:apply-templates/></p>
                    </div>
                </xsl:for-each>
        </xsl:template>

    <!-- Regole per opener -->
    <xsl:template match="tei:salute">
        <p><xsl:value-of select="."/></p>
    </xsl:template>

    <!-- Regole per le citazioni q -->
    <xsl:template match="tei:q">
        <q class="q"><xsl:value-of select="."/></q>
    </xsl:template>

    <!-- Regole per note. Capire come gestire il farla apparire passando il mouse sopra il testo corrispondente! -->
    <xsl:template match="tei:note">
        <span class="note"><xsl:value-of select="."/></span>
    </xsl:template>

    <!-- Regole per i persName -->
    <xsl:template match="tei:persName">
                    <!-- Assegno a ogni persName la funzione apriAppendice con l'id dell'entrate dell'appendice corrispondente -->
        <span class="person">
            <xsl:attribute name="onclick">
                apriAppendice(<xsl:value-of select="substring-after(@ref,'#')"/>)
            </xsl:attribute>
            <xsl:value-of select="."/>
        </span>
    </xsl:template>

    <!-- Regole per i persName fictional -->
    <xsl:template match="tei:persName[@type='fictional']">
                    <!-- Assegno a ogni persName la funzione apriAppendice con l'id dell'entrate dell'appendice corrispondente -->
        <span class="ficPerson">
            <xsl:value-of select="."/>
        </span>
    </xsl:template>

    <!-- Regole per i birth -->
    <xsl:template match="tei:birth">
        <p><xsl:value-of select="."/></p>
    </xsl:template>

    <!-- Regole per le occupation -->
    <xsl:template match="tei:occupation">
        <p><xsl:value-of select="."/></p>
    </xsl:template>

    <!-- Regole per i death -->
    <xsl:template match="tei:death">
        <p><xsl:value-of select="."/></p>
    </xsl:template>

    <!-- Regole per gli author -->
    <xsl:template match="tei:author">
        <p class="author"><xsl:value-of select="."/></p>
    </xsl:template>

    <!-- Regole per gli orgName -->
    <xsl:template match="tei:orgName">
        <span class="orgName"><xsl:value-of select="."/></span>
    </xsl:template>

    <!-- Regole per i persName -->
    <xsl:template match="tei:placeName">
        <span class="placeName"><xsl:value-of select="."/></span>
    </xsl:template>

    <!-- Regole per i foreign -->
    <xsl:template match="tei:foreign">
        <span class="foreign"><xsl:value-of select="."/></span>
    </xsl:template>

    <!-- Regole per gli imprint-->
    <xsl:template match="tei:imprint">
        <p><xsl:value-of select="concat(tei:publisher,',','&#032;',tei:pubPlace,',','&#032;',tei:date)"/></p>
    </xsl:template>

    <!-- Regole per gli respStmt-->
    <xsl:template match="tei:respStmt">
        <p><xsl:value-of select="concat(tei:resp,':','&#032;',tei:persName)"/></p>
    </xsl:template>
    
    <!-- Regole per le i bibl title -->
    <xsl:template match="tei:title">
        <span class="title">
            <xsl:attribute name="onclick">
                apriBibliografia(<xsl:value-of select="substring-after(@ref,'#')"/>)
            </xsl:attribute>
            <xsl:value-of select="."/></span>
    </xsl:template>


    <!-- Regole per le i ref tema -->
    <xsl:template match="tei:ref">
        <span class="tema"><xsl:value-of select="."/></span>
    </xsl:template>

</xsl:stylesheet>
