const express = require('express');
// const cookieParser = require('cookie-parser');
const bodyParser = require('body-parser');
const path = require('path');
const exec = require('child_process').exec;
const utils = require('./utils');

const app = express();

/*
 *  EXPRESS CONFIG
 */

app.use(express.static(path.join(__dirname, '../build_webpack')));

// app.use(cookieParser());
app.use(bodyParser.json({ limit: '50mb' }));
app.use(bodyParser.urlencoded({ extended: true }));

// const cors = require('cors');
// app.use(cors());

// TODO: Create routes to run bash scripts
app.get('/script', (req, res) => {
  exec('~/Documents/12launch.sh',
    function (error, stdout, stderr) {
      console.log('stdout: ' + stdout);
      console.log('stderr: ' + stderr);
      if (error !== null) {
        console.log('exec error: ' + error);
      }
    });
});

app.get('/test_genesis', (req, res) => {

    exec('./server/scripts/generate_genesis_pow.sh name12 12',
    function (error, stdout, stderr) {
      console.log('stdout: ' + stdout);
      console.log('stderr: ' + stderr);
      if (error !== null) {
        console.log('exec error: ' + error);
      }
    });
});


app.get('/getExample', (req, res) => {
  res.status(200).send('/getExample response');
});

app.get('/get_state', (req, res) => {
  res.status(200).send(utils.get_state());
});

app.get('/save_state', (req, res) => {
  res.status(200).send(utils.save_state());
});


app.post('/postExample', (req, res) => {
  console.log(req.body);
  res.status(200).send(`/postExample response: ${JSON.stringify(req.body)}`);
});

app.get('/:bad*', (req, res) => {
  res.status(404).send(`Resource not found '${req.params.bad}'`);
});


app.listen(process.env.PORT || 5000, () => {
  console.warn('Backend server listening on port 5000!');
});