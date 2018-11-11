#!/usr/bin/env node

'use strict';

const fs = require('fs');
const path = require('path');
const util = require('util');
const compiler = require('./tpc.js');

if (process.argv.length<2) {
  console.log('Usage: turbo {sourcefile}');
  process.exit(1);
}

let s = process.argv[2];
let source = fs.readFileSync(s,'utf8');
//console.log(source);
let result = compiler.compile(source,true);

//console.log(JSON.stringify(result,null,2));

let oname = './'+path.basename(s).replace('.PAS','.P').replace('.pas','.p');
fs.writeFileSync(oname,result.pSrc,'utf8');

//console.log(util.inspect(result.bytecode,{depth:null}));
