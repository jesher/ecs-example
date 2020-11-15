import express, { response } from 'express';

const app = express()

app.get('/', (request, response) => {
    return response.json({message: "test api ok!"})
})

app.listen(3000, () =>{
    console.log('server started on port 3000!')
})
