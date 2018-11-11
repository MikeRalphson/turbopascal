// Main program of IDE-based compiler.

'use strict';

require.config({
    urlArgs: "bust=" + (new Date()).getTime(),
    paths: {
        "jquery": "vendor/jquery-1.10.1.min",
        "underscore": "vendor/underscore-1.5.2.min"
    }
});

require(["jquery", "Screen", "Keyboard", "IDE"], function ($, Screen, Keyboard, IDE) {
    var $screen = $("#screen");
    var screen = new Screen($screen);
    var keyboard = new Keyboard();
    $.ajax('./files.json',{
        dataType: "json",
        isLocal: true,
        error: function (e) {
            var ide = new IDE(screen, keyboard, []);
            ide.printMenu();
            ide.screen.printBold("File can't be loaded: files.json");
            ide.screen.newLine();
            ide.printPrompt();
        },
        success: function (files) {
            var ide = new IDE(screen, keyboard, files);
            ide.printMenu();
        }
    });
});
