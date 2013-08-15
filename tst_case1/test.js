function main() {
    source(findFile("scripts","PageObject.js"));
    
    startApplication("LiverAblation"); 
    var derp = new StatusBar("SethUrban");
    
    
    waitForObject(derp._locator);
    
   
}

