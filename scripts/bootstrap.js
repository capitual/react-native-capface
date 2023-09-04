const os = require('os');
const path = require('path');
const child_process = require('child_process');

const root = path.resolve(__dirname, '..');
const args = process.argv.slice(2);
const options = {
  cwd: process.cwd(),
  env: process.env,
  stdio: 'inherit',
  encoding: 'utf-8',
};

if (os.type() === 'Windows_NT') {
  options.shell = true;
}

let result;

if (process.cwd() !== root || args.length) {
  // We're not in the root of the project, or additional arguments were passed
  // In this case, forward the command to `npm`
  result = child_process.spawnSync('npm', args, options);
} else {
  // If `npm` is run without arguments, perform bootstrap
  result = child_process.spawnSync('npm', ['bootstrap'], options);
}

process.exitCode = result.status;
