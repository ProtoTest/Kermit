function StatusBar(username) {
    this._username = username;
    this._locator = "{container=':Upslope Demo.Form_StatusBarForm' name='userLabel2' text='"+username+"' type='QLabel' visible='1'}";
    }

    StatusBar.prototype.getLoc = new function()
    {
        return this._locator;
    };