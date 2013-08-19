source(findFile("scripts","ScreenObject.js"));

function main() {
    startApplication("LiverAblation");
     
    var stupid = startScreen.searchfFor("herpderp");
    var someProperty = findObject(":Form.logo_QLabel").hasOwnProperty("x").toString();
    test.log(applicationContext("LiverAblation").usedMemory.toString());
}

