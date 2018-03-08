
var exec = require("cordova/exec");

var BackgroundTask = function () {
    this.name = "BackgroundTask";
};

BackgroundTask.prototype.start = function (task) {
    exec(task, null, "BackgroundTask", "start", []);
};

BackgroundTask.prototype.finish = function (taskId, task) {
    exec(task, null, "BackgroundTask", "finish", [ taskId ]);
};

module.exports = new BackgroundTask();
