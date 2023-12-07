import express from 'express'
import dotenv from 'dotenv'
import authentication from './routes/authentication'
import { createConnection } from './services/connectiondb'

const app = express()
const port = 3000

dotenv.config()

createConnection()

app.use(express.json());

app.use('/authentication', authentication)

app.listen(port, () => {
	return console.log(`Express is listening at http://localhost:${port}`);
})