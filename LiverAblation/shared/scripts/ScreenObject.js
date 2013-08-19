source(findFile("scripts","thing.js"));

   
var baseScreen = {   
    
    doSomething: function(){
        mouseClick("{column='1' container=':Form.customTreeWidget_CustomTreeWidget' text='1.3.6.1.4.1.9328.50.3.0537' type='QModelIndex'}");
        return startScreen;
    },
    doSomethingElse: function(){
        mouseClick("{container=':customTreeWidget.frame_QFrame_2' name='openPlanButton' text='Open Plan' type='QPushButton' visible='1'}");
        return startScreen;
    },
    enterText: function(thing, someText){
        mouseClick(waitForObject(thing));
        type(waitForObject(thing), someText);
        return startScreen;
    },
    grabScreen: function(thing){
        widget = waitForObject(thing);
        img = grabWidget(widget);
        img.save("C:\\Users\\SethUrban\\suite_LiverAblation_POC_2\\tst_case1\\kermit_screenshot.png", "PNG");
    }
}



var startScreen = {
    base:  baseScreen,
    textbox: new thing(":Form.search_QLineEdit", ":Form.search_QLineEdit"),
    
    searchfFor: function(sometext){
        this.base.enterText(this.textbox._location, sometext);
        this.base.grabScreen(this.textbox._location);
    }
}









