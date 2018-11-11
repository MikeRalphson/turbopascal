// Tracks a list of native functions that can be called from Pascal.

if (typeof define !== 'function') { var define = require('amdefine')(module) };

define(function () {
    var Native = function () {
        // List of NativeProcedure objects. The index within the array is the
        // number passed to the "CSP" instruction.
        this.nativeProcedures = [];
    };

    // Adds a native method, returning its index.
    Native.prototype.add = function (nativeProcedure) {
        var index = this.nativeProcedures.length;
        this.nativeProcedures.push(nativeProcedure);
        return index;
    };

    // Get a native method by index.
    Native.prototype.get = function (index) {
        return this.nativeProcedures[index];
    };

    return Native;
});
