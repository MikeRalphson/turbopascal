// Modules available for import, such as "__builtin__" and "graph".

if (typeof define !== 'function') { var define = require('amdefine')(module) };

define(["./builtin", "./crt", "./graph", "./mouse", "./PascalError"],
       function (builtin, crt, graph, mouse, PascalError) {

    var importModule = function (name, symbolTable) {
        switch (name.toLowerCase()) {
            case "__builtin__":
                builtin.importSymbols(symbolTable);
                break;
            case "crt":
                crt.importSymbols(symbolTable);
                break;
            case "dos":
                // I don't know what goes in here.
                break;
            case "graph":
                graph.importSymbols(symbolTable);
                break;
            case "mouse":
                mouse.importSymbols(symbolTable);
                break;
            case "printer":
                // I don't know what goes in here.
                break;
            default:
                throw new PascalError(null, "unknown module " + name);
        }
    };

    return {
        importModule: importModule
    };
});
