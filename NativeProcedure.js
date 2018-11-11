// The object that's stored in the Native store.

if (typeof define !== 'function') { var define = require('amdefine')(module) };

define(function () {
    // Object that's stored in the Native array.
    var NativeProcedure = function (name, returnType, parameterTypes, fn) {
        this.name = name;
        this.returnType = returnType;
        this.parameterTypes = parameterTypes;
        this.fn = fn;
    };

    return NativeProcedure;
});
