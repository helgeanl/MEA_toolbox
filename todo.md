### Raw data til spike data: 
Det hender at Multichannel Experimenter setter thresholds som er helt off. Siden funksjonene for rasterplot og Mean firing rate i toolboxen bygger på spike detection filene derfra, er det nå noen av opptakene som må ekskluderes fordi thresholden er satt feil der. 
Det burde derfor utvikles egen kode for spike detection, hvor man tar gjennomsnittet av amplituden fra hver enkelt elektrode for et helt opptak, og setter spikene til +/- 5 standardavvik fra dette gjennomsnittet.

Mulig fremgangsmåte:
* regne ut threshold
* Finne spiker f.eks. på synkende flanke på negativ threshold, og stigende flanke på positiv threshold.
* Mulighet for å lagre spikes i en ny fil, og/eller lagre det i en variabel tilsvarende et TimeStamp objekt/ cell array, eller overskrive den orginale filen. Hvis filen overskrives trengs det ikke gjøres noe annet, men hvis det bare lages en ny fil/ ny variabel bør det passes på at rett spikes lastes inn når MFR o.l. kjøres. 
* Legge til en knapp, parametre o.l. inn i GUI (f.eks. et nytt tab-panel i venstre del)
* Lagre timestamps for bunnpunktet i spiken, ikke bare punktet for thresholden.
