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
    }
}

module.exports = utils;




