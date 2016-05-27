require('coffee-script/register');

var config = {
  prefix: '',
  srcDir: 'app',
  staticDir: 'static',
  devDir: '_dev',
  prodDir: '_prod',
  flavor: 'ember'
};

var tasks = require('fs').readdirSync(__dirname + '/gulp/tasks/');

tasks.forEach(function (task) {
  require(__dirname + '/gulp/tasks/' + task)(config);
})
