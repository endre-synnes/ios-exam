# iOS Exam 2018


## Oversikt

I min besvarelse av denne eksamen har jeg fullført samtlige oppgaver og infridd alle krav som er gitt i disse. 

Jeg har lagt hovedfokus på å implementere så mange funksjoner som mulig, samt skrive kode som er gost struktrert og etter generelle retningslinjer.

Jeg har i stor grad forsøkt å følge prinsippet for MVC, Jeg har laget egne mapper/groups for Model objekter, Controllere og Views.

For å unngå alt for mye repetisjon av kode har jeg fosøkt å delegere noe logikk ut til hjelpe-metoder. Eksempler på dette er blant annet hjelpemetoden for å sjekke om telefonen har internettilkobling (noe mang trenger for å dra nytte av denne appen), samt det å hente data fra Swars APi-et.

## Oppgaver

- [x] Oppgave 1 (filmer)
        - Vise all filmer
        - Detailvisning for film
        - Minst 4 datapunkter for detailjer
- [x] Oppgave 2 (karakterer)
        - Data fra 3 sider i API-et
        - CollectionView med to kolonner
        - Bytte farge på selle basert på om du har markert en karakter som favoritt
- [x] Opgpave 3 (legge til/fjerne favoritter)
        - Legg til/fjern knapp i film-detailer
        - Lagre dette i Core Data
        - Lagre/fjerne karakter fra favoritter ved å klikke på selle i karakterer vinduet.
- [x] Oppgave 4 (Favoritter tab)
        - Vise liste over favoritter (filmer og karakterer)
        - Bruke UISegmentedControl for å bytte mellom filmer og karakterer
        - Bruke NSFEtchedResultController for å levere data til TableView
        - Sortert alfabetisk.
        - Holde listen opdpatert automatisk
        - Vise detaljer visning for filmer fra favoritter-tab også
- [x] Oppgave 5 (Filmer en favorittkarakter er med i)
        - Vise episode id han/hun/det er med i.
        - Når man trykker på en karakter i favoritt-tab-en skal det vises filmnavn på filmene han/hun/det er med i.
        - En fjern-knapp som kan fjerne en karakter fra favoritter når man trykker på en selle i favoritter-tab-en.
        - Listen skal oppdateres dersom en karater fjernese eller blir lagt til.
- [x] Oppgave 6 ("Smart" filmanbefaling)
        - Lage et custom view som viser en anbefaling, basert på de filmene som det finnes flest favoritt karakterer med i.
        - Vise anbefaling tekst med forskjellige navn på "hvem" som anbefaler filmen.

## Refleksjon

Jeg ser at det er et stort potensiale til å forbedre koden og gjøre den mer effektiv, men med mine begrensede swift kunnskaper er jeg svært fornøyd med resultatet jeg her leverer.

Det er flere steder i koden jeg kunne unngått repetisjon hadde jeg hatt bedre kjennskap til swift og iOS utvikling, samt hatt mer tid.

Jeg har fullført alle oppgaver samt alle krav. Jeg har også forøskt å følge MVC og følge standard prinsipper for god kodestruktur. Jeg mener denne besvarelsen er i tråd med det man kan forvente av den kunnskapen man kan har tilgenet seg etter dette kurset.

## Kilder

[NSFetchedResultsController tutorial](https://cocoacasts.com/populate-a-table-view-with-nsfetchedresultscontroller-and-swift-3)

[Finne objektet som det finnes mest av i et array](https://stackoverflow.com/questions/38416347/getting-the-most-frequent-value-of-an-array)

[Slette rad i tabell](https://stackoverflow.com/questions/8974740/delete-row-in-table-view-with-fetchedresultcontroller)

[NSFetchedResultsController](https://developer.apple.com/documentation/coredata/nsfetchedresultscontroller)

[Slette fra tebell med NSFetchedResultsController](https://stackoverflow.com/questions/5863724/an-nsmanagedobjectcontext-cannot-delete-objects-in-other-contexts)
