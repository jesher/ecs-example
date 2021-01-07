require('dotenv').config()

import express from 'express';
import {exec} from 'child_process';

const app = express()

app.get('/v1/healthcheck', (request, response) => {
    console.log(request.header('x-forwarded-for') || request.connection.remoteAddress)
    return response.json({message: "test api ok!", tag_image: process.env.HASH_COMMIT})
})

app.get('/v1/test', (request, response) => {
    exec('stress --cpu 8 --io 4 --vm 4 --vm-bytes 1024M --timeout 10s', (err, stdout, stderr) => {
        if (err) {
          // node couldn't execute the command
          return;
        }
      
        // the *entire* stdout and stderr (buffered)
        console.log(`stdout: ${stdout}`);
        console.log(`stderr: ${stderr}`);
      });

    return response.json({message: "test api ok!", tag_image: process.env.HASH_COMMIT})
})

app.listen(3000, () =>{
    console.log('server started on port 3000!')
})
