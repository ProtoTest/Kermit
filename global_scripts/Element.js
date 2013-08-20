/* Element.js
 * @param {Object} symbolicName
 * @return {Object}
 */
function Element(symbolicName) {
    var symName = symbolicName;
    var realName = objectMap.realName(symName);
    try {
        var elementObject = findObject(symName);
        var properties = object.properties(elementObject);
    } catch(e) {
        test.log(symName + ": " + e.message);
    }
    
    this.getSymName = function(){
        return symName;
    }
    
    this.getRealName = function() {
        return realName;
    }
    
    this.getProperties = function() {
        return properties;
    }
}

Element.prototype = {
    click : function() {
        mouseClick(this.getSymName());
    },

    getProperty : function(propName) {
        properties = this.getProperties();
        if(properties[propName]) {
            return properties[propName];
        } else {
            test.log(propName + " property does not exist for element: " + this.getSymName());
            return undefined;
        }
    }
}