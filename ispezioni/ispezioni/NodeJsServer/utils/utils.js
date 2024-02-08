utils = {
    getXmlValueByTagName: function(string, tag){
        var re = new RegExp(`<${tag}>(.*?)<\/.*${tag}>`, "gmi");
        var res = re.exec(string);
        if(res)
            return res[1];
        return null;
    },

    getNestedXmlValueByTagName: function(string, tag){
        var re = new RegExp(`<${tag}>(.*?)<.*${tag}>`, "gmi");
        var res = re.exec(string);
        if(res)
            return res[0];
        return null;
    },

    escapeDoubleQuotes: function(jsonObject) {
        const escapedObject = {};
    
        for (const key in jsonObject) {
            if (jsonObject.hasOwnProperty(key)) {
                const value = jsonObject[key];
    
                // If the value is a string, replace double quotes with escaped double quotes
                if (typeof value === 'string') {
                    escapedObject[key] = value.replace(/"/g, '\\"');
                } else if (typeof value === 'object') {
                    // If the value is an object, recursively escape double quotes
                    escapedObject[key] = this.escapeDoubleQuotes(value);
                } else {
                    // If the value is not a string or object, leave it unchanged
                    escapedObject[key] = value;
                }
            }
        }
    
        return escapedObject;
    }
}

module.exports = utils;




