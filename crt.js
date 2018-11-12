// The CRT sub-system.

if (typeof define !== 'function') { var define = require('amdefine')(module) };

define(["./Node"], function (Node) {
    var importSymbols = function (symbolTable) {
        // Keyboard functions.
        symbolTable.addNativeFunction("KeyPressed", Node.booleanType, [], function (ctl) {
            return ctl.keyPressed();
        });
        symbolTable.addNativeFunction("ReadKey", Node.charType, [], function (ctl) {
            return ctl.readKey();
        });

        // Sound functions.
        symbolTable.addNativeFunction("Sound", Node.voidType, [Node.integerType],
                                      function (ctl, hz) {
            // Not implemented.
        });
        symbolTable.addNativeFunction("NoSound", Node.voidType, [], function (ctl) {
            // Not implemented.
        });

	symbolTable.addNativeVariable("CheckSnow", false, Node.booleanType);

	symbolTable.addNativeVariable("DirectVideo", false, Node.booleanType);

	symbolTable.addNativeVariable("TextAttr", 7, Node.integerType);

        symbolTable.addNativeFunction("ClrScr", Node.voidType, [], function (ctl) {
            // Not implemented.
        });

        symbolTable.addNativeFunction("ClrEOL", Node.voidType, [], function (ctl) {
            // Not implemented.
        });

        symbolTable.addNativeFunction("NormVideo", Node.voidType, [], function (ctl) {
            // Not implemented.
        });

        symbolTable.addNativeFunction("Window", Node.voidType, [Node.integerType, Node.integerType, Node.integerType, Node.integerType], function (ctl, x1, y1, x2, y2) {
            // Not implemented.
        });

        symbolTable.addNativeFunction("GotoXY", Node.voidType, [Node.integerType, Node.integerType], function (ctl, x, y) {
	    ctl.ansi().goto(x, y);
        });

    };

    return {
        importSymbols: importSymbols
    };
});
