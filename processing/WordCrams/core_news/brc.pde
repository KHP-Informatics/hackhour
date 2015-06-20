import wordcram.*;

void setup(){
String[] fontList = PFont.list();
println(fontList);
PFont georgiaItalic = createFont("Georgia Italic", 1);
PFont font = createFont("TansanHir",1);

size(700, 700);
//background(255);



/* If WordCram's convenience methods for styling words
 * don't provide what you need, you can use its more
 * general methods instead: withColorer, withAngler,
 * withFonter.
 *
 * See the javadoc for more options:
 * - http://wordcram.googlecode.com/svn/javadoc/wordcram/Colorers.html
 * - http://wordcram.googlecode.com/svn/javadoc/wordcram/Anglers.html
 * - http://wordcram.googlecode.com/svn/javadoc/wordcram/Fonters.html
 */
try{
new WordCram(this)
  .fromWebPage("http://core.brc.iop.kcl.ac.uk/news/")
//.withPlacer(Placers.centerClump())
  //.withPlacer(Placers.horizLine())
  //.withPlacer(Placers.horizBandAnchoredLeft())
  //.withPlacer(Placers.swirl())
  .withFont(font)
  .withColorer(Colorers.twoHuesRandomSatsOnWhite(this))
  .sizedByWeight(7, 100)
  //  
  // For this one, try setting the sketch size to 1000x1000.
  //.withPlacer(Placers.swirl())
  //.sizedByWeight(8, 30)
  .withPlacer(Placers.wave())
  //.withPlacer(Placers.upperLeft())
  //.sizedByWeight(2, 60)
    
  .excludeNumbers()
  .lowerCase()
  // Words at Angles
  //.angledAt(radians(30))
  //.angledAt(radians(30), radians(-60))
  
  // Two-thirds of the words will be at 30 degrees, the rest at -60.
  //.angledAt(radians(30), radians(30), radians(-60))
  
  //.angledBetween(-PI/8, PI/8)
  //.angledBetween(0, TWO_PI)
  
  //-----------
  // Colorers
  //.withColorer(Colorers.alwaysUse(#0000AA))
  //.withColorer(Colorers.twoHuesRandomSatsOnWhite(this))
  //.withColorer(Colorers.pickFrom(#FF0000, #00CC00, #0000FF))
  //.withColorer(Colorers.alwaysUse(color(0, 20, 150, 150)))
  
  //-----------
  // Anglers
  //.withAngler(Anglers.horiz())
  //.withAngler(Anglers.heaped())
  //.withAngler(Anglers.hexes())
  //.withAngler(Anglers.upAndDown())
  //.withAngler(Anglers.randomBetween(0, PI/8))
  
  //---------
  // Fonters
  .withFonter(randomFonter())
  //.withFonter(Fonters.pickFrom(georgia, georgiaItalic))
  // Fonts
  //.withFont("TansanHir-48")
  //.withFont(georgia)
  //.withFont(georgiaItalic)
  //.withFont(minyaNouvelle)
  //.withFonts("Georgia", "Minya Nouvelle")
  //.withFonts(georgia, minyaNouvelle)
  
  //---------
  // Padding
  //.withWordPadding(2)
  
  .toSvg("brc_bifo_core_news.svg",width,height)
  .drawAll();
}catch(java.io.FileNotFoundException x){
   println(x.getMessage()); 
}

PShape sh = loadShape("brc_bifo_core_news.svg");
//background(255);
shape(sh,0,0);

};

WordFonter randomFonter() {
  final PFont payday = createFont("Payday", 1);
  final PFont chlorix = createFont("Chlorix", 1);
  final PFont incopins = createFont("IncopinsClustersB", 1);
  
  return new WordFonter() {
    public PFont fontFor(Word word) {
      if (word.word.length() <= 5) {
        return payday;
      }else if (word.word.length() > 5 && word.word.length() <= 6) {
        return chlorix;
      }else{
        return incopins;
      }
    }
  };
}
