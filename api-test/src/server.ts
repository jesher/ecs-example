require('dotenv').config()

import express, { response } from 'express';

const app = express()

app.get('/v1/healthcheck', (request, response) => {
    return response.json({message: "test api ok!", tag_image: process.env.HASH_COMMIT})
})

app.listen(3000, () =>{
    console.log('server started on port 3000!')
})
