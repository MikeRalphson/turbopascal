// Builtin symbols, such as "Sin()" and "Pi".

'use strict';

if (typeof define !== 'function') { var define = require('amdefine')(module) };

define(["./Node", "./Token", "./inst"], function (Node, Token, inst) {
    // Special handling of Random() because its return type depends on whether
    // it has an argument.
    var builtinRandom = function (ctl, t) {
        if (t === undefined) {
            return Math.random();
        } else {
            return Math.round(Math.random()*t);
        }
    };

    return {
        // Import all the symbols for the builtins.
        importSymbols: function (symbolTable) {
            // Built-in types.
            symbolTable.addNativeType("String", Node.stringType);
            symbolTable.addNativeType("Integer", Node.integerType);
            symbolTable.addNativeType("ShortInt", Node.integerType);
            symbolTable.addNativeType("Byte", Node.integerType);
            symbolTable.addNativeType("Word", Node.integerType);
            symbolTable.addNativeType("LongInt", Node.integerType);
            symbolTable.addNativeType("Char", Node.charType);
            symbolTable.addNativeType("Boolean", Node.booleanType);
            symbolTable.addNativeType("Real", Node.realType);
            symbolTable.addNativeType("Double", Node.realType);
            symbolTable.addNativeType("Pointer", Node.pointerType);

            // Constants and functions.
            symbolTable.addNativeConstant("Nil", null,
                new Node(Node.SIMPLE_TYPE, new Token("Nil", Token.IDENTIFIER), {
                    typeCode: inst.A,
                    typeName: null,  // Important -- this is what makes this nil.
                    type: null
            }));
            symbolTable.addNativeConstant("True", true, Node.booleanType);
            symbolTable.addNativeConstant("False", false, Node.booleanType);
            symbolTable.addNativeConstant("Pi", Math.PI, Node.realType);
            symbolTable.addNativeFunction("Sin", Node.realType, [Node.realType],
                        function (ctl, t) { return Math.sin(t); });
            symbolTable.addNativeFunction("Cos", Node.realType, [Node.realType],
                        function (ctl, t) { return Math.cos(t); });
            symbolTable.addNativeFunction("Round", Node.integerType, [Node.realType],
                        function (ctl, t) { return Math.round(t); });
            symbolTable.addNativeFunction("Trunc", Node.integerType, [Node.realType],
                        function (ctl, t) { return (t < 0) ? Math.ceil(t) : Math.floor(t); });
            symbolTable.addNativeFunction("Odd", Node.booleanType, [Node.integerType],
                        function (ctl, t) { return Math.round(t) % 2 !== 0; });
            symbolTable.addNativeFunction("Abs", Node.realType, [Node.realType],
                        function (ctl, t) { return Math.abs(t); });
            symbolTable.addNativeFunction("Sqrt", Node.realType, [Node.realType],
                        function (ctl, t) { return Math.sqrt(t); });
            symbolTable.addNativeFunction("Ln", Node.realType, [Node.realType],
                        function (ctl, t) { return Math.log(t); });
            symbolTable.addNativeFunction("Sqr", Node.realType, [Node.realType],
                        function (ctl, t) { return t*t; });
            symbolTable.addNativeFunction("Random", Node.realType, [], builtinRandom);
            symbolTable.addNativeFunction("Randomize", Node.voidType, [],
                        function (ctl) { /* Nothing. */ });
            var symbol = symbolTable.addNativeFunction("Inc", Node.voidType,
                [Node.integerType, Node.integerType], function (ctl, v, dv) {

                if (dv === undefined) {
                    dv = 1;
                }
                ctl.writeDstore(v, ctl.readDstore(v) + dv);
            });
            symbol.type.parameters[0].byReference = true;

            var symbol = symbolTable.addNativeFunction("Succ", Node.integerType,
                [Node.integerType], function (ctl, v) {
                ctl.writeDstore(v, ctl.readDstore(v) + 1);
            });

            var symbol = symbolTable.addNativeFunction("Pred", Node.integerType,
                [Node.integerType], function (ctl, v) {
                ctl.writeDstore(v, ctl.readDstore(v) - 1);
            });

            var symbol = symbolTable.addNativeFunction("UpCase", Node.charType,
                [Node.charType], function (ctl, v) {
                ctl.writeDstore(v, ctl.readDstore(v).toUpperCase());
            });

            symbolTable.addNativeFunction("Write", Node.voidType, [], function (ctl) {
                // Skip ctl parameter.
                var elements = [];
                for (var i = 1; i < arguments.length; i++) {
                    // Convert to string.
                    elements.push("" + arguments[i]);
                }
                ctl.write(elements.join("")); // was " "
            });
            symbolTable.addNativeFunction("WriteLn", Node.voidType, [], function (ctl) {
                // Skip ctl parameter.
                var elements = [];
                for (var i = 1; i < arguments.length; i++) {
                    // Convert to string.
                    elements.push("" + arguments[i]);
                }
                ctl.writeln(elements.join("")); // was " "
            });
            symbolTable.addNativeFunction("ReadLn", Node.stringType, [], function (ctl) {
                // Suspend the machine so that the browser can get keys to us.
                ctl.suspend();

                // Ask the IDE to read a line for us.
                ctl.readln(function (line) {
                    ctl.push(line);
                    ctl.resume();
                });

                // We're a function, so we should return something, but we've
                // suspended the machine, so it doesn't matter.
            });
            symbolTable.addNativeFunction("Halt", Node.voidType, [], function (ctl) {
                // Halt VM.
                ctl.stop();
            });
            symbolTable.addNativeFunction("Delay", Node.voidType, [Node.integerType],
                                          function (ctl, ms) {
                // Tell VM to delay by ms asynchronously.
                ctl.delay(ms);
            });

            symbol = symbolTable.addNativeFunction("GetTime", Node.voidType, [Node.integerType,
                Node.integerType, Node.integerType, Node.integerType, Node.integerType],
                                          function (ctl, hour, min, sec, hun) {
                let now = new Date();
                hour = now.getHours();
                min  = now.getMinutes();
                sec  = now.getSeconds();
                hun  = now.getMilliseconds()/10.0;
            });
            symbol.type.parameters[0].byReference = true;
            symbol.type.parameters[1].byReference = true;
            symbol.type.parameters[2].byReference = true;
            symbol.type.parameters[3].byReference = true;

            symbol = symbolTable.addNativeFunction("GetDate", Node.voidType, [Node.integerType,
                Node.integerType, Node.integerType, Node.integerType, Node.integerType],
                                          function (ctl, year, mon, day, dow) {
                let now = new Date();
                year = now.getYear();
                mon  = now.getMonth();
                day  = now.getDay();
                dow  = now.getDOW;
            });
            symbol.type.parameters[0].byReference = true;
            symbol.type.parameters[1].byReference = true;
            symbol.type.parameters[2].byReference = true;
            symbol.type.parameters[3].byReference = true;

            symbol = symbolTable.addNativeFunction("New", Node.voidType,
                                          [Node.pointerType, Node.integerType],
                                          function (ctl, p, size) {

                // Allocate and store address in p.
                ctl.writeDstore(p, ctl.malloc(size));
            });
            symbol.type.parameters[0].byReference = true;
            symbol = symbolTable.addNativeFunction("GetMem", Node.voidType,
                                          [Node.pointerType, Node.integerType],
                                          function (ctl, p, size) {

                // Allocate and store address in p.
                ctl.writeDstore(p, ctl.malloc(size));
            });
            symbol.type.parameters[0].byReference = true;
            symbol = symbolTable.addNativeFunction("Dispose", Node.voidType,
                                          [Node.pointerType],
                                          function (ctl, p) {

                // Free p and store 0 (nil) into it.
                ctl.free(ctl.readDstore(p));
                ctl.writeDstore(p, 0);
            });
            symbol.type.parameters[0].byReference = true;
            symbol = symbolTable.addNativeFunction("SizeOf", Node.integerType,
                                          [Node.recordType],
                                          function (ctl, p) {
		return p.getTypeSize();
            });
            symbol.type.parameters[0].byReference = true;
            symbolTable.addNativeFunction("Chr", Node.charType, [Node.integerType],
                        function (ctl, i) { return String.fromCharCode(i); });
        }
    };
});
